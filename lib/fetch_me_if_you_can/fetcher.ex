defmodule FetchMeIfYouCan.Fetcher do
  require Logger

  @doc """
  Fetches a URL and does something with it.

  ## Example

  iex> {:ok, jid} = Exq.enqueue(Exq, "default", "FetchMeIfYouCan.Fetcher", ["https://www.google.com/"])
  {:ok, "83996342-09d0-4e27-8000-b35ddc0d4037"}
  [info] Elixir.FetchMeIfYouCan.Fetcher[83996342-09d0-4e27-8000-b35ddc0d4037] start
  [info] Elixir.FetchMeIfYouCan.Fetcher[83996342-09d0-4e27-8000-b35ddc0d4037] done: 311ms sec
  """
  def perform(url) do
    HTTPoison.get!(url)
      |> inspect
      |> Logger.debug
  end
end
