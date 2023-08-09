# frozen_string_literal: true

require 'ansi_colours'
require 'flora'

class Biome
  attr_accessor :name, :flora_range, :colour

  def initialize(name:, colour:, flora_range: nil)
    @name = name
    @flora_range = flora_range
    @colour = colour
  end

  def water?
    WATER_TERRAIN.include?(self)
  end

  def land?
    LAND_TERRAIN.include?(self)
  end

  def grassland?
    GRASSLAND_TERRAIN.include?(self)
  end

  def desert?
    DESERT_TERRAIN.include?(self)
  end

  def taiga?
    TAIGA_TERRAIN.include?(self)
  end

  def high_mountain?
    HIGH_MOUNTAIN.include?(self)
  end

  def flora_available
    !flora_range.nil?
  end

  def flora
    @flora ||=
      if flora_available
        if desert?
          Flora.new(Flora::CACTUS)
        elsif grassland?
          Flora.new(Flora::DECIDUOUS_TREE)
        elsif taiga?
          Flora.new(Flora::EVERGREEN_TREE)
        else
          raise StandardError, "Unknown flora #{to_h}"
        end
      end
  end

  def to_h
    {
      name: name,
      flora_range: flora_range,
      colour: colour
    }
  end

  def self.from(elevation, moist, temp)
    terrain_selection(elevation, moist, temp)
  end

  SNOW                        = Biome.new(name: 'snow', flora_range: nil, colour: AnsiColours::Background::WHITE)
  ROCKS                       = Biome.new(name: 'rocks', flora_range: nil, colour: AnsiColours::Background::GREY)
  MOUNTAIN                    = Biome.new(name: 'mountain', flora_range: nil, colour: AnsiColours::Background::BROWN)
  MOUNTAIN_FOOT               = Biome.new(name: 'mountain_foot', flora_range: 10, colour: AnsiColours::Background::RED_BROWN)
  GRASSLAND                   = Biome.new(name: 'grassland', flora_range: 1, colour: AnsiColours::Background::DARK_GREEN)
  VALLEY                      = Biome.new(name: 'valley', flora_range: 1, colour: AnsiColours::Background::GREEN)
  DEEP_VALLEY                 = Biome.new(name: 'deep_valley', flora_range: 1, colour: AnsiColours::Background::LIGHT_GREEN)
  DESERT                      = Biome.new(name: 'desert', flora_range: 1, colour: AnsiColours::Background::DESERT_YELLOW)
  DEEP_DESERT                 = Biome.new(name: 'deep_desert', flora_range: 1, colour: AnsiColours::Background::DESERT_LIGHT_YELLOW)
  STEPPE_DESERT               = Biome.new(name: 'steppe_desert', flora_range: 1, colour: AnsiColours::Background::DESERT_DARK_YELLOW)
  SWAMP                       = Biome.new(name: 'swamp', flora_range: nil, colour: AnsiColours::Background::GREEN_SWAMP)
  COASTLINE                   = Biome.new(name: 'coastline', flora_range: nil, colour: AnsiColours::Background::SANDY)
  SHOAL                       = Biome.new(name: 'shoal', flora_range: nil, colour: AnsiColours::Background::SHOAL_BLUE)
  OCEAN                       = Biome.new(name: 'ocean', flora_range: nil, colour: AnsiColours::Background::LIGHT_BLUE)
  DEEP_OCEAN                  = Biome.new(name: 'deep_ocean', flora_range: nil, colour: AnsiColours::Background::BLUE)
  TAIGA_PLAIN                 = Biome.new(name: 'taiga_plain', flora_range: 1.5, colour: AnsiColours::Background::TAIGA_PLAIN)
  TAIGA_VALLEY                = Biome.new(name: 'taiga_valley', flora_range: 1.5, colour: AnsiColours::Background::TAIGA_VALLEY)
  TAIGA_HIGHLAND              = Biome.new(name: 'taiga_highland', flora_range: 1.5, colour: AnsiColours::Background::TAIGA_HIGHLAND)
  TAIGA_COAST                 = Biome.new(name: 'taiga_coast', flora_range: nil, colour: AnsiColours::Background::TAIGA_COAST)
  ICE                         = Biome.new(name: 'ice', flora_range: nil, colour: AnsiColours::Background::ICE)

  ALL_TERRAIN = [
    SNOW,
    ROCKS,
    MOUNTAIN,
    MOUNTAIN_FOOT,
    GRASSLAND,
    VALLEY,
    COASTLINE,
    SHOAL,
    OCEAN,
    DEEP_OCEAN,
    DESERT,
    DEEP_DESERT,
    STEPPE_DESERT,
    SWAMP,
    TAIGA_PLAIN,
    TAIGA_HIGHLAND,
    TAIGA_VALLEY,
    TAIGA_COAST,
    ICE
  ].freeze

  WATER_TERRAIN = [
    SHOAL,
    OCEAN,
    DEEP_OCEAN
  ].freeze

  DESERT_TERRAIN = [
    DESERT,
    DEEP_DESERT,
    STEPPE_DESERT
  ].freeze

  GRASSLAND_TERRAIN = [
    GRASSLAND,
    VALLEY,
    DEEP_VALLEY,
    MOUNTAIN_FOOT
  ].freeze

  TAIGA_TERRAIN = [
    TAIGA_PLAIN,
    TAIGA_HIGHLAND,
    TAIGA_VALLEY,
    TAIGA_COAST
  ].freeze

  HIGH_MOUNTAIN = [
    SNOW,
    ROCKS,
    MOUNTAIN
  ].freeze

  LAND_TERRAIN = (ALL_TERRAIN - WATER_TERRAIN).freeze

  class << self
    private

    def terrain_selection(elevation, moist, temp)
      case elevation
      when 0.95..1
        SNOW
      when 0.9...0.95
        ROCKS
      when 0.8...0.9
        if moist < 0.9
          MOUNTAIN
        else
          SHOAL
        end
      when 0.7...0.8
        if moist < 0.9
          MOUNTAIN_FOOT
        else
          SHOAL
        end
      when 0.6...0.7
        if moist < 0.8
          if desert_condition?(moist, temp)
            STEPPE_DESERT
          elsif taiga_condition?(moist, temp)
            TAIGA_HIGHLAND
          elsif moist > 0.75
            SWAMP
          else
            GRASSLAND
          end
        else
          SHOAL
        end
      when 0.3...0.6
        if desert_condition?(moist, temp)
          DESERT
        elsif taiga_condition?(moist, temp)
          TAIGA_PLAIN
        else
          VALLEY
        end
      when 0.2...0.3
        if desert_condition?(moist, temp)
          DEEP_DESERT
        elsif taiga_condition?(moist, temp)
          TAIGA_VALLEY
        else
          DEEP_VALLEY
        end
      when 0.15...0.2
        if taiga_condition?(moist, temp)
          TAIGA_COAST
        else
          COASTLINE
        end
      when 0.05...0.15
        if taiga_condition?(moist, temp)
          ICE
        else
          SHOAL
        end
      when 0.025...0.05
        if taiga_condition?(moist, temp)
          ICE
        else
          OCEAN
        end
      when 0.0...0.025
        if taiga_condition?(moist, temp)
          ICE
        else
          DEEP_OCEAN
        end
      else
        raise ArgumentError, "unknown biome elevation: #{elevation} moisture: #{moist} temp: #{temp}"
      end
    end

    def desert_condition?(moist, temp)
      moist < 0.1 && temp > 0.5
    end

    def taiga_condition?(moist, temp)
      moist > 0.6 && temp < 0.2
    end
  end
end
