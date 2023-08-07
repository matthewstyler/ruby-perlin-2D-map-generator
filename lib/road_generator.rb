# frozen_string_literal: true

require 'pathfinding/grid'
require 'pathfinding/a_star_finder'

class RoadGenerator
  attr_reader :grid, :finder

  def initialize(tiles)
    @grid = Pathfinding::Grid.new(tiles)
    @finder = Pathfinding::AStarFinder.new
  end

  def generate_num_of_roads(x)
    return if x <= 0

    (1..x).each do |_n|
      random_objects_at_edges = @grid.edge_nodes.sample(2)
      generate_path(
        random_objects_at_edges[0].x,
        random_objects_at_edges[0].y,
        random_objects_at_edges[1].x,
        random_objects_at_edges[1].y
      ).each(&:make_road)
    end
  end

  def generate_path(start_x, start_y, end_x, end_y)
    start_node = grid.node(start_x, start_y)
    end_node = grid.node(end_x, end_y)
    finder.find_path(start_node, end_node, grid)
  end
end
