class App < Sinatra::Base
  
  use Rack::Auth::Basic, "Restricted Area" do |user, key|
    user == 'api' and key == ENV['API_KEY']
  end
  
  configure do
    set :cache, Sinatra::Cache::RedisStore.new(url: (ENV['REDISTOGO_URL'] || 'redis://127.0.0.1:6379'))
  end
  
  before do
    setup_params
  end
  
  get '/api/realization.json' do
    content_type :json
    settings.cache.fetch(cache_name, expires_in: 60) do
      Realization::Api.new(@location).to_score.to_json
    end
  end
  
  protected
  
  def cache_name
    ["store", @location, @channels].flatten.join("-")
  end
  
  def setup_params
    %w( location lat long channels ).each do |name|
      instance_variable_set(:"@#{name}", params.fetch(name)) if params[name]
    end
  end
end

# redistogo
# > redis-cli -h grouper.redistogo.com -p 9990 -a <pass> monitor