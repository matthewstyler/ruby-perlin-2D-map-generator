# frozen_string_literal: true

require 'test_helper'
require 'poisson_disk_sampling/sampler'
require 'poisson_disk_sampling/sample_area'
require 'ostruct'

module PoissonDiskSampling
  class SamplerTest < Minitest::Test
    def setup
      @width = 100
      @height = 200
      @radius = 10
      @num_attempts = 10
      @poisson_sampler =
        PoissonDiskSampling::Sampler.new(
          sample_area: PoissonDiskSampling::SampleArea.new(
            grid: Array.new(@height) do |y|
                    Array.new(@width) do |x|
                      OpenStruct.new(x: x, y: y, can_haz_town?: true)
                    end
                  end
          ),
          num_attempts: @num_attempts
        )
    end

    def test_generate_points_returns_array
      points = @poisson_sampler.generate_points(5, @radius)
      assert_instance_of Array, points
      assert_equal 5, points.length
    end

    def test_generated_points_are_within_bounds
      points = @poisson_sampler.generate_points(5, @radius)
      points.each do |point|
        assert_includes 0..@height, point.y
        assert_includes 0..@width, point.x
      end
    end

    def test_generated_points_have_minimum_distance
      points = @poisson_sampler.generate_points(5, @radius)
      @radius.times do |_r|
        points.each_with_index do |point1, i|
          points[i + 1..].each do |point2|
            distance = Math.sqrt((point1.y - point2.y)**2 + (point1.x - point2.x)**2)
            assert_operator distance.round, :>=, @radius, "Points #{point1} and #{point2} are too close"
          end
        end
      end
    end
  end
end
