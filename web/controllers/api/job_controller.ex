defmodule FetchMeIfYouCan.Api.JobController do
  use FetchMeIfYouCan.Web, :controller
  require Logger

  alias FetchMeIfYouCan.Repo
  alias FetchMeIfYouCan.Job

  def show(conn, %{"id" => [job_id | _]}) do
    job = Repo.get_by!(Job, job_id: job_id)
    render(conn, "show.json", %{job: job})
  end

  def create(conn, %{"url" => url}) do
    # Generate an ID to monitor the job
    jid = UUID.uuid4(:hex)

    # Build the changeset to store to the database
    changeset = Job.changeset(%Job{}, %{job_id: jid, url: url})
    case Repo.insert(changeset) do
      {:ok, job} ->
        # Kick off worker
        case Exq.enqueue(Exq, "default", "FetchMeIfYouCan.Fetcher", [url, jid]) do
          {:ok, _} -> render_accepted_job(conn, job)
          {:error, reason} -> render_error(conn, reason)
        end
      {:error, changeset} ->
        Logger.debug inspect(changeset)
        render_error(conn, "Oops")
    end
  end

  defp render_accepted_job(conn, job) do
    conn
      |> put_status(202) # Accepted
      |> put_resp_content_type("application/json")
      |> render("show.json", %{job: job})
  end

  defp render_error(conn, error) do
    conn
      |> put_resp_content_type("application/json")
      |> render("error.json", error)
  end
end
