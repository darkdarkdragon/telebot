require Logger

defmodule Help do
  use Telebot.Handler.Base

  def text(_from, chat, "/start"  <> _rest) do
    Logger.debug "recv text: /start"

    start = """
    Hello, I'm here to serve you!
    Type /help to know what I can do.
    """

    Telebot.Api.send_message chat.id, start
  end

  def text(_from, chat, "/help" <> _rest) do
    Logger.debug "recv text: /help"

    handlers = Application.get_env(:telebot, :handlers)
    commands = Enum.map_join(handlers, &(apply(&1, :help, [])))

    Telebot.Api.send_message chat.id, "Available commands:\n\n" <> commands
  end

  def text(_from, _chat, _any) do
  end

  def help do
  end
end
