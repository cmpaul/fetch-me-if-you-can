defmodule FetchMeIfYouCan.Api.FetchView do
  use FetchMeIfYouCan.Web, :view

  def render("fetch.json", %{job: job}) do
    %{id: job.job_id,
      url: job.url,
      status: job.status}
  end

  def render("error.json", _params) do
    %{status: "error",
      content: "Bad request"}
  end
end
