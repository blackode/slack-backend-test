import Config

# Set the `:username` config value here with your Name or Github handler.
config :vhs,
  blocknative: %{
    api_key: System.get_env("BLOCKNATIVE_API_KEY"),
    blockchain: "ethereum",
    network: "main",
    base_url: "https://api.blocknative.com"
  },
  slack: %{
    base_url: "https://hooks.slack.com/services",
    webhook_key: System.get_env("SLACK_WEBHOOK_KEY")
  },
  username: "blackode"

config :tesla, :adapter, Tesla.Adapter.Gun
