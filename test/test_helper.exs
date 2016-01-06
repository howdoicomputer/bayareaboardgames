ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Bayareaboardgames.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Bayareaboardgames.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Bayareaboardgames.Repo)

