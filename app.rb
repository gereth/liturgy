
class App < Sinatra::Base
  
  use Rack::Auth::Basic, "Restricted Area" do |user, key|
    user == 'api' and key == ENV['api_key']
  end
  
  configure do
    # ...
  end
  
  get '/api/realization.json' do
    content_type :json
    realization = Realization::Api.new(:clinton_division)
    realization.to_score
  end
end