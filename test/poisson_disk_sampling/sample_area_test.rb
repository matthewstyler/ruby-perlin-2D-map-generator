# frozen_string_literal: true

require 'test_helper'

module PoissonDiskSampling
  class SampleAreaTest < Minitest::Test
    def setup
      @grid = [
        [nil, nil],
        [nil, nil],
        [nil, nil]
      ]
      @sample_area = SampleArea.new(grid: @grid)
    end

    def test_initialization
      assert_equal 3, @sample_area.height
      assert_equal 2, @sample_area.width
    end

    def test_update
      @sample_area.set_sampled_point(1, 1)
      # TODO
    end
  end
end
