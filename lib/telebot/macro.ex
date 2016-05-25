defmodule Telebot.Macro do
  defmacro gen_callback(name) do
    quote do
      @callback unquote(name)(from :: Map.t, chat :: Map.t, obj :: Mat.t, message_id :: Integer) :: any
    end
  end

  defmacro gen_call(name) do
    quote do
      def unquote(name)(from, chat, obj, message_id), do: :ok
    end
  end
end
