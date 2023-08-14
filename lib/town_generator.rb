# frozen_string_literal: true

require 'poisson_disk_sampling/sampler'
require 'poisson_disk_sampling/sample_area'
require 'road_generator'
require 'map_config'

#
# Generates building tile items using Poisson Disk Sampling for the given tiles
# Roads are generated between the buildings and between towns using A* pathfinding
#
class TownGenerator
  attr_reader :sample_area, :road_generator

  def initialize(tiles, seed: MapConfig::DEFAULT_TOWN_SEED)
    @sample_area = PoissonDiskSampling::SampleArea.new(grid: tiles)
    @road_generator = RoadGenerator.new(tiles)
    @seed = seed
    @all_town_points = []
  end

  def generate_random_towns(config)
    return if config.towns <= 0

    puts "generating #{config.towns} random towns..." if config.verbose

    @all_town_points.concat(iterate_through_towns(config.towns) do |n|
      generate_random_town(n, config.verbose)
    end)

    generate_roads_between_towns(config.verbose)
  end

  def generate_towns_from_coordinate_list(config)
    return unless (config.towns_to_make.length % 4).zero?

    puts "generating #{config.towns_to_make.length / 4} coordinate towns..." if config.verbose

    @all_town_points.concat(iterate_through_towns((config.towns_to_make.length / 4)) do |n|
      town_values = config.towns_to_make[(n - 1) * 4..].take(4)
      generate_town(n, town_values[2], town_values[3], [sample_area[town_values[0], town_values[1]]], config.verbose)
    end)

    generate_roads_between_towns(config.verbose)
  end

  private

  def iterate_through_towns(num_of_towns)
    (1..num_of_towns).map do |n|
      town_points = yield n
      @seed += 1000
      town_points
    end
  end

  def generate_random_town(town_num, verbose)
    random_town_gen = Random.new(@seed)
    generate_town(town_num, random_town_gen.rand(10..40), random_town_gen.rand(2..4), nil, verbose)
  end

  def generate_town(town_num, num_of_points, radius, initial_coords, verbose)
    puts "generating town #{town_num}..." if verbose

    points = generate_points_for_town(num_of_points, radius, initial_coords)
    generate_town_roads(points, town_num, verbose)
    points
  end

  def generate_points_for_town(num_of_points, radius, intial_coordinates)
    points =
      PoissonDiskSampling::Sampler.new(
        sample_area: sample_area,
        seed: @seed
      ).generate_points(num_of_points, radius, intial_coordinates)
    points.each do |point|
      @seed += 1
      point.add_town_item(@seed)
    end
    points
  end

  def generate_town_roads(points, town_num, verbose)
    # TODO: slow, bad (complete graph) will update to use minimum tree spanning algorithm instead
    puts "generating town #{town_num} roads..." if verbose

    connected_pairs = Set.new
    points.each_with_index do |point_one, idx_one|
      points[idx_one + 1..].each do |point_two|
        next if connected_pairs.include?([point_one, point_two]) || connected_pairs.include?([point_two, point_one])

        road_to_building_one = place_in_front_or_behind(point_one)
        road_to_building_two = place_in_front_or_behind(point_two)

        connected_pairs.add([point_one, point_two])
        connected_pairs.add([point_two, point_one])

        next if road_to_building_one.nil? || road_to_building_two.nil?

        road_generator.generate_roads_from_coordinate_list(road_to_building_one.concat(road_to_building_two), false)
      end
    end
  end

  def place_in_front_or_behind(point)
    return [point.x, point.y - 1] if sample_area.point_within_bounds_and_can_have_road?(point.x, point.y - 1)
    return [point.x, point.y + 1] if sample_area.point_within_bounds_and_can_have_road?(point.x, point.y + 1)
    return [point.x - 1, point.y] if sample_area.point_within_bounds_and_can_have_road?(point.x - 1, point.y)
    return [point.x + 1, point.y] if sample_area.point_within_bounds_and_can_have_road?(point.x + 1, point.y)

    nil
  end

  def generate_roads_between_towns(verbose)
    return if @all_town_points.length < 2

    puts 'generating roads between towns...' if verbose

    connected_pairs = Set.new
    town_centroids = {}

    @all_town_points.each_with_index do |town_one, idx_one|
      find_town_centroid(town_one)

      @all_town_points[idx_one + 1..].each do |town_two|
        next if connected_pairs.include?([town_one, town_two]) || connected_pairs.include?([town_two, town_one])

        town_one_center_x, town_one_center_y = (town_centroids[town_one] ||= find_town_centroid(town_one))
        town_two_center_x, town_two_center_y = (town_centroids[town_two] ||= find_town_centroid(town_two))

        road_generator.generate_roads_from_coordinate_list([town_one_center_x, town_one_center_y, town_two_center_x, town_two_center_y], false)

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
