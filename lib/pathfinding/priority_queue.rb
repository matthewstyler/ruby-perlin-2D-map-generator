# frozen_string_literal: true

module Pathfinding
  #
  # A Priority Queue implementation for managing elements with associated priorities.
  # Elements are stored and retrieved based on their priority values.
  #
  # This Priority Queue is implemented using a binary heap, which provides efficient
  # insertion, extraction of the minimum element, and deletion operations.
  #
  class PriorityQueue
    def initialize(&block)
      @heap = []
      @compare = block || proc { |a, b| a < b }
    end

    def push(item)
      @heap << item
      heapify_up(@heap.length - 1)
    end

    def pop
      return nil if @heap.empty?

      swap(0, @heap.length - 1)
      popped = @heap.pop
      heapify_down(0)
      popped
    end

    def peek
      @heap[0]
    end

    def empty?
      @heap.empty?
    end

    private

    def heapify_up(index)
      parent_index = (index - 1) / 2

      return unless index.positive? && @compare.call(@heap[index], @heap[parent_index])

      swap(index, parent_index)
      heapify_up(parent_index)
    end

    def heapify_down(index)
      left_child_index = 2 * index + 1
      right_child_index = 2 * index + 2
      smallest = index

      smallest = left_child_index if left_child_index < @heap.length && @compare.call(@heap[left_child_index], @heap[smallest])

      smallest = right_child_index if right_child_index < @heap.length && @compare.call(@heap[right_child_index], @heap[smallest])

      return unless smallest != index

      swap(index, smallest)
      heapify_down(smallest)
    end

    # rubocop:disable Naming/MethodParameterName:
    def swap(i, j)
      @heap[i], @heap[j] = @heap[j], @heap[i]
    end
    # rubocop:enable Naming/MethodParameterName:
  end
end
