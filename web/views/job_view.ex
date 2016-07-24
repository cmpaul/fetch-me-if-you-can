defmodule FetchMeIfYouCan.JobView do
  use FetchMeIfYouCan.Web, :view

  def get_badge_class(status) do
    case status do
      "success" -> status
      "error" -> "danger"
      _ -> "default"
    end
  end
end
