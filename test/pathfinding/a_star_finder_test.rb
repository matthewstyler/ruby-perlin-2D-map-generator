# frozen_string_literal: true

require 'test_helper'
require 'pathfinding/a_star_finder'
require 'pathfinding/grid'

class TestAStarFinder < Minitest::Test
  class Node
    attr_reader :x, :y

    def initialize(x, y, can_contain_road = true)
      @x = x
      @y = y
      @can_contain_road = can_contain_road
    end

    def path_heuristic
      0
    end

    def can_contain_road?
      @can_contain_road
    end
  end

  def setup
    @astar_finder = Pathfinding::AStarFinder.new
  end

  def test_returns_empty_path_if_start_and_end_nodes_are_the_same
    nodes = [
      [Node.new(0, 0), Node.new(1, 0), Node.new(2, 0)],
      [Node.new(0, 1), Node.new(1, 1), Node.new(2, 1)],
      [Node.new(0, 2), Node.new(1, 2), Node.new(2, 2)]
    ]
    grid = Pathfinding::Grid.new(nodes)
    start_node = grid.node(1, 1)
    end_node = grid.node(1, 1)

    path = @astar_finder.find_path(start_node, end_node, grid)

    assert_equal [start_node], path
  end

  def test_finds_path_from_top_left_to_bottom_right
    nodes = [
      [Node.new(0, 0), Node.new(1, 0), Node.new(2, 0)],
      [Node.new(0, 1), Node.new(1, 1), Node.new(2, 1)],
      [Node.new(0, 2), Node.new(1, 2), Node.new(2, 2)]
    ]
    grid = Pathfinding::Grid.new(nodes)
    start_node = grid.node(0, 0)
    end_node = grid.node(2, 2)

    path = @astar_finder.find_path(start_node, end_node, grid)

    assert_equal [start_node, grid.node(1, 0), grid.node(2, 0), grid.node(2, 1), end_node], path
  end

  def test_returns_empty_path_if_no_path_is_found
    nodes = [
      [Node.new(0, 0), Node.new(1, 0), Node.new(2, 0)],
      [nil, nil, nil],
      [Node.new(0, 2), Node.new(1, 2), Node.new(2, 2)]
    ]
    grid = Pathfinding::Grid.new(nodes)
    start_node = grid.node(0, 0)
    end_node = grid.node(2, 2)

    path = @astar_finder.find_path(start_node, end_node, grid)

    assert_empty path, 'No valid path should be found due to the obstacle.'
  end

  def test_finds_path_with_obstacles
    nodes = [
      [Node.new(0, 0), Node.new(1, 0), nil, Node.new(3, 0)],
      [Node.new(0, 1), nil, nil, Node.new(3, 1)],
      [Node.new(0, 2), Node.new(1, 2), Node.new(2, 2), Node.new(3, 2)],
      [Node.new(0, 3), Node.new(1, 3), Node.new(2, 3), Node.new(3, 3)]
    ]
    grid = Pathfinding::Grid.new(nodes)
    start_node = grid.node(0, 0)
    end_node = grid.node(3, 3)

    path = @astar_finder.find_path(start_node, end_node, grid)

    expected_path = [
      start_node, grid.node(0, 1), grid.node(0, 2),
      grid.node(1, 2), grid.node(2, 2), grid.node(3, 2),
      grid.node(3, 3)
    ]

    assert_equal expected_path, path, 'The A* pathfinder should find the correct path around obstacles.'
  end

  def test_finds_path_with_non_walkable_paths
    nodes = [
      [Node.new(0, 0), Node.new(1, 0), Node.new(2, 0, false), Node.new(3, 0)],
      [Node.new(0, 1), Node.new(1, 1, false), Node.new(2, 1, false), Node.new(3, 1)],
      [Node.new(0, 2), Node.new(1, 2), Node.new(2, 2), Node.new(3, 2)],
      [Node.new(0, 3), Node.new(1, 3), Node.new(2, 3), Node.new(3, 3)]
    ]
    grid = Pathfinding::Grid.new(nodes)
    start_node = grid.node(0, 0)
    end_node = grid.node(3, 3)

    path = @astar_finder.find_path(start_node, end_node, grid)

    expected_path = [
      start_node, grid.node(0, 1), grid.node(0, 2),
      grid.node(1, 2), grid.node(2, 2), grid.node(3, 2),
      grid.node(3, 3)
    ]

    assert_equal expected_path, path, 'The A* pathfinder should find the correct path around obstacles.'
  end
end
