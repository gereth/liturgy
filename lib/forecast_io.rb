# API request every 5 minutes.  ( 12/hr, 288/day )

class ForecastIO

  @@meters_to_miles = 2.23694 
  attr_accessor :response, :url, :temperature, :windspeed
  
  def initialize(lat, long)
    @url = "https://api.forecast.io/forecast/#{ENV["FORECAST_KEY"]}/#{lat},#{long}"
    @response = HTTParty.get(url)
    @temperature = response["currently"]["temperature"]
    @windspeed = ( response["currently"]["windSpeed"] * @@meters_to_miles).round
  end
  
  %w[ sunrise sunset].each do |kind|
    define_method(kind) do
      Time.at response["daily"]["data"].first["#{kind}Time"]
    end
  end
  
  def precipitation
    response["minutely"]["data"].map do |p|
      { 
        time: Time.at(p["time"]), 
        probability: (p["precipProbability"] > 0.50), 
        intensity: intensity(p["precipIntensity"])  
      }
    end
  end
  
  def intensity(int)
    case int
      when 0.002..0.017
        "very-light"
      when 0.017..0.1
        "light"
      when 0.1..0.4
        "moderate"
      when 0.4..1.0
        "heavy"
    end
  end

end