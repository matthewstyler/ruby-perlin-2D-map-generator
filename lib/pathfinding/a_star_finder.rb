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

      open_set = Pathfinding::PriorityQueue.new
      open_set.push(start_node, f_score[start_node])

      closed_set = Set.new
      until open_set.empty?
        current = open_set.pop

         # Early exit if the current node is in the closed set
         next if closed_set.include?(current)

         # Mark the current node as visited
         closed_set.add(current)

        return reconstruct_path(came_from, current) if current == end_node

        grid.neighbors(current).each do |neighbor|
          tentative_g_score = g_score[current] + 1

          next if closed_set.include?(neighbor) || (g_score[neighbor] && tentative_g_score >= g_score[neighbor])

          came_from[neighbor] = current
          g_score[neighbor] = tentative_g_score
          f_score[neighbor] = g_score[neighbor] + heuristic_cost_estimate(neighbor, end_node)

          open_set.push(neighbor, f_score[neighbor])
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
