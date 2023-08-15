# frozen_string_literal: true

require 'test_helper'

class TestBuilding < Minitest::Test
  def setup
    @building = Building.new(Building::HOUSE)
  end

  def test_initialize
    assert_equal Building::HOUSE, @building.render_symbol
    assert_equal Building::TOWN_RENDER_PRIORITY, @building.render_priority
  end

  def test_random_town_building
    building = Building.random_town_building(nil)
    assert_instance_of Building, building
    assert_equal Building::HOUSE, building.render_symbol
  end
end
