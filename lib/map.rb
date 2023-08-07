# frozen_string_literal: true

require 'map_tile_generator'
require 'map_config'
require 'road_generator'
require 'pry-byebug'

class Map
  attr_reader :config

  def initialize(map_config: MapConfig.new)
    @config = map_config
  end

  def describe
    tiles.map { |row| row.map(&:to_h) }
  end

  def render
    tiles.each do |row|
      row.each(&:render_to_standard_output)
      puts
    end
  end

  # rubocop:disable Naming/MethodParameterName:
  def [](x, y)
    raise ArgumentError, 'coordinates out of bounds' if y.nil? || y >= tiles.size || x.nil? || x >= tiles[y].size

    tiles[y][x]
  end
  # rubocop:enable Naming/MethodParameterName:

  def tiles
    @tiles ||=
      begin
        map_tiles = generate_tiles
        # binding.pry
        RoadGenerator.new(map_tiles).generate(0, 0, 50, 50).each(&:make_road)
        map_tiles
      end
  end

  private

  def generate_tiles
    MapTileGenerator.new(map: self).generate
  end
end
