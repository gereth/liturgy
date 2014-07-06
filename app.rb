
# TODO 
# - heroku deploy
# - heroku config vars
# - redis to go addon w/ redis-sinatra - http://redis-store.org/redis-sinatra/
 

class App < Sinatra::Base
  
  use Rack::Auth::Basic, "Restricted Area" do |user, key|
    user == 'api' and key == ENV['API_KEY']
  end
  
  configure do
    # ...
  end
  
  get '/api/realization.json' do
    content_type :json
    realization = Realization::Api.new(params[:location], params[:channels])
    realization.to_score.to_json
  end
end