Telebot
=======
[![Build Status](https://travis-ci.org/apeacox/telebot.svg?branch=master)](https://travis-ci.org/apeacox/telebot)

Telegram bot plugin system written in Elixir.

This code is a fork of [https://github.com/ottolin/telebot], I did some changes and additions.

## Install

### Integrate in other applications

Add the following lines to mix.exs in your project
```elixir

def application do
  [applications: [:telebot]]
end

defp deps do
  [{:telebot, git: "git://github.com/apeacox/telebot.git"}]
end
```

Then update dependencies by:
```
mix deps.get
```

### Use as a standalone bot

Clone this repo:

```
git clone git://github.com/apeacox/telebot.git
```

Install dependencies:
```
mix deps.get
```


## Configuration
In order to work with Telegram server, you need an api key.
The key can be obtained by sending message to [BotFather](https://telegram.me/BotFather)

After obtaining your key, add the following lines to config.exs:

```elixir
config :telebot, :telegram_bot_token, "Your API Key Right Here"
```

Now you are able to write your own bot by implementing the behaviour Telebot.Handler.


## Extending your bot
Use `Telebot.Handler.Base` and override any callback that you are interested in.

In the following example, you can have an echo Telegram bot in just a few lines of code.
```elixir
defmodule MyEchoBot do
  use Telebot.Handler.Base

  # overriding the text() callback
  def text(from, chat, t), do: Telebot.Api.send_message(chat.id, "Echo: " <> t)
end
```

Finally, add your bot module to config.exs:
```elixir
config :telebot, :handlers, [
  MyEchoBot
]
```

Enjoy your bot by running
```
iex -S mix
```

By sending messages to your registered bot account, you should now see the reply from bot!
