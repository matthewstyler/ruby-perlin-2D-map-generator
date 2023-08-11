# frozen_string_literal: true

require 'poisson_disk_sampling/sampler'
require 'poisson_disk_sampling/sample_area'
require 'road_generator'
require 'concurrent'

class TownGenerator
  attr_reader :sample_area, :road_generator

  def initialize(tiles)
    @sample_area = PoissonDiskSampling::SampleArea.new(grid: tiles)
    @road_generator = RoadGenerator.new(tiles)
  end

  def generate_random_towns(config)
    return if config.towns <= 0

    seed = config.town_seed

    (1..config.towns).each do |_n|
      generate_random_town(seed)
      seed += 1000
    end
  end

  private

  def generate_random_town(seed)
    random_town_gen = Random.new(seed)
    points =
      PoissonDiskSampling::Sampler.new(
        sample_area: sample_area,
        seed: seed
      ).generate_points(random_town_gen.rand(10..40), random_town_gen.rand(2..4))
    points.each do |point|
      seed += 1
      point.add_town_item(seed)
    end
    generate_town_roads(points)
  end

  def generate_town_roads(points)
    connected_pairs = Set.new
    points.each_with_index do |point_one, idx_one|
      points[idx_one + 1..].each do |point_two|
        next if connected_pairs.include?([point_one, point_two]) || connected_pairs.include?([point_two, point_one])

        road_generator.generate_roads_from_coordinate_list([point_one.x, point_one.y, point_two.x, point_two.y])

        connected_pairs.add([point_one, point_two])
      end
    end
  end
end
