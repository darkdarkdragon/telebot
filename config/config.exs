# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :telebot, telegram_bot_token: System.get_env("TELEGRAM_BOT_TOKEN")
config :telebot, open_weather_map_key: System.get_env("OPEN_WEATHER_MAP_KEY")

import_config "#{Mix.env}.exs"
