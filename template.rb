require './shared'

example_input = nil
#example_input = <<EOS
#EOS

input = (example_input || File.read('dayN.input')).strip
# or
input = (example_input || File.read('dayN.input')).strip.lines.map(&:chomp)

Pry.start(binding, quiet: true)

# grid = Grid.new(:y_down OR :y_up)
# include grid.point_ops
# using grid.point_ops
# grid.fill(INPUT[0].length, INPUT.length, INPUT.flat_map { |l| l.split('') })

# require './lib/graph_utils'
# GraphUtils.topo_sort([[dependency, dependent], ...])

