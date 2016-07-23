defmodule FetchMeIfYouCan.PageController do
  use FetchMeIfYouCan.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
