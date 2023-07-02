# frozen_string_literal: true

require 'minitest/autorun'
require 'mocha/minitest'
require 'tile_perlin_generator'
require 'ostruct'

class TilePerlinGeneratorTest < Minitest::Test
  def setup
    @perlin_config = OpenStruct.new(
      width: 100,
      height: 100,
      noise_seed: 123,
      octaves: 4,
      x_frequency: 2.0,
      y_frequency: 2.0,
      persistance: 0.5,
      adjustment: 0.1
    )

    @tile_perlin_generator = TilePerlinGenerator.new(@perlin_config)
  end

  def test_initialize_with_valid_perlin_config
    assert_equal @perlin_config, @tile_perlin_generator.perlin_config
  end

  def test_generate
    perlin_generator_mock = mock('Perlin::Generator')
    noise_value = 0.3
    perlin_generator_mock.stubs(:[]).returns(noise_value)
    Perlin::Generator.stubs(:new).returns(perlin_generator_mock)

    expected_generated_array = Array.new(@perlin_config[:height]) do |y|
      Array.new(@perlin_config[:width]) do |x|
        nx = @perlin_config[:x_frequency] * (x.to_f / @perlin_config[:width] - 0.5)
        ny = @perlin_config[:y_frequency] * (y.to_f / @perlin_config[:height] - 0.5)
        e = noise(nx, ny)
        e = Math.cos(e)**6

        with_adjustment(e)
      end
    end

    generated_array = @tile_perlin_generator.generate

    assert_equal expected_generated_array, generated_array
  end

  def test_with_adjustment_without_adjustment
    result = 0.8
    adjusted_result = @tile_perlin_generator.send(:with_adjustment, result)

    assert_equal 0.9, adjusted_result
  end

  def test_with_adjustment_with_positive_adjustment
    result = 0.7
    @perlin_config[:adjustment] = 0.2
    adjusted_result = @tile_perlin_generator.send(:with_adjustment, result)

    assert_equal result + @perlin_config[:adjustment], adjusted_result
  end

  def test_with_adjustment_with_negative_adjustment
    result = 0.7
    @perlin_config[:adjustment] = -0.2
    adjusted_result = @tile_perlin_generator.send(:with_adjustment, result)

    assert_equal result + @perlin_config[:adjustment], adjusted_result
  end

  def test_with_adjustment_with_positive_adjustment_clamped_to_1
    result = 0.9
    @perlin_config[:adjustment] = 0.3
    adjusted_result = @tile_perlin_generator.send(:with_adjustment, result)

    assert_equal 1.0, adjusted_result
  end

  def test_with_adjustment_with_negative_adjustment_clamped_to_0
    result = 0.1
    @perlin_config[:adjustment] = -0.3
    adjusted_result = @tile_perlin_generator.send(:with_adjustment, result)
    assert_equal 0.0, adjusted_result
  end

  def test_noise
    x = 0.5
    y = 0.5
    noise_value = 0.4

    result = @tile_perlin_generator.send(:noise, x, y)

    assert_in_delta (noise_value / 2) + 0.5, result, 0.01
  end

  private

  def with_adjustment(result)
    if @perlin_config.adjustment != 0.0
      result += @perlin_config.adjustment
      result = [result, 1.0].min
      [result, 0.0].max
    else
      result
    end
  end

  def noise(x, y)
    (noise_generator[x, y] / 2) + 0.5
  end

  def noise_generator
    @noise_generator ||=
      Perlin::Generator.new(
        @perlin_config.noise_seed,
        @perlin_config.persistance,
        @perlin_config.octaves
      )
  end
end
