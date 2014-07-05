require 'realization/forecast'
require 'realization/flights'

module Realization
  class Api

    attr_accessor :lat, :long, :channels

    def initialize(location, channels)
      @channels   = channels
      @lat, @long = location_to_coordinates(location.to_sym)
    end

    def location_to_coordinates(location)
      {
        clinton_division: [45.512157, -122.611175]
      }.fetch(location)
    end

    # temp             -> very cold | cold | moderate | warm | very warm
    # precip           -> raining | not raining<optional>
    # precip add       -> very-light | light | moderate | heavy 
    # windspeed        -> light-air | etc.. s
    # sunrise ( 20m )  -> sunrise
    # sunset  ( 20m )  -> sunset
    # flights nearby   -> flights | no flights<optional>
    # flight kind      -> large | small | private 
    # 30 possible 
    #
    
    def to_score
      forecast = Realization::Forecast.new(lat, long)
      flights = Realization::Flights.new(lat, long, 5)

      Hash[ *[forecast, flights].map{|obj| obj.to_score.to_a}.flatten].select {|k,v| v}
    end  
  end
end

