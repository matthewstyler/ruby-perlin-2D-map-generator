# frozen_string_literal: true

require 'perlin'

class TilePerlinGenerator
  attr_reader :perlin_config

  def initialize(perlin_config)
    @perlin_config = perlin_config
  end

  def generate
    Array.new(perlin_config.height) do |y|
      Array.new(perlin_config.width) do |x|
        nx = perlin_config.x_frequency * (x.to_f / perlin_config.width - 0.5)
        ny = perlin_config.y_frequency * (y.to_f / perlin_config.height - 0.5)
        with_adjustment((Math.cos(noise(nx, ny))**6))
      end
    end
  end

  private

  def with_adjustment(result)
    if perlin_config.adjustment != 0.0
      result += perlin_config.adjustment
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
        perlin_config.noise_seed,
        perlin_config.persistance,
        perlin_config.octaves
      )
  end
end
