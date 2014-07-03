require 'realization/forecast'
require 'realization/flight_stats'

module Realization
  class 
  extend self
  attr_accessor :channels, :lat, :long, :location
  
  def run(location, channels)
    @location = location
    @channels = channels
    @lat = "geoff"
    from_forecast
    # @lat, @long = location_to_coordinates(location)
  end
  
  def location_to_coordinates(location)
    {
      clinton_division: [45.512924, -122.5842]
    }
  end
  
  def from_forecast
    lat
  end
  
  def from_flight_stats
  end
  
end

