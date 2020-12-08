require 'set'

module GraphUtils
  module_function

  # Each edge is a tuple of `[dependency, dependent]`
  def topo_sort(edges)
    result = []

    graph = Hash.new { _1[_2] = [] }
    edges.each { graph[_1] << _2 }

    leaves = Set.new(graph.keys - graph.values.flatten)
    while leaves.any?
      leaf = leaves.pop
      result << leaf
      leaves.merge((graph.delete(leaf) || []) - graph.values.flatten)
    end

    result
  end
end
