# frozen_string_literal: true

module PoissonDiskSampling
  #
  # Encapsulates area to be sampled by poisson disk sampling
  #
  class SampleArea
    def initialize(grid:)
      @grid = grid.dup
      @points = Array.new(height) { Array.new(width) { false } }
    end

    def height
      @grid.length
    end

    def width
      @grid[0].length
    end

    # rubocop:disable Naming/MethodParameterName:
    def set_sampled_point(x, y)
      @points[y][x] = true
    end

    def [](x, y)
      @grid[y][x]
    end

    def sampled_point?(x, y)
      @points[y][x]
    end

    def point_within_bounds?(x, y)
      y >= 0 && y < height && x >= 0 && x < width
    end
    # rubocop:enable Naming/MethodParameterName:
  end
end
