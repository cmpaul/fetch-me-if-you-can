defmodule FetchMeIfYouCan.Router do
  use FetchMeIfYouCan.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FetchMeIfYouCan do
    pipe_through :browser
    get "/", JobController, :index
    resources "/jobs", JobController
  end

  scope "/api", FetchMeIfYouCan do
    pipe_through :api
    get  "/job/*id", Api.JobController, :show
    post "/job", Api.JobController, :create
  end
end
