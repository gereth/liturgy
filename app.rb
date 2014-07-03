
class Api < Sinatra::Base
  
  use Rack::Auth::Basic, "Restricted Area" do |user, key|
    user == 'api' and key == ENV['api_key']
  end
  
  configure do
  end
  
  get '/api/realization.json' do
    content_type :json
    Realization.new(45.5200, -122.68199)
  end

  # get 'api/forecast' do
  # end
  
  # get '/api/flight_stats' do
  # end
end