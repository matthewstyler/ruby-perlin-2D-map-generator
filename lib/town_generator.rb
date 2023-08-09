# frozen_string_literal: true

require 'poisson_disk_sampling/sampler'
require 'poisson_disk_sampling/sample_area'

class TownGenerator
  attr_reader :sample_area

  def initialize(tiles)
    @sample_area = PoissonDiskSampling::SampleArea.new(grid: tiles)
  end

  def generate_random_towns(config)
    return if config.towns <= 0

    seed = config.town_seed

    (1..config.towns).each do |_n|
      random_town = Random.new(seed)
      PoissonDiskSampling::Sampler.new(
        sample_area: sample_area,
        seed: seed
      ).generate_points(random_town.rand(10..40), random_town.rand(1..3)).each do |point|
        seed += 1
        point.add_town_item(seed)
      end
      seed += 1000
    end
  end
end
