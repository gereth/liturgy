require 'realization/forecast'
require 'realization/flights'

module Realization
  class Api
    attr_accessor *@@accessors = %i|lat long current_distance channels |

    def initialize(options)
      @@accessors.each do |attr|
        instance_variable_set("@#{attr}", options[attr.to_s])
      end
    end

    def playing
      @playing ||= begin
        # forecast = Realization::Forecast.new(lat, long)
        # flights  = Realization::Flights.new(lat, long, 5)
        # [forecast.to_score, flights.to_score, noise_score].flatten.compact
        ["choir", []].sample
      end
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

    def add_automation(name)
      automation[name].merge!(name: name) if automation[name]
    end

    def score!
      {
        add: add.map{ |channel| add_automation(channel) },
        remove: remove,
        skip: skip?
      }.to_json
    end

    def noise_score
      "noise" if current_distance < 1000
    end

    def automation
      @automation ||= YAML.load_file( File.join(File.dirname(__FILE__), "realization", "automation.yml"))
    end
  end
end
