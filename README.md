# VHS Test Template

Use this template to complete your assignment for the backend elixir engineer position at VHS

In this project you'll find two behaviors to implement a Slack and Blocknative client. They're given as starting points where you can just build the rest of the logic around that.

### Given modules

## HTTP module

This module is very simplistic but it's given in a way for the person to implement whatever library they want. If the library deviates a lot from the normal post/get requests, you can modify this module as much as you want for it to work the best for you.

## Slack behavior and client

This can get used to publish to the Slack webhook, you already have a very small code sample that you can extend. Adjust the client config as you want.

## Blocknative behavior and client

Similar to Slack's, you have a starting point for the client and HTTP module, you have the client config in the same way as the previous one

## Client config

The idea of having a client config in these modules is so the api key, network or something else that's not exactly private is sent around and possibly used across the application :)

Note that what's in here doesn't need to be delivered in the same way, we put this here for you to have something to start quicker but it can be tweaked in whatever way you want if you feel it works better in a different way, we'll be more than happy to see that.

The HTTP client on `config.exs` is missing on purpose. The project won't compile without this, if you want it to compile even with warnings, remove the `elixirc_options` key in `mix.exs`.

