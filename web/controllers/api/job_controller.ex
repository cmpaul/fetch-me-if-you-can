defmodule FetchMeIfYouCan.Api.JobController do
  use FetchMeIfYouCan.Web, :controller
  require Logger

  alias FetchMeIfYouCan.Repo
  alias FetchMeIfYouCan.Job

  def get_job(conn, %{"id" => [job_id | _]}) do
    job = Repo.get_by!(Job, job_id: job_id)
    render(conn, "job.json", %{job: job})
  end
end
