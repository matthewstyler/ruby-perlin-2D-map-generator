# frozen_string_literal: true

require 'pathfinding/grid'
require 'pathfinding/a_star_finder'

#
# Generates roads across map tiles, randomly or given specific coordinates
#
class RoadGenerator
  attr_reader :grid, :finder

  def initialize(tiles)
    @grid = Pathfinding::Grid.new(tiles)
    @finder = Pathfinding::AStarFinder.new
  end

  def generate_num_of_random_roads(config)
    return if config.roads <= 0

    puts "generating #{config.roads} random roads..." if config.verbose

    seed = config.road_seed
    (1..config.roads).each do |n|
      puts "generating road #{n}..." if config.verbose
      random_objects_at_edges = random_nodes_not_on_same_edge(seed + n) # add n otherwise each road is the same
      generate_path(
        random_objects_at_edges[0].x,
        random_objects_at_edges[0].y,
        random_objects_at_edges[1].x,
        random_objects_at_edges[1].y
      ).each(&:make_road)
    end
  end

  def generate_roads_from_coordinate_list(road_paths, verbose)
    return unless (road_paths.length % 4).zero?

    puts "generating #{road_paths.length / 4} coordinate roads..." if verbose

    road_paths.each_slice(4) do |road_coordinates|
      generate_path(
        road_coordinates[0],
        road_coordinates[1],
        road_coordinates[2],
        road_coordinates[3]
      ).each(&:make_road)
    end
  end

  def generate_path(start_x, start_y, end_x, end_y)
    start_node = grid.node(start_x, start_y)
    end_node = grid.node(end_x, end_y)
    finder.find_path(start_node, end_node, grid)
  end

  private

  def random_nodes_not_on_same_edge(seed)
    random_generator = Random.new(seed)
    length = @grid.edge_nodes.length

    loop do
      index1 = random_generator.rand(length)
      index2 = random_generator.rand(length)
      node_one, node_two = @grid.edge_nodes.values_at(index1, index2)

      return [node_one, node_two] if node_one.x != node_two.x && node_one.y != node_two.y
    end
  end
end
