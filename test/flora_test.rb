# frozen_string_literal: true

require 'flora'

class FloraTest < Minitest::Test
  def test_initialize
    render_symbol = Flora::CACTUS
    flora = Flora.new(render_symbol)
    assert_equal render_symbol, flora.render_symbol
    assert_equal 0, flora.render_priority
  end

  def test_to_h
    render_symbol = Flora::EVERGREEN_TREE
    flora = Flora.new(render_symbol)
    expected_hash = {
      id: flora.id,
      type: flora.obj.class.name.downcase,
      render_symbol: render_symbol,
      render_priority: flora.render_priority
    }
    assert_equal expected_hash, flora.to_h
  end
end
