# frozen_string_literal: true

require 'test_helper'
require 'town_generator'
require 'map_config'
require 'poisson_disk_sampling/sampler'

class TownGeneratorTest < Minitest::Test
  def setup
    @tiles = [[mock('tiles')]]
    @generator = TownGenerator.new(@tiles)
    @config = mock('config')
  end

  def test_initialize
    assert_equal @tiles[0][0], @generator.sample_area[0, 0]
    assert_equal @tiles, @generator.road_generator.grid.nodes
  end

  def test_generate_random_towns_with_positive_towns
    @config.stubs(:towns).returns(2)
    @config.stubs(:verbose).returns(false)
    @config.stubs(:town_seed).returns(12_345)

    @generator.expects(:generate_random_town).twice
    @generator.expects(:generate_roads_between_towns).once

    @generator.generate_random_towns(@config)
  end

  def test_generate_random_towns_with_zero_towns
    @config.stubs(:towns).returns(0)

    @generator.expects(:generate_random_town).never
    @generator.expects(:generate_roads_between_towns).never

    @generator.generate_random_towns(@config)
  end

  def test_generate_two_random_towns_without_error
    town_config = MapConfig::TownConfig.new(1, 2, [], false)
    config = MapConfig.new(width: 25, height: 25, town_config: town_config)
    map = Map.new(map_config: config)


    TownGenerator.new(map.tiles).generate_random_towns(config.town_config)
  end
end
