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

    all_town_points = (1..config.towns).map do |_n|
      town_points = generate_random_town(seed)
      seed += 1000
      town_points
    end
    generate_roads_between_towns(all_town_points)
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
    points
  end

  def generate_town_roads(points)
    connected_pairs = Set.new
    points.each_with_index do |point_one, idx_one|
      points[idx_one + 1..].each do |point_two|
        next if connected_pairs.include?([point_one, point_two]) || connected_pairs.include?([point_two, point_one])

        road_generator.generate_roads_from_coordinate_list([point_one.x, point_one.y, point_two.x, point_two.y])

        connected_pairs.add([point_one, point_two])
        connected_pairs.add([point_two, point_one])
      end
    end
  end

  def generate_roads_between_towns(all_town_points)
    return if all_town_points.length < 2

    connected_pairs = Set.new
    town_centroids = {}

    all_town_points.each_with_index do |town_one, idx_one|
      find_town_centroid(town_one)

      all_town_points[idx_one + 1..].each do |town_two|
        next if connected_pairs.include?([town_one, town_two]) || connected_pairs.include?([town_two, town_one])

        town_one_center_x, town_one_center_y = (town_centroids[town_one] ||= find_town_centroid(town_one))
        town_two_center_x, town_two_center_y = (town_centroids[town_two] ||= find_town_centroid(town_two))

        road_generator.generate_roads_from_coordinate_list([town_one_center_x, town_one_center_y, town_two_center_x, town_two_center_y])

        connected_pairs.add([town_one, town_two])
        connected_pairs.add([town_two, town_one])
      end
    end
  end

  def find_town_centroid(points)
    total_x = 0
    total_y = 0
    num_coordinates = points.length

    points.each do |point|
      total_x += point.x
      total_y += point.y
    end

    average_x = total_x / num_coordinates.to_f
    average_y = total_y / num_coordinates.to_f

    [average_x, average_y]
  end
end
