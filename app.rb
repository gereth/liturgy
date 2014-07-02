
class Api < Sinatra::Base
  configure do
    # ...
  end

  get '/forecast' do
    forecast = ForecastIO.new(45.5200, 122.6819)
    forecast.precipitation
  end
end