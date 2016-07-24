defmodule FetchMeIfYouCan.Fetcher do
  require Logger

  alias FetchMeIfYouCan.Repo
  alias FetchMeIfYouCan.Job
  @doc """
  Fetches a URL and saves it if the response is successful.

  ## Example

  iex> {:ok, jid} = Exq.enqueue(Exq, "default", "FetchMeIfYouCan.Fetcher", ["https://www.google.com/"])
  {:ok, "83996342-09d0-4e27-8000-b35ddc0d4037"}
  [info] Elixir.FetchMeIfYouCan.Fetcher[83996342-09d0-4e27-8000-b35ddc0d4037] start
  [info] Elixir.FetchMeIfYouCan.Fetcher[83996342-09d0-4e27-8000-b35ddc0d4037] done: 311ms sec

  This is helpful for testing: http://httpstat.us/
  """
  def perform(url, job_id) do
    job = Repo.get_by!(Job, job_id: job_id)
    params =
      try do
        case HTTPoison.get(url) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            capture_title = Regex.named_captures(~r/<title>(?<title>.*)<\/title>/, body)
            %{content: Enum.join(for <<c::utf8 <- body>>, do: <<c::utf8>>),
              status: "success",
              title: capture_title["title"]}
          {:ok, %HTTPoison.Response{status_code: 302}} ->
            %{content: "Received a redirect", status: "error"}
          {:ok, %HTTPoison.Response{status_code: 404}} ->
            %{content: "Not found", status: "error"}
          {:error, %HTTPoison.Error{reason: :nxdomain}} ->
            %{content: "Invalid URL", status: "error"}
          {_, response} ->
            Logger.debug inspect(response)
            %{content: "Unknown response, implement me!", status: "error"}
        end
      catch
        e -> %{content: e, status: "error"}
      end
    Job.changeset(job, params) |> Repo.update!
  end
end
