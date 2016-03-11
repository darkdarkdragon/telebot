use Mix.Config

config :telebot, api_key: System.get_env("TELEGRAM_BOT_TOKEN")

config :telebot, handlers: [
  Echo,
]
