defmodule FetchMeIfYouCan.Api.JobView do
  use FetchMeIfYouCan.Web, :view

  def render("job.json", %{job: job}) do
    %{id: job.job_id,
      url: job.url,
      status: job.status,
      title: job.title,
      content: job.content}
  end
end
