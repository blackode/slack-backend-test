defmodule Vhs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    ets_tables()

    children = [
      {Plug.Cowboy, scheme: :http, plug: Vhs.Router, options: [port: 4000]},
      Vhs.Servers.Transaction
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Vhs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp ets_tables() do
    :ets.new(:pending_transactions, [:set, :public, :named_table])
  end
end
