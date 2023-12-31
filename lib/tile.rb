# frozen_string_literal: true

require 'biome'
require 'flora'
require 'ansi_colours'
require 'pry-byebug'
require 'building'

class Tile
  attr_reader :x, :y, :height, :moist, :temp, :map, :type

  TYPES = %i[
    terrain
    road
  ].freeze

  def initialize(map:, x:, y:, height: 0, moist: 0, temp: 0, type: :terrain)
    @x = x
    @y = y
    @height = height
    @moist = moist
    @temp = temp
    @map = map
    raise ArgumentError, 'invalid tile type' unless TYPES.include?(type)

    @type = type
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
    @items ||= []
  end

  def render_to_standard_output
    print render_color_by_type + (!items.empty? ? item_with_highest_priority.render_symbol : '  ')
    print AnsiColours::Background::ANSI_RESET
  end

  def add_item(tile_item)
    raise ArgumentError, 'item should be a tile' unless tile_item.is_a?(TileItem)

    items.push(tile_item)
  end

  def item_with_highest_priority
    items.max_by(&:render_priority)
  end

  def items_contain_flora?
    items_contain?(Flora)
  end

  def items_contain_building?
    items_contain?(Building)
  end

  def items_contain?(item_class)
    items.any? { |i| i.is_a?(item_class) }
  end

  def to_h
    {
      x: x,
      y: y,
      height: height,
      moist: moist,
      temp: temp,
      biome: biome.to_h,
      items: items.map(&:to_h),
      type: type
    }
  end

  def add_town_item(seed)
    add_item(Building.random_town_building(seed))
  end

  def make_road
    @type = :road
  end

  def road?
    @type == :road
  end

  def path_heuristic
    height
  end

  def can_haz_town?
    !road? && !biome.water? && !biome.high_mountain? && !items_contain_flora?
  end

  def can_haz_road?
    true unless biome_is_water_and_is_excluded? || biome_is_high_mountain_and_is_excluded? || tile_contains_flora_and_is_excluded? || items_contain_building?
  end

  def add_flora
    add_item(biome.flora)
  end

  private

  def biome_is_water_and_is_excluded?
    biome.water? && map.config.road_config.road_exclude_water_path
  end

  def biome_is_high_mountain_and_is_excluded?
    biome.high_mountain? && map.config.road_config.road_exclude_mountain_path
  end

  def tile_contains_flora_and_is_excluded?
    items_contain_flora? && map.config.road_config.road_exclude_flora_path
  end

  def render_color_by_type
    case type
    when :terrain then biome.colour
    when :road
      case height
      when 0.66..1
        AnsiColours::Background::HIGH_ROAD_BLACK
      when 0.33..0.66
        AnsiColours::Background::ROAD_BLACK
      when 0..0.33
        AnsiColours::Background::LOW_ROAD_BLACK
      end
    end
  end
end
