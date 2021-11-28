import Config

# Set the `:username` config value here with your Name or Github handler.
config :vhs,
  blocknative: %{
    api_key: "09119304-c8e3-4231-bd48-24aa5fefcb5d",
    blockchain: "ethereum",
    network: "main",
    base_url: "https://api.blocknative.com"
  },
  slack: %{
    base_url: "https://hooks.slack.com/services",
    webhook_key: "T87C7C78R/B02NH1WEVLM/Z8weGMtwWW8CsVPrSxDRi1YB"
  },
  username: "blackode"

config :tesla, :adapter, Tesla.Adapter.Gun
