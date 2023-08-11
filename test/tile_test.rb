# frozen_string_literal: true

require 'test_helper'
require 'mocha/minitest'
require 'ostruct'
require 'tile'

class TileTest < Minitest::Test
  def setup
    @map = mock('Map')
    @map.stubs(:config).returns(OpenStruct.new(generate_flora: true))
    @map.stubs(:tiles).returns([])
    @x = 1
    @y = 1
    @height = 0.5
    @moist = 0.5
    @temp = 0.5
    @type = :terrain

    @tile = Tile.new(
      map: @map,
      x: @x,
      y: @y,
      height: @height,
      moist: @moist,
      temp: @temp,
      type: @type
    )
  end

  def test_initialize_with_valid_parameters
    assert_equal @map, @tile.map
    assert_equal @x, @tile.x
    assert_equal @y, @tile.y
    assert_equal @height, @tile.height
    assert_equal @moist, @tile.moist
    assert_equal @temp, @tile.temp
    assert_equal @type, @tile.type
  end

  def test_surrounding_tiles
    distance = 1
    mock_tile = mock('Tile')
    @map.stubs(:tiles).returns([[mock_tile, mock_tile, mock_tile], [mock_tile, @tile, mock_tile],
                                [mock_tile, mock_tile, mock_tile]])

    surrounding_tiles = @tile.surrounding_tiles(distance)

    assert_equal 9, surrounding_tiles.size
    assert_equal mock_tile, surrounding_tiles[0]
    assert_equal mock_tile, surrounding_tiles[1]
    assert_equal mock_tile, surrounding_tiles[2]
    assert_equal mock_tile, surrounding_tiles[3]
    assert_equal @tile, surrounding_tiles[4]
    assert_equal mock_tile, surrounding_tiles[5]
    assert_equal mock_tile, surrounding_tiles[6]
    assert_equal mock_tile, surrounding_tiles[7]
    assert_equal mock_tile, surrounding_tiles[8]
  end

  def test_biome
    mock_biome = mock('Biome')
    Biome.stubs(:from).returns(mock_biome)

    assert_equal mock_biome, @tile.biome
  end

  def test_items_with_flora_generation_disabled
    @tile.expects(:items_generated_with_flora_if_applicable).returns([])

    items = @tile.items

    assert_empty items
  end

  def test_items_with_flora_generation_enabled_and_flora_available
    @tile.expects(:items_generated_with_flora_if_applicable).returns(['Flower'])

    items = @tile.items

    assert_equal ['Flower'], items
  end

  def test_items_with_flora_generation_enabled_but_flora_unavailable
    @tile.expects(:items_generated_with_flora_if_applicable).returns([])

    biome = mock('Biome')
    biome.stubs(:flora_available).returns(false)
    @tile.stubs(:biome).returns(biome)

    items = @tile.items

    assert_empty items
  end

  def test_add_item_with_valid_tile_item
    tile_item = TileItem.new('test', render_symbol: 'test')

    @tile.add_item(tile_item)

    assert_equal [tile_item], @tile.items
  end

  def test_add_item_with_invalid_tile_item
    tile_item = :invalid

    assert_raises(ArgumentError) do
      @tile.add_item(tile_item)
    end
  end

  def test_item_with_highest_priority
    tile_item1 = mock('TileItem', render_priority: 1)
    tile_item2 = mock('TileItem', render_priority: 2)
    tile_item3 = mock('TileItem', render_priority: 3)
    @tile.stubs(:items).returns([tile_item1, tile_item2, tile_item3])

    highest_priority_item = @tile.item_with_highest_priority

    assert_equal tile_item3, highest_priority_item
  end

  def test_to_h
    mock_biome = mock('Biome')
    biome_hash = { name: 'Forest', color: '#00FF00' }
    mock_biome.stubs(:to_h).returns(biome_hash)
    @tile.stubs(:biome).returns(mock_biome)

    tile_item = mock('TileItem')
    tile_item_hash = { name: 'Flower', symbol: '*' }
    tile_item.stubs(:to_h).returns(tile_item_hash)
    @tile.stubs(:items).returns([tile_item])

    expected_hash = {
      x: @x,
      y: @y,
      height: @height,
      moist: @moist,
      temp: @temp,
      biome: biome_hash,
      items: [tile_item_hash],
      type: :terrain
    }

    assert_equal expected_hash, @tile.to_h
  end

  def test_invalid_tile_type_raises_error
    result = assert_raises ArgumentError, 'invalid tile type' do
      Tile.new(
        map: @map,
        x: @x,
        y: @y,
        type: :not_real
      )
    end

    assert_equal 'invalid tile type', result.to_s
  end

  def test_make_road
    tile = Tile.new(
      map: @map,
      x: @x,
      y: @y
    )
    assert_equal :terrain, tile.type
    tile.make_road
    assert_equal :road, tile.type
  end

  def test_tile_path_heuristic_is_elevatione
    assert_equal @tile.height, @tile.path_heuristic
  end

  def test_tile_can_contain_road
    tile = Tile.new(
      map: @map,
      x: @x,
      y: @y,
      height: @height,
      moist: @moist,
      temp: @temp,
      type: @type
    )

    assert tile.can_haz_road?

    tile.biome.expects(:water?).returns(true)
    @map.config.expects(:road_config).returns(OpenStruct.new(road_exclude_water_path: true))

    refute tile.can_haz_road?
  end
end
