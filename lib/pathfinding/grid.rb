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

      neighbors << node(x - 1, y) if x.positive? && !node(x - 1, y).nil? && node.can_contain_road?
      neighbors << node(x + 1, y) if x < @nodes[0].size - 1 && !node(x + 1, y).nil? && node.can_contain_road?
      neighbors << node(x, y - 1) if y.positive? && !node(x, y - 1).nil? && node.can_contain_road?
      neighbors << node(x, y + 1) if y < @nodes.size - 1 && !node(x, y + 1).nil? && node.can_contain_road?

      neighbors
    end

    def min_max_coordinates
      @min_max_coordinates ||= begin
        min_x = nil
        min_y = nil
        max_x = nil
        max_y = nil

        @nodes.each do |row|
          row.each do |object|
            x = object.x
            y = object.y

            # Update minimum x and y values
            min_x = x if min_x.nil? || x < min_x
            min_y = y if min_y.nil? || y < min_y

            # Update maximum x and y values
            max_x = x if max_x.nil? || x > max_x
            max_y = y if max_y.nil? || y > max_y
          end
        end

        { min_x: min_x, min_y: min_y, max_x: max_x, max_y: max_y }
      end
    end

    def edge_nodes
      @edge_nodes ||=
        @nodes.map do |row|
          row.select do |obj|
            obj.x == min_max_coordinates[:min_x] ||
              obj.x == min_max_coordinates[:max_x] ||
              obj.y == min_max_coordinates[:min_y] ||
              obj.y == min_max_coordinates[:max_y]
          end
        end.flatten
    end
  end
end
