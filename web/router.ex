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
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/jobs", JobController
  end

  # Other scopes may use custom stacks.
  scope "/api", FetchMeIfYouCan do
    pipe_through :api

    get "/job", Api.JobController, :get_job
    get "/fetch", Api.FetchController, :fetch
  end
end
