# frozen_string_literal: true

require 'test_helper'
require 'mocha/minitest'
require 'map'
require 'road_generator'
require 'ostruct'

class MapTest < Minitest::Test
  def test_initialize_with_default_config
    generator_mock = mock('MapTileGenerator')
    MapTileGenerator.expects(:new).with(anything).at_least_once.returns(generator_mock)
    generator_mock.expects(:generate).returns([['test']])

    map = Map.new

    assert_equal [['test']], map.tiles
    assert map.config
  end

  def test_initialize_with_custom_config
    map_config = mock('MapConfig')
    road_config = MapConfig::RoadConfig.new(1, 2, 3, 4, 5, [1, 2, 3, 4])
    town_config = MapConfig::TownConfig.new(1, 1, 1)
    map_config.expects(:road_config).twice.returns(road_config)
    map_config.expects(:town_config).returns(town_config)
    generator_mock = mock('MapTileGenerator')
    road_generator_mock = mock('RoadGenerator')

    tile = OpenStruct.new(x: 1, y: 1, can_haz_town?: true)

    MapTileGenerator.expects(:new).with(anything).returns(generator_mock)
    generator_mock.expects(:generate).returns([[tile]])

    RoadGenerator.expects(:new).with([[tile]]).returns(road_generator_mock)
    road_generator_mock.expects(:generate_num_of_random_roads).with(road_config)
    road_generator_mock.expects(:generate_roads_from_coordinate_list).with([1, 2, 3, 4])

    map = Map.new(map_config: map_config)

    assert_equal map_config, map.config
    assert_equal [[tile]], map.tiles
  end

  def test_describe
    tiles = [[mock('Tile1'), mock('Tile2')]]
    map = Map.new
    map.expects(:tiles).returns(tiles)

    tiles.each do |row|
      row.each { |tile| tile.expects(:to_h).returns('tile_data') }
    end

    assert_equal '[["tile_data", "tile_data"]]', map.describe.to_s
  end

  def test_render
    tiles = [[mock('Tile1'), mock('Tile2')], [mock('Tile3'), mock('Tile4')]]
    map = Map.new
    map.expects(:tiles).returns(tiles)

    output = capture_output do
      tiles.each_with_index do |row, index|
        row.each_with_index do |tile, tindex|
          tile.expects(:render_to_standard_output).returns(print("#{index}#{tindex}"))
        end
      end
      map.render
    end

    assert_equal "00011011\n\n", output
  end

  def test_index_lookup
    mock_one = mock('Tile1')
    mock_two = mock('Tile2')
    mock_three = mock('Tile3')
    mock_four = mock('Tile4')

    tiles = [[mock_one, mock_two], [mock_three, mock_four]]

    map = Map.new
    map.expects(:tiles).at_least_once.returns(tiles)

    assert_equal mock_one, map[0, 0]
    assert_equal mock_three, map[0, 1]
    assert_equal mock_two, map[1, 0]
    assert_equal mock_four, map[1, 1]
  end

  def test_index_out_of_bound_raises_error
    tiles = [[mock('Tile1'), mock('Tile2')], [mock('Tile3'), mock('Tile4')]]
    map = Map.new
    map.expects(:tiles).at_least_once.returns(tiles)

    assert_raises ArgumentError, 'coordinates out of bounds' do
      map[1, 2]
    end

    assert_raises ArgumentError, 'coordinates out of bounds' do
      map[nil, 2]
    end

    assert_raises ArgumentError, 'coordinates out of bounds' do
      map[1, nil]
    end
  end

  private

  def capture_output
    output = StringIO.new
    $stdout = output
    yield
    output.string
  ensure
    $stdout = STDOUT
  end
end
