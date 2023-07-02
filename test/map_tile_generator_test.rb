# frozen_string_literal: true

require 'minitest/autorun'
require 'mocha/minitest'
require 'map_tile_generator'
require 'ostruct'

class MapTileGeneratorTest < Minitest::Test
  def setup
    @map = mock('Map')
    @map_config = OpenStruct.new(width: 2, height: 2)
    @map.stubs(:config).returns(@map_config)

    @height_perlin_generator = mock('TilePerlinGenerator')
    @moist_perlin_generator = mock('TilePerlinGenerator')
    @temp_perlin_generator = mock('TilePerlinGenerator')

    @generator = MapTileGenerator.new(
      map: @map,
      height_perlin_generator: @height_perlin_generator,
      moist_perlin_generator: @moist_perlin_generator,
      temp_perlin_generator: @temp_perlin_generator
    )
  end

  def test_initialize_with_custom_perlin_generators
    assert_equal @map, @generator.map
    assert_equal @map_config, @generator.map_config
    assert_equal @height_perlin_generator, @generator.height_perlin_generator
    assert_equal @moist_perlin_generator, @generator.moist_perlin_generator
    assert_equal @temp_perlin_generator, @generator.temp_perlin_generator
  end

  def test_initialize_with_default_perlin_generators
    @map_config.stubs(:perlin_height_config).returns({})
    @map_config.stubs(:perlin_moist_config).returns({})
    @map_config.stubs(:perlin_temp_config).returns({})
    @generator.stubs(:map_config).returns(@map_config)
    TilePerlinGenerator.expects(:new).times(3)

    generator = MapTileGenerator.new(map: @map)

    assert_equal @map, generator.map
    assert_equal @map_config, generator.map_config
  end

  def test_generate
    height_map = [[0.1, 0.2], [0.3, 0.4]]
    moist_map = [[0.5, 0.6], [0.7, 0.8]]
    temp_map = [[0.9, 1.0], [1.1, 1.2]]
    expected_tiles = [
      [Tile.new(map: @map, x: 0, y: 0, height: 0.1, moist: 0.5, temp: 0.9),
       Tile.new(map: @map, x: 1, y: 0, height: 0.2, moist: 0.6, temp: 1.0)],
      [Tile.new(map: @map, x: 0, y: 1, height: 0.3, moist: 0.7, temp: 1.1),
       Tile.new(map: @map, x: 1, y: 1, height: 0.4, moist: 0.8, temp: 1.2)]
    ]
    @height_perlin_generator.stubs(:generate).returns(height_map)
    @moist_perlin_generator.stubs(:generate).returns(moist_map)
    @temp_perlin_generator.stubs(:generate).returns(temp_map)

    tiles = @generator.generate

    expected_tiles.each_with_index do |expected_row, expected_row_index|
      expected_row.each_with_index do |expected_tile, expected_tile_index|
        assert_equal expected_tile.height, tiles[expected_row_index][expected_tile_index].height
        assert_equal expected_tile.moist, tiles[expected_row_index][expected_tile_index].moist
        assert_equal expected_tile.temp, tiles[expected_row_index][expected_tile_index].temp
        assert_equal expected_tile.x, tiles[expected_row_index][expected_tile_index].x
        assert_equal expected_tile.y, tiles[expected_row_index][expected_tile_index].y
        assert_equal expected_tile.map, tiles[expected_row_index][expected_tile_index].map
      end
    end
  end

  def test_positive_quadrant_cartesian_plane
    @generator.stubs(:heights).returns([[0.1, 0.2], [0.3, 0.4]])
    @generator.stubs(:moists).returns([[0.5, 0.6], [0.7, 0.8]])
    @generator.stubs(:temps).returns([[0.9, 1.0], [1.1, 1.2]])
    expected_tiles = [
      [Tile.new(map: @map, x: 0, y: 0, height: 0.1, moist: 0.5, temp: 0.9),
       Tile.new(map: @map, x: 1, y: 0, height: 0.2, moist: 0.6, temp: 1.0)],
      [Tile.new(map: @map, x: 0, y: 1, height: 0.3, moist: 0.7, temp: 1.1),
       Tile.new(map: @map, x: 1, y: 1, height: 0.4, moist: 0.8, temp: 1.2)]
    ]

    tiles = @generator.send(:positive_quadrant_cartesian_plane)

    expected_tiles.each_with_index do |expected_row, expected_row_index|
      expected_row.each_with_index do |expected_tile, expected_tile_index|
        assert_equal expected_tile.height, tiles[expected_row_index][expected_tile_index].height
        assert_equal expected_tile.moist, tiles[expected_row_index][expected_tile_index].moist
        assert_equal expected_tile.temp, tiles[expected_row_index][expected_tile_index].temp
        assert_equal expected_tile.x, tiles[expected_row_index][expected_tile_index].x
        assert_equal expected_tile.y, tiles[expected_row_index][expected_tile_index].y
        assert_equal expected_tile.map, tiles[expected_row_index][expected_tile_index].map
      end
    end
  end
end
