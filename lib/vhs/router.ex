defmodule Vhs.Router do
  @moduledoc """
  Main router of the application to handle incoming requests
  """

  use Plug.Router

  require Logger

  alias Vhs.Clients.Blocknative
  alias Vhs.Servers.Transaction

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)
  plug(:dispatch)

  post "/blocknative/confirm" do
    body_params = conn.body_params
    hash = body_params["hash"]
    hashes = List.wrap(hash)

    Logger.info("#{inspect(hashes)} got to register")

    case Blocknative.watch_tx(body_params) do
      {:ok, _} ->
        Transaction.register(hash, "registered")

        conn
        |> put_resp_content_type("application/json")
        |> resp(200, Jason.encode!(%{status: "ok"}))
        |> send_resp()

      {:error, _error} ->
        conn
        |> put_resp_content_type("application/json")
        |> resp(422, Jason.encode!(%{error: "there was an error posting to slack"}))
        |> send_resp()
    end
  end

  get "/blocknative/transactions/pending" do
    case Transaction.get_pending_transactions() do
      {:ok, pending_transactions} ->
        transactions =
          Enum.map(pending_transactions, fn {hash, status} ->
            %{
              hash: hash,
              status: status
            }
          end)

        conn
        |> put_resp_content_type("application/json")
        |> resp(200, Jason.encode!(%{status: "ok", data: transactions}))
        |> send_resp()

      {:error, _error} ->
        conn
        |> put_resp_content_type("application/json")
        |> resp(422, Jason.encode!(%{error: "there was an error fetching  pending transactions"}))
        |> send_resp()
    end
  end

  post "/blocknative/webhook" do
    body_params = conn.body_params
    Transaction.update_status(body_params)

    conn
    |> put_resp_content_type("application/json")
    |> resp(200, Jason.encode!(%{status: "ok"}))
    |> send_resp()
  end

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> resp(404, Jason.encode!(%{error: "not found"}))
    |> send_resp()
  end
end
