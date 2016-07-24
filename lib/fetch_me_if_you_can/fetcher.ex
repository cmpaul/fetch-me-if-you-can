defmodule FetchMeIfYouCan.Fetcher do
  require Logger

  alias FetchMeIfYouCan.Repo
  alias FetchMeIfYouCan.Job

  @thumbnail_api ~s"https://www.googleapis.com/pagespeedonline/v1/runPagespeed?screenshot=true&url="

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
            fetch_thumbnail(url)
              |> Map.merge(%{content: Enum.join(for <<c::utf8 <- body>>, do: <<c::utf8>>), status: "success"})
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

  defp fetch_thumbnail(url) do
    case HTTPoison.get(@thumbnail_api <> URI.encode(url)) do
      {:ok, response} ->
        data = Poison.decode!(response.body)
        %{title: data["title"],
          thumbnail_data: Regex.replace(~r/-/, Regex.replace(~r/_/, data["screenshot"]["data"], "/"), "+"),
          thumbnail_mimetype: data["screenshot"]["mime_type"]}
      _ -> %{title: nil, thumbnail_data: nil, thumbnail_mimetype: nil}
    end
  end
end
