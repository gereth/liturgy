class App < Sinatra::Base
  attr_accessor :payload

  # use Rack::Auth::Basic, "Restricted Area" do |user, key|
  #   user == 'api' and key == ENV['API_KEY']
  # end

  configure do
    set :cache, Sinatra::Cache::RedisStore.new(url: (ENV['REDISTOGO_URL'] || 'redis://127.0.0.1:6379'))
  end

  before do
    parse_payload
  end

  post '/api/realization' do
    settings.cache.fetch(cache_name, expires_in: 2) do
      Realization::Api.new(payload).score!
    end
  end

  def parse_payload
    @payload ||= JSON.parse(request.body.read)
  end

  protected
  def cache_name
    ["store", payload["location"], payload["channels"]].flatten.join("-")
  end
end

# redistogo
# > redis-cli -h grouper.redistogo.com -p 9990 -a <pass> monitor
