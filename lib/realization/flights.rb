module Realization
  class Flights
    attr_accessor :lat, :long, :distance

    def initialize(lat, long, distance)
      @lat      = lat
      @long     = long
      @distance = distance
    end

    def config
      {
        base:    "https://api.flightstats.com/flex/flightstatus/rest/v2/json",
        app_key: ENV["FLIGHT_STATS_KEY"],
        app_id:  ENV["FLIGHT_STATS_ID"]
      }
    end

    def to_score
      {
        flights: nearby.any?
      }
    end
    
    def get(url)
      query = { appId: config[:app_id], appKey: config[:app_key] }
      HTTParty.get(url, query: query).parsed_response.try(:[], "flightPositions")
    end

    # Flights within area specified by point and distance ( miles )
    # 45.512924, -122.584278

    def nearby
      url = [ config[:base], 'flightsNear', lat, long, distance ].join("/")
      # map get(url)
      get(url)
    end

    def map(flights)
      puts "flights: #{flights.count}"

      positions = Hash[ flights.map{ |f| [f["callsign"], f["positions"].last]}]
      markers =""
      positions.map do |callsign, coords|
        markers += "&markers=color:blue%7Clabel:A%7C#{coords['lat']},#{coords['lon']}"
      end

      url = "http://maps.google.com/maps/api/staticmap?center=Montavilla+Portland+OR&zoom=10&size=1024x1024&maptype=roadmap%20&markers=#{markers}&sensor=true"
      %x{ open -a /Applications/Firefox.app "#{url}" }
    end
  end
  
end