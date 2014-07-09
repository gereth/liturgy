require 'realization/forecast'
require 'realization/flights'

module Realization
  class Api

    attr_accessor :lat, :long

    def initialize(location, channels)
      @channels   = channels
      @lat, @long = location_to_coordinates(location.to_sym)
    end

    def location_to_coordinates(location)
      {
        clinton_division: [45.512157, -122.611175]
      }.fetch(location)
    end

    # raining, cold, windy, sunset, flights
    #
    # temp             -> very cold | cold | moderate | warm | very warm
    #  -- 
    # precip           -> raining | not raining<optional>
    # precip add       -> very-light | light | moderate | heavy
    #  --
    # windspeed        -> light-air | etc.. s
    #  -- might need to have a val of intensity
    # sunrise ( 20m )  -> sunrise
    #  -- main. pan center
    # sunset  ( 20m )  -> sunset
    #  -- main. pan center
    # flights nearby   -> flights
    #  -- always pretty low.  should play and pan from left to right.
    # 30 possible 
    #
    
    def to_score
      puts "<> creating score <>"
      forecast = Realization::Forecast.new(lat, long)
      flights  = Realization::Flights.new(lat, long, 5)
      Hash[ *[forecast, flights].map{|obj| obj.to_score.to_a}.flatten].select {|k,v| v}
    end  
  end
end

