# frozen_string_literal: true

require 'test_helper'
require 'pathfinding/grid'

class GridTest < Minitest::Test
  def setup
    # Sample grid data for testing
    nodes = [
      [Node.new(0, 0, false), Node.new(1, 0, true), Node.new(2, 0, true)],
      [Node.new(0, 1, true), Node.new(1, 1, true), Node.new(2, 1, true)],
      [Node.new(0, 2, true), Node.new(1, 2, true), Node.new(2, 2, false)]
    ]
    @grid = Pathfinding::Grid.new(nodes)
  end

  class Node
    # Replace this with your Node class implementation or use a mock/fake Node class.
    attr_reader :x, :y

    def initialize(x, y, road)
      @x = x
      @y = y
      @road = road
    end

    def can_contain_road?
      @road
    end
  end

  def test_node_method_returns_correct_node
    node = @grid.node(1, 2)
    assert_instance_of Node, node
    assert_equal 1, node.x
    assert_equal 2, node.y
  end

  def test_neighbors_method_returns_correct_neighbors
    # In this sample grid, (1, 1) node has four neighbors with roads (top, bottom, left, right)
    neighbors = @grid.neighbors(@grid.node(1, 1))
    assert_equal 4, neighbors.size

    # Assuming Node objects have a `can_contain_road?` method
    neighbors.each do |neighbor|
      assert_equal true, neighbor.can_contain_road?
    end
  end

  def test_min_max_coordinates_method_returns_correct_values
    min_max = @grid.min_max_coordinates
    assert_equal({ min_x: 0, min_y: 0, max_x: 2, max_y: 2 }, min_max)
  end
end
