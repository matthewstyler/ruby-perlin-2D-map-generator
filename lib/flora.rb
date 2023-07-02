# frozen_string_literal: true

require 'tile_item'

class Flora < TileItem
  CACTUS = "\u{1F335}"
  EVERGREEN_TREE = "\u{1F332}"
  DECIDUOUS_TREE = "\u{1F333}"

  def initialize(render_symbol)
    super self, render_symbol: render_symbol
  end
end
