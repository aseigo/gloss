defmodule Gloss.Repo do
  use Ecto.Repo,
    otp_app: :gloss,
    adapter: Ecto.Adapters.Postgres
end
