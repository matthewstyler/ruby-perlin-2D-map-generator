# frozen_string_literal: true

require 'biome'
require 'flora'

class Tile
  attr_reader :x, :y, :height, :moist, :temp, :map

  def initialize(map:, x:, y:, height: 0, moist: 0, temp: 0)
    @x = x
    @y = y
    @height = height
    @moist = moist
    @temp = temp
    @map = map
  end

  def surrounding_tiles(distance = 1)
    @surround_cache ||= {}
    @surround_cache[distance] ||= begin
      left_limit = [0, x - distance].max
      top_limit  = [0, y - distance].max

      map.tiles[left_limit..(x + distance)].map do |r|
        r[top_limit..(y + distance)]
      end.flatten
    end
  end

  def biome
    @biome ||= Biome.from(height, moist, temp)
  end

  def items
    @items ||= items_generated_with_flora_if_applicable
  end

  def render_to_standard_output
    print biome.colour + (!items.empty? ? item_with_highest_priority.render_symbol : '  ')
    print AnsiColours::Background::ANSI_RESET
  end

  def add_item(tile_item)
    raise ArgumentError, 'item should be a tile' unless tile_item.is_a?(TileItem)

    items.push(tile_item)
  end

  def item_with_highest_priority
    items.max_by(&:render_priority)
  end

  def to_h
    {
      x: x,
      y: y,
      height: height,
      moist: moist,
      temp: temp,
      biome: biome.to_h,
      items: items.map(&:to_h)
    }
  end

  private

  def items_generated_with_flora_if_applicable
    if map.config.generate_flora && biome.flora_available
      range_max_value = map.tiles[(y - biome.flora_range)...(y + biome.flora_range)]&.map do |r|
        r[(x - biome.flora_range)...(x + biome.flora_range)]
      end&.flatten&.map(&:height)&.max
      if range_max_value == height
        [biome.flora]
      else
        []
      end
    else
      []
    end
  end
end
