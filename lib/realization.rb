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

    def playing
      forecast = Realization::Forecast.new(lat, long)
      flights  = Realization::Flights.new(lat, long, 5)
      [forecast, flights].map{|api| api.to_score }.flatten.compact
    end

    def add
      playing - channels
    end

    def remove
      channels - playing
    end

    def change
      []
    end

    def skip?
      (add + remove).flatten.empty?
    end

    def score!
      { add: add, remove: remove, skip: skip? }
    end

  end
end
