
require Logger

defmodule Weather do
  use Telebot.Handler.Base
  use HTTPoison.Base

  @endpoint "http://api.openweathermap.org/data/2.5/weather"

  def text(_from, chat, command) do
    Logger.debug "recv text: " <> command
    regex = ~r/^\/meteo\s?(?<city>.*)/i

    with %{"city" => city} <- Regex.named_captures(regex, command),
          data = %{"cod" => 200} <- get_weather(city),
    do: format_message(data) |> send_message(chat.id)

  end

  def help do
    "/meteo <city name>[,country code] - Check the weather"
  end

  defp get_weather(city) do
    api_key = Application.get_env(:telebot, :open_weather_map_key)
    url = "#{@endpoint}?APPID=#{api_key}&q=#{city}&units=metric"

    with {:ok, data} <- get(url) do
      data.body |> Poison.decode!
    end
  end

  defp format_message(data) do
    """
    Weather in #{data["name"]}, #{data["sys"]["country"]}:
    #{icon hd(data["weather"])["icon"]} #{hd(data["weather"])["main"]}
    🌡 #{data["main"]["temp"]}°C
    """
  end

  defp send_message(msg, chat_id) do
    Telebot.Api.send_message chat_id, msg
  end

  defp icon(name) do
    # 01d.png 	01n.png 	sky is clear
    # 02d.png 	02n.png 	few clouds
    # 03d.png 	03n.png 	scattered clouds
    # 04d.png 	04n.png 	broken clouds
    # 09d.png 	09n.png 	shower rain
    # 10d.png 	10n.png 	Rain
    # 11d.png 	11n.png 	Thunderstorm
    # 13d.png 	13n.png 	snow
    
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
