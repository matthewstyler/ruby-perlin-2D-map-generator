# frozen_string_literal: true

require 'test_helper'
require 'tile_item'

class TileItemTest < Minitest::Test
  def setup
    @obj = Object.new
    @id = 123
    @render_symbol = 'X'
    @render_priority = 2
    @tile_item = TileItem.new(@obj, id: @id, render_symbol: @render_symbol, render_priority: @render_priority)
  end

  def test_initialize
    assert_equal @obj, @tile_item.obj
    assert_equal @id, @tile_item.id
    assert_equal @render_symbol, @tile_item.render_symbol
    assert_equal @render_priority, @tile_item.render_priority
  end

  def test_to_h
    expected_hash = {
      id: @id,
      type: @obj.class.name.downcase,
      render_symbol: @render_symbol,
      render_priority: @render_priority
    }
    assert_equal expected_hash, @tile_item.to_h
  end
end
