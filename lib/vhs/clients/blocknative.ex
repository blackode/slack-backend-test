defmodule Vhs.Clients.Blocknative do
  use Tesla, only: [:post], docs: false

  @moduledoc """
  Interface to communicate with Blocknative's API
  Ideally the client_config will return api keys, network, etc...
  """

  require Logger

  @behaviour Vhs.Behaviors.BlocknativeClient

  @client_config Application.compile_env!(:vhs, :blocknative)
  alias Vhs.Servers.Transaction

  plug(Tesla.Middleware.BaseUrl, @client_config.base_url)
  plug(Tesla.Middleware.JSON, engine: Jason)
  plug(Tesla.Middleware.Query, [])

  @impl true
  def watch_tx(body) do
    default_body = %{
      "apiKey" => @client_config.api_key,
      "network" => @client_config.network,
      "blockchain" => @client_config.blockchain
    }

    body = Map.merge(default_body, body)

    post("/transaction", body)
    |> case do
      {:ok, %{body: %{"msg" => "success"}} = response} ->
        {:ok, _hash} = Transaction.register(body["hash"], "register")
        {:ok, response}

      {:error, error} ->
        Logger.error(
          "Received error trying to watch #{inspect(body.hash)} with reason #{inspect(error)}"
        )

        {:error, error}
    end
  end
end
