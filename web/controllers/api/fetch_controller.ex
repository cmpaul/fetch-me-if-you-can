defmodule FetchMeIfYouCan.Api.FetchController do
  use FetchMeIfYouCan.Web, :controller
  require Logger

  alias FetchMeIfYouCan.Job

  def fetch(conn, %{"url" => url}) do
    # TODO: Validation of the url
    # Generate an ID to monitor the job
    jid = UUID.uuid4(:hex)

    # Kick off worker
    case Exq.enqueue(Exq, "default", "FetchMeIfYouCan.Fetcher", [url, jid]) do
      {:ok, exq_id} ->
        Logger.info "Started worker #{exq_id} to fetch: #{url}"
        # Build the changeset to store to the database
        changeset = Job.changeset(%Job{}, %{job_id: jid, url: url})
        case Repo.insert(changeset) do
          {:ok, job} ->
            # Render the success message
            render_accepted_job(conn, job)
          {:error, changeset} ->
            conn
              |> put_resp_content_type("application/json")
              |> render("error.json", changeset.errors)
        end
      {:error, reason} ->
        conn
          |> put_resp_content_type("application/json")
          |> render("error.json", reason)
    end
  end

  defp render_accepted_job(conn, job) do
    conn
      |> put_status(202) # Accepted
      |> put_resp_content_type("application/json")
      |> render("fetch.json", %{job: job})
  end

end
