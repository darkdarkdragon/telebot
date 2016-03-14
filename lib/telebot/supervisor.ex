require Logger

defmodule Telebot.Supervisor do
  @moduledoc false

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    import Supervisor.Spec
    telegram_bot_token = Application.get_env(:telebot, :telegram_bot_token)
    handlers = Application.get_env(:telebot, :handlers)

    cond do
      is_nil telegram_bot_token -> raise "Invalid telegram_bot_token. Please define :telebot, :telegram_bot_token in config.exs"
      is_nil handlers ->
        handlers = []
        Logger.warn "No handler found for telebot. Make sure you have added handlers for telebot events."
      [] == handlers ->
        Logger.warn "No handler found for telebot. Make sure you have added handlers for telebot events."
      true -> :ok
    end

    children = [
      worker(Telebot.Server, [{handlers}, []]),
      worker(Telebot.Tick, [])
    ]
    supervise(children, strategy: :one_for_one, max_restarts: 5, max_seconds: 1)
  end
end
