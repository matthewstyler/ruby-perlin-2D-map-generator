# frozen_string_literal: true

require 'tile_item'

class Town < TileItem
  TOWN_RENDER_PRIORITY = DEFAULT_RENDER_PRIORITY + 1

  HOUSE = "\u{1F3E0}"

  def initialize(render_symbol)
    super self, render_symbol: render_symbol, render_priority: TOWN_RENDER_PRIORITY
  end

  def self.random_town_building(_seed)
    Town.new(HOUSE)
  end
end
