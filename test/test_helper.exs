ExUnit.start

Mix.Task.run "ecto.create", ~w(-r FetchMeIfYouCan.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r FetchMeIfYouCan.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(FetchMeIfYouCan.Repo)

