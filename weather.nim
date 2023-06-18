import httpclient
import json
import strutils

type
  WeatherData = object
    location: string
    temperature: float
    description: string

proc fetchWeatherData(city: string): WeatherData =
  var url = "http://api.openweathermap.org/data/2.5/weather?q=" & city & "&appid=086fab05bd4692c8025f5d6843b40ad6"

  var client = newHttpClient()
  var response = client.get(url)

  if response.code == Http200:
    var jsonData = parseJson(response.body)
    var weatherData: WeatherData

    weatherData.location = jsonData["name"].str
    weatherData.temperature = jsonData["main"]["temp"].getFloat - 273.15
    weatherData.description = jsonData["weather"][0]["description"].str

    return weatherData
  else:
    echo "Failed to fetch weather data."
    quit(1)

proc main() =
  echo "Weather Application"
  echo "Enter a city:"
  let city = readLine(stdin)

  var weatherData = fetchWeatherData(city)

  echo "Location: ", weatherData.location
  echo "Temperature: ", formatFloat(weatherData.temperature,ffDefault,2), " °C"
  echo "Description: ", weatherData.description

when isMainModule:
  main()
