defmodule Vhs.Clients.Slack do
  use Tesla, only: [:post], docs: false

  @moduledoc """
  Interface to communicate with Slack through a webhook

  Ideally the client_config will return api keys or anything else to custommize the request.
  """

  require Logger

  @behaviour Vhs.Behaviors.SlackClient

  @caller Application.compile_env!(:vhs, :username)
  @client_config Application.compile_env!(:vhs, :slack)

  plug(Tesla.Middleware.BaseUrl, @client_config.base_url)
  plug(Tesla.Middleware.JSON, engine: Jason)

  @impl true
  def webhook_post(chain_response) do
    body = slack_message_body(chain_response)

    case post(@client_config.webhook_key, body) do
      {:ok, response} ->
        {:ok, response}

      {:error, error} ->
        Logger.error("Received error trying to post to Slack with reason #{inspect(error)}")

        {:error, error}
    end
  end

  defp slack_message_body(chain_response) do
    %{
      text: "*#{chain_response["hash"]} got mined*",
      attachments: [
        %{
          blocks: [
            %{
              type: "section",
              text: %{
                type: "mrkdwn",
                text: "*From: #{@caller}*"
              }
            },
            %{
              type: "section",
              text: %{
                type: "mrkdwn",
                text: "*Status: #{String.capitalize(chain_response["status"])}*"
              }
            },
            %{
              type: "section",
              text: %{
                type: "mrkdwn",
                text: "*See on*"
              }
            },
            %{
              type: "section",
              text: %{
                type: "mrkdwn",
                text:
                  "<https://etherscan.com/tx/#{chain_response["hash"]}|Etherscan> :male-detective:"
              }
            }
          ]
        }
      ]
    }
  end
end
