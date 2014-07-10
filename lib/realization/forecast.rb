# API request every 5 minutes.  ( 12/hr, 288/day )

module Realization
  class Forecast

    attr_accessor :response, :url, :temperature, :windspeed
  
    def initialize(lat, long)
      @url = "https://api.forecast.io/forecast/#{ENV["FORECAST_KEY"]}/#{lat},#{long}"
      @response = HTTParty.get(url).parsed_response
      @temperature = temp_intensity(response["currently"]["temperature"])
      @windspeed =   wind_intensity(response["currently"]["windSpeed"])
    end
  
    %w[ sunrise sunset].each do |kind|
      define_method(kind) do
        Time.at(response["daily"]["data"].first["#{kind}Time"]).to_i
      end
    end
  
    def precipitation
      response["minutely"]["data"].map do |p|
        { 
          time: Time.at(p["time"]), 
          probability: (p["precipProbability"] > 0.50), 
          precip_intensity: precip_intensity(p["precipIntensity"])  
        }
      end
    end
    
    # http://en.wikipedia.org/wiki/Beaufort_scale, 1..12
    def wind_intensity(int)
      case int
        when 1..3
          'light-air'
        when 4..7
          'light-breeze'
        when 8..12
          'gentle-breeze'
        when 13..17
          'moderate-breeze'
        when 18..24
          'fresh-breeze'
        when 25..30
          'strong-breeze'
        when 31..38
          'high-wind'
        when 39..46
          'gale'
        when 47..54
          'strong-gale'
        when 55..63
          'storm'
        when 64..73
          'violent-storm'
        when 74..120
          'hurricane'
        else
          'calm'
      end
    end
  
    def precip_intensity(int)
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
    
    def temp_intensity(int)
      case int.round
      when -100..10
        "very-cold"
      when 11..40
        "cold"
      when 41..60
        "moderate"
      when 61..70
        "moderate-warm"
      when 71..80
        "warm"
      when 81..90
        "very-warm"
      when 90..110
        "hot"
      end
    end
    
    def to_score
      precip = precipitation.first
      {
        raining: precip[:probability],
        raining_intensity: precip[:intensity],
        sunrise: occuring(:sunrise),
        sunset: occuring(:sunset),
        windspeed:  windspeed,
        temperature: temperature
      }
    end
    
    def occuring(start)
      start = send(start)
      (start..(start + 20.minutes )) === Time.now.to_i
    end
  end
end