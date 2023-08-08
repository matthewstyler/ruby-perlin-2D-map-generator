# frozen_string_literal: true

require 'map_tile_generator'
require 'map_config'
require 'road_generator'

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
    return @tiles if @tiles

    @tiles = generate_tiles
    road_generator = RoadGenerator.new(@tiles)
    road_generator.generate_num_of_random_roads(config.road_config)
    road_generator.generate_roads_from_coordinate_list(config.road_config.roads_to_make)
    @tiles
  end

  private

  def generate_tiles
    MapTileGenerator.new(map: self).generate
  end
end
