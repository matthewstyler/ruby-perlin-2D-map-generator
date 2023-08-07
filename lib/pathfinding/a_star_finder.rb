# frozen_string_literal: true

module Pathfinding
  class AStarFinder
    def find_path(start_node, end_node, grid)
      open_set = [start_node]
      came_from = {}
      g_score = { start_node => 0 }
      f_score = { start_node => heuristic_cost_estimate(start_node, end_node) }

      until open_set.empty?
        current_node = open_set.min_by { |node| f_score[node] }

        return reconstruct_path(came_from, current_node) if current_node == end_node

        open_set.delete(current_node)

        grid.neighbors(current_node).each do |neighbor|
          tentative_g_score = g_score[current_node] + 1

          next unless !g_score[neighbor] || tentative_g_score < g_score[neighbor]

          came_from[neighbor] = current_node
          g_score[neighbor] = tentative_g_score
          f_score[neighbor] = g_score[neighbor] + heuristic_cost_estimate(neighbor, end_node)

          open_set << neighbor unless open_set.include?(neighbor)
        end
      end

      # No path found
      []
    end

    private

    def heuristic_cost_estimate(node, end_node)
      (node.x - end_node.x).abs
      (node.y - end_node.y).abs
      + (node.path_heuristic - end_node.path_heuristic) # elevation for natural roads
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
