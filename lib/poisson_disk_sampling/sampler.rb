# frozen_string_literal: true

require 'pry-byebug'
module PoissonDiskSampling
  #
  # Generates X randomly distributed points within given 2D space
  # using possion disk sampling
  #
  class Sampler
    attr_reader :sample_area, :num_attempts, :seed

    def initialize(sample_area:, num_attempts: 20, seed: rand)
      @sample_area = sample_area
      @num_attempts = num_attempts
      @seed = seed
    end

    def generate_points(num_of_points, radius, intial_start_point = nil)
      raise ArgumentError, "invalid start argument #{intial_start_point}" if !intial_start_point.nil? && !intial_start_point.is_a?(Array) && intial_start_point.length != 1

      retreive_points_until_active_list_empty_or_num_points_reached(intial_start_point || generate_and_assign_initial_point, num_of_points, radius)
    end

    private

    def retreive_points_until_active_list_empty_or_num_points_reached(active_list, num_of_points, radius)
      points = []
      retrieve_points(active_list, points, num_of_points, radius) until active_list.empty? || points.length == num_of_points
      points
    end

    def retrieve_points(active_list, points, num_of_points, radius)
      return if active_list.empty?

      current_point, active_index = retreive_current_point(active_list)
      found = false

      num_attempts.times do
        new_point = generate_random_point_around(current_point, radius)
        next if new_point.nil?
        next unless new_point.can_haz_town? && neighbours_empty?(new_point, radius)

        sample_area.set_sampled_point(new_point.x, new_point.y)
        active_list << new_point
        points << new_point
        return points if points.length == num_of_points

        found = true
        break
      end

      active_list.delete_at(active_index) unless found
    end

    def random_value_and_increment_seed(max)
      val = Random.new(seed).rand(max)
      @seed += 1
      val
    end

    def retreive_current_point(active_list)
      active_index = random_value_and_increment_seed(active_list.length)
      current_point = active_list[active_index]
      [current_point, active_index]
    end

    def neighbours_empty?(new_point, radius)
      cell_empty = true
      (-radius..radius).each do |dy|
        (-radius..radius).each do |dx|
          x = new_point.x + dx
          y = new_point.y + dy
          next unless sample_area.point_within_bounds?(x, y) && sample_area[x, y]

          if sample_area.sampled_point?(x, y) && distance(new_point, sample_area[x, y]) < radius
            cell_empty = false
            break
          end
        end
        break unless cell_empty
      end
    end

    def generate_and_assign_initial_point
      num_attempts.times do
        initial_point_coords = [random_value_and_increment_seed(sample_area.width), random_value_and_increment_seed(sample_area.height)]

        if sample_area[initial_point_coords[0], initial_point_coords[1]].can_haz_town?
          sample_area.set_sampled_point(initial_point_coords[0], initial_point_coords[1])
          return [sample_area[initial_point_coords[0], initial_point_coords[1]]]
        end
      end
      []
    end

    def generate_random_point_around(point, radius)
      distance = radius * (random_value_and_increment_seed(1.0) + 1)
      angle = 2 * Math::PI * random_value_and_increment_seed(1.0)
      generated = [point.y + distance * Math.cos(angle), point.x + distance * Math.sin(angle)].map(&:round)

      sample_area.point_within_bounds?(generated[1], generated[0]) ? sample_area[generated[1], generated[0]] : nil
    end

    def distance(point1, point2)
      Math.sqrt((point1.y - point2.y)**2 + (point1.x - point2.x)**2)
    end
  end
end
