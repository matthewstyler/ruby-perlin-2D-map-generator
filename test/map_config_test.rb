# frozen_string_literal: true

require 'test_helper'
require 'map_config'

class MapConfigTest < Minitest::Test
  def setup
    @perlin_height_config = MapConfig::PerlinConfig.new(
      width: 100,
      height: 100,
      noise_seed: 123,
      octaves: 4,
      x_frequency: 2.0,
      y_frequency: 2.0,
      persistance: 0.5,
      adjustment: 0.1
    )

    @perlin_moist_config = MapConfig::PerlinConfig.new(
      width: 100,
      height: 100,
      noise_seed: 456,
      octaves: 3,
      x_frequency: 1.5,
      y_frequency: 1.5,
      persistance: 0.8,
      adjustment: -0.2
    )

    @perlin_temp_config = MapConfig::PerlinConfig.new(
      width: 100,
      height: 100,
      noise_seed: 789,
      octaves: 5,
      x_frequency: 2.5,
      y_frequency: 2.5,
      persistance: 0.7,
      adjustment: 0.3
    )

    @width = 200
    @height = 200
    @generate_flora = false

    @map_config = MapConfig.new(
      all_perlin_configs: MapConfig::AllPerlinConfigs.new(@perlin_height_config, @perlin_moist_config, @perlin_temp_config),
      width: @width,
      height: @height,
      generate_flora: @generate_flora
    )
  end

  def test_initialize_with_valid_parameters
    assert_equal @perlin_height_config, @map_config.perlin_height_config
    assert_equal @perlin_moist_config, @map_config.perlin_moist_config
    assert_equal @perlin_temp_config, @map_config.perlin_temp_config
    assert_equal @width, @map_config.width
    assert_equal @height, @map_config.height
    assert_equal @generate_flora, @map_config.generate_flora
  end

  def test_initialize_with_invalid_perlin_height_config
    invalid_perlin_height_config = :invalid
    assert_raises(ArgumentError) do
      MapConfig.new(
        all_perlin_configs: MapConfig::AllPerlinConfigs.new(invalid_perlin_height_config, @perlin_moist_config, @perlin_temp_config)
      )
    end
  end

  def test_initialize_with_invalid_perlin_moist_config
    invalid_perlin_moist_config = :invalid
    assert_raises(ArgumentError) do
      MapConfig.new(
        all_perlin_configs: MapConfig::AllPerlinConfigs.new(@perlin_height_config, invalid_perlin_moist_config, @perlin_temp_config)
      )
    end
  end

  def test_generate_flora
    assert_equal @generate_flora, @map_config.generate_flora
  end
end
