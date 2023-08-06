# frozen_string_literal: true

module Pathfinding
  class Grid
    attr_reader :nodes

    def initialize(nodes)
      @nodes = nodes
    end

    def node(x, y)
      nodes[y][x]
    end

    def neighbors(node)
      neighbors = []
      x = node.x
      y = node.y

      neighbors << node(x - 1, y) if x.positive? && !node(x - 1, y).nil?
      neighbors << node(x + 1, y) if x < @nodes[0].size - 1 && !node(x + 1, y).nil?
      neighbors << node(x, y - 1) if y.positive? && !node(x, y - 1).nil?
      neighbors << node(x, y + 1) if y < @nodes.size - 1 && !node(x, y + 1).nil?

      neighbors
    end
  end
end
