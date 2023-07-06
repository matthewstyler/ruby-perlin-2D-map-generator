# frozen_string_literal: true

require 'test_helper'
require 'biome'

class BiomeTest < Minitest::Test
  def test_initialize
    name = 'grassland'
    colour = 'green'
    flora_range = 1
    biome = Biome.new(name: name, colour: colour, flora_range: flora_range)
    assert_equal name, biome.name
    assert_equal colour, biome.colour
    assert_equal flora_range, biome.flora_range
  end

  def test_water?
    water_biome = Biome::OCEAN
    non_water_biome = Biome::GRASSLAND
    assert water_biome.water?
    refute non_water_biome.water?
  end

  def test_land?
    land_biome = Biome::GRASSLAND
    water_biome = Biome::OCEAN
    assert land_biome.land?
    refute water_biome.land?
  end

  def test_grassland?
    grassland_biome = Biome::GRASSLAND
    non_grassland_biome = Biome::OCEAN
    assert grassland_biome.grassland?
    refute non_grassland_biome.grassland?
  end

  def test_desert?
    desert_biome = Biome::DESERT
    non_desert_biome = Biome::GRASSLAND
    assert desert_biome.desert?
    refute non_desert_biome.desert?
  end

  def test_taiga?
    taiga_biome = Biome::TAIGA_PLAIN
    non_taiga_biome = Biome::GRASSLAND
    assert taiga_biome.taiga?
    refute non_taiga_biome.taiga?
  end

  def test_flora_available
    biome_with_flora = Biome.new(name: 'grassland', colour: 'green', flora_range: 1)
    biome_without_flora = Biome.new(name: 'ocean', colour: 'blue')
    assert biome_with_flora.flora_available
    refute biome_without_flora.flora_available
  end

  def test_flora
    assert_instance_of Flora, Biome::GRASSLAND.flora
    assert_equal Flora::DECIDUOUS_TREE, Biome::GRASSLAND.flora.render_symbol

    desert_biome = Biome::DESERT
    taiga_biome = Biome::TAIGA_PLAIN

    assert_instance_of Flora, desert_biome.flora
    assert_equal Flora::CACTUS, desert_biome.flora.render_symbol

    assert_instance_of Flora, taiga_biome.flora
    assert_equal Flora::EVERGREEN_TREE, taiga_biome.flora.render_symbol
  end

  def test_to_h
    name = 'grassland'
    colour = 'green'
    flora_range = 1
    biome = Biome.new(name: name, colour: colour, flora_range: flora_range)
    expected_hash = {
      name: name,
      flora_range: flora_range,
      colour: colour
    }
    assert_equal expected_hash, biome.to_h
  end

  def test_from
    elevation = 0.7
    moist = 0.8
    temp = 0.3
    expected_biome = Biome::MOUNTAIN_FOOT
    assert_equal expected_biome, Biome.from(elevation, moist, temp)
  end

  def test_from_snow
    elevation = 1.0
    moist = 0.5
    temp = 0.5
    expected_biome = Biome::SNOW
    assert_equal expected_biome, Biome.from(elevation, moist, temp)
  end

  def test_from_rocks
    elevation = 0.925
    moist = 0.5
    temp = 0.5
    expected_biome = Biome::ROCKS
    assert_equal expected_biome, Biome.from(elevation, moist, temp)
  end

  def test_from_mountain
    elevation = 0.825
    moist = 0.5
    temp = 0.5
    expected_biome = Biome::MOUNTAIN
    assert_equal expected_biome, Biome.from(elevation, moist, temp)
  end

  def test_from_mountain_foot
    elevation = 0.775
    moist = 0.5
    temp = 0.5
    expected_biome = Biome::MOUNTAIN_FOOT
    assert_equal expected_biome, Biome.from(elevation, moist, temp)
  end

  def test_from_grassland
    elevation = 0.625
    moist = 0.5
    temp = 0.5
    expected_biome = Biome::GRASSLAND
    assert_equal expected_biome, Biome.from(elevation, moist, temp)
  end

  def test_from_valley
    elevation = 0.475
    moist = 0.5
    temp = 0.5
    expected_biome = Biome::VALLEY
    assert_equal expected_biome, Biome.from(elevation, moist, temp)
  end

  def test_from_desert
    elevation = 0.375
    moist = 0.05
    temp = 0.51
    expected_biome = Biome::DESERT
    assert_equal expected_biome, Biome.from(elevation, moist, temp)
  end

  def test_from_deep_desert
    elevation = 0.275
    moist = 0.05
    temp = 0.51
    expected_biome = Biome::DEEP_DESERT
    assert_equal expected_biome, Biome.from(elevation, moist, temp)
  end

  def test_from_steppe_desert
    elevation = 0.61
    moist = 0.05
    temp = 0.51
    expected_biome = Biome::STEPPE_DESERT
    assert_equal expected_biome, Biome.from(elevation, moist, temp)
  end

  def test_from_swamp
    elevation = 0.625
    moist = 0.76
    temp = 0.5
    expected_biome = Biome::SWAMP
    assert_equal expected_biome, Biome.from(elevation, moist, temp)
  end

  def test_from_taiga_plain
    elevation = 0.375
    moist = 0.8
    temp = 0.05
    expected_biome = Biome::TAIGA_PLAIN
    assert_equal expected_biome, Biome.from(elevation, moist, temp)
  end

  def test_from_taiga_valley
    elevation = 0.275
    moist = 0.8
    temp = 0.05
    expected_biome = Biome::TAIGA_VALLEY
    assert_equal expected_biome, Biome.from(elevation, moist, temp)
  end
end
