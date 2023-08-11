# frozen_string_literal: true

require 'set'
require 'pathfinding/priority_queue'

module Pathfinding
  #
  # An A* Pathfinder to build roads/paths between two coordinates containing
  # different path costs, the heuristic behaviour that can be altered via configuration
  #
  class AStarFinder
    def find_path(start_node, end_node, grid)
      came_from = {}
      g_score = { start_node => 0 }
      f_score = { start_node => manhattan_distance(start_node, end_node) }

      open_set = Pathfinding::PriorityQueue.new { |a, b| a[:priority] < b[:priority] }
      open_set.push({ node: start_node, priority: f_score[start_node] })

      until open_set.empty?
        current = open_set.pop[:node]

        return reconstruct_path(came_from, current) if current == end_node

        grid.neighbors(current).each do |neighbor|
          tentative_g_score = g_score[current] + 1

          next if g_score[neighbor] && tentative_g_score >= g_score[neighbor]

          came_from[neighbor] = current
          g_score[neighbor] = tentative_g_score
          f_score[neighbor] = g_score[neighbor] + heuristic_cost_estimate(neighbor, end_node)

          open_set.push({ node: neighbor, priority: f_score[neighbor] })
        end
      end

      # No path found
      []
    end

    private

    def heuristic_cost_estimate(node, end_node)
      manhattan_distance(node, end_node) +
        (node.path_heuristic - end_node.path_heuristic) + # elevation for natural roads
        (node.road? ? 0 : 1000) # share existing roads
    end

    def manhattan_distance(node, end_node)
      (node.x - end_node.x).abs + (node.y - end_node.y).abs
    end

    def reconstruct_path(came_from, current_node)
      path = [current_node]
      while came_from[current_node]
        current_node = came_from[current_node]
        path.unshift(current_node)
      end
      path
    end
  end
end
