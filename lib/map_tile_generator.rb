# frozen_string_literal: true

require 'tile'
require 'tile_perlin_generator'

class MapTileGenerator
  attr_reader :map_config, :map, :height_perlin_generator, :moist_perlin_generator, :temp_perlin_generator

  def initialize(map:, height_perlin_generator: nil, moist_perlin_generator: nil, temp_perlin_generator: nil)
    @map = map
    @map_config = map.config
    @height_perlin_generator = height_perlin_generator || default_perlin_height_generator
    @moist_perlin_generator = moist_perlin_generator || default_perlin_moist_generator
    @temp_perlin_generator = temp_perlin_generator || default_perlin_temp_generator
  end

  def generate
    puts "generating #{map_config.width} x #{map_config.height} tiles..."
    positive_quadrant_cartesian_plane
  end

  private

  def positive_quadrant_cartesian_plane
    y_axis_array do |y|
      x_axis_array do |x|
        Tile.new(
          map: map,
          x: x,
          y: y,
          height: heights[y][x],
          moist: moists[y][x],
          temp: temps[y][x]
        )
      end
    end
  end

  def y_axis_array(&block)
    Array.new(map_config.height, &block)
  end

  def x_axis_array(&block)
    Array.new(map_config.width, &block)
  end

  def default_perlin_height_generator
    TilePerlinGenerator.new(map_config.perlin_height_config)
  end

  def default_perlin_moist_generator
    TilePerlinGenerator.new(map_config.perlin_moist_config)
  end

  def default_perlin_temp_generator
    TilePerlinGenerator.new(map_config.perlin_temp_config)
  end

  def heights
    @heights ||= height_perlin_generator.generate
  end

  def moists
    @moists ||= moist_perlin_generator.generate
  end

  def temps
    @temps ||= temp_perlin_generator.generate
  end
end
