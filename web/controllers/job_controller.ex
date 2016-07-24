defmodule FetchMeIfYouCan.JobController do
  use FetchMeIfYouCan.Web, :controller

  alias FetchMeIfYouCan.Job

  plug :scrub_params, "job" when action in [:create, :update]

  def index(conn, _params) do
    jobs = Repo.all(Job)
    render(conn, "index.html", jobs: jobs)
  end

  def show(conn, %{"id" => id}) do
    job = Repo.get!(Job, id)
    render(conn, "show.html", job: job)
  end

  def delete(conn, %{"id" => id}) do
    job = Repo.get!(Job, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(job)

    conn
    |> put_flash(:info, "Job deleted successfully.")
    |> redirect(to: job_path(conn, :index))
  end
end
