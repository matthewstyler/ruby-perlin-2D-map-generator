# frozen_string_literal: true

require 'pathfinding/grid'
require 'pathfinding/a_star_finder'

class RoadGenerator
  attr_reader :grid, :finder

  def initialize(tiles)
    @grid = Pathfinding::Grid.new(tiles)
    @finder = Pathfinding::AStarFinder.new
  end

  def generate(start_x, start_y, end_x, end_y)
    start_node = grid.node(start_x, start_y)
    end_node = grid.node(end_x, end_y)
    finder.find_path(start_node, end_node, grid)
  end
end
