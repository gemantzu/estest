defmodule Estest.Repo do
  use Ecto.Repo,
    otp_app: :estest,
    adapter: Ecto.Adapters.Postgres
end
