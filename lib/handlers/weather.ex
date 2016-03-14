
require Logger

defmodule Weather do
  use Telebot.Handler.Base
  use HTTPoison.Base

  @endpoint "http://api.openweathermap.org/data/2.5/weather"

  def text(_from, chat, command) do
    Logger.debug "METEO: recv text: " <> command

    Regex.named_captures(~r/^\/meteo\s?(?<city>.*)/i, command)
    |> get_weather
    |> format_message
    |> send_message(chat.id)
  end

  defp get_weather(%{"city" => city}) do
    url = @endpoint <> "?APPID=#{Application.get_env(:telebot, :open_weather_map_key)}&q=#{city}&units=metric"

    case get(url) do
      {:ok, data} ->
        data.body |> Poison.decode!
      _ -> nil
    end
  end

  defp get_weather(_empty) do
    nil
  end

  defp format_message(data) do
    if data do
      """
      Weather in #{data["name"]}, #{data["sys"]["country"]}:
      #{icon hd(data["weather"])["icon"]} #{hd(data["weather"])["main"]}
      🌡 #{data["main"]["temp"]}°C
      """
    end
  end

  defp send_message(msg, chat_id) do
    if msg do
      Telebot.Api.send_message chat_id, msg
    end
  end

  defp icon(name) do
    %{
      "01d" => "☀️",
      "02d" => "🌤",
      "03d" => "🌥",
      "04d" => "⛅️",
      "09d" => "🌧",
      "10d" => "🌦",
      "11d" => "🌩",
      "13d" => "🌨",
      "01n" => "🌕",
      "02n" => "🌤",
      "03n" => "🌥",
      "04n" => "⛅️",
      "09n" => "🌧",
      "10n" => "🌦",
      "11n" => "🌩",
      "13n" => "🌨"
      }[name]
  end
end

# 01d.png 	01n.png 	sky is clear
# 02d.png 	02n.png 	few clouds
# 03d.png 	03n.png 	scattered clouds
# 04d.png 	04n.png 	broken clouds
# 09d.png 	09n.png 	shower rain
# 10d.png 	10n.png 	Rain
# 11d.png 	11n.png 	Thunderstorm
# 13d.png 	13n.png 	snow
