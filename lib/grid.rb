require 'set'

class Grid
  class Direction < Module
    def ===(other)
      self == other
    end
  end

  UP = Direction.new
  RIGHT = Direction.new
  DOWN = Direction.new
  LEFT = Direction.new

  DIRECTIONS = [UP, RIGHT, DOWN, LEFT]

  DIRECTIONS.each_with_index do |dir, idx|
    dir.define_singleton_method(:turn_right) { DIRECTIONS[(idx + 1) % 4] }
    dir.define_singleton_method(:reverse) { DIRECTIONS[(idx + 2) % 4] }
    dir.define_singleton_method(:turn_left) { DIRECTIONS[(idx + 3) % 4] }
  end

  ORTHOGONAL_NEIGHBORS = [
    [-1, 0],
    [0, -1],
    [1, 0],
    [0, 1],
  ]

  DIAGONAL_NEIGHBORS = []
  (-1..1).each do |x|
    (-1..1).each do |y|
      next if x == 0 && y == 0
      DIAGONAL_NEIGHBORS.push([x, y])
    end
  end

  attr_accessor :grid, :default, :mode
  protected :grid=

  def initialize(system = :y_up, default: nil, mode: :diagonal)
    unless %i[y_up y_down].include?(system)
      raise "System must be y_up or y_down"
    end

    unless %i[diagonal orthogonal].include?(mode)
      raise "Mode must be diagonal or orthogonal"
    end

    @grid = {}

    @system = system
    @default = default
    @mode = mode
  end

  def ==(other)
    @grid == other.grid
  end

  def keys
    @grid.keys
  end

  def values
    @grid.values
  end

  def size
    @grid.size
  end

  def [](x, y)
    @grid[[x, y]] || @default
  end

  def []=(x, y, value)
    @grid[[x, y]] = value
  end

  def dup
    Grid.new(@system, default: @default, mode: @mode).tap do |new_grid|
      new_grid.grid = @grid.dup
    end
  end

  def select(&block)
    dup.tap do |new_grid|
      new_grid.grid = @grid.select(&block)
    end
  end

  def map(&block)
    dup.tap do |new_grid|
      new_grid.grid = @grid.map { |k, v| [k, block.call(k, v)] }.to_h
    end
  end

  def neighbors(x, y)
    deltas = @mode == :orthogonal ? ORTHOGONAL_NEIGHBORS : DIAGONAL_NEIGHBORS
    deltas.map do |dx, dy|
      self[x + dx, y + dy]
    end
  end

  def visible_neighbors(x, y, &test_opaque)
    deltas = @mode == :orthogonal ? ORTHOGONAL_NEIGHBORS : DIAGONAL_NEIGHBORS
    deltas.map do |dx, dy|
      xx, yy = x + dx, y + dy
      while (next_value = self[xx, yy])
        break next_value if test_opaque.(next_value)
        xx, yy = xx + dx, yy + dy
      end
    end
  end

  def shortest_path(from, to, &block)
    to_visit = [[from, []]]
    visited = Set.new

    loop do
      at, path = to_visit.shift
      visited.add(at)

      each_neighbor(*at) do |cell, coords|
        next if visited.include?(coords)
        return [*path, coords] if coords == to
        passable = block.call(cell, coords)
        if passable
          to_visit << [coords, [*path, coords]]
        end
      end
    end
  end

  def move(dir, from, distance = 1)
    x, y = from

    if @system == :y_down
      if dir == UP
        dir = DOWN
      elsif dir == DOWN
        dir = UP
      end
    end

    case dir
    when UP
      [x, y + distance]
    when DOWN
      [x, y - distance]
    when LEFT
      [x - distance, y]
    when RIGHT
      [x + distance, y]
    end
  end

  def fill(width, height, values)
    rows = values.each_slice(width).to_a
    rows = rows.reverse if @system == :y_up
    rows.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        self[x, y] = cell
      end
    end
  end

  def bounds
    x_min, x_max = x_values.then { |xs| [xs.min, xs.max] }
    y_min, y_max = y_values.then { |ys| [ys.min, ys.max] }

    [x_min, x_max, y_min, y_max]
  end

  def to_arrays
    x_min, x_max, y_min, y_max = bounds

    y_range = (y_min..y_max).to_a
    y_range = y_range.reverse if @system == :y_up

    y_range.map do |y|
      (x_min..x_max).map do |x|
        self[x, y]
      end
    end
  end

  def visualize(&block)
    block ||= :itself.to_proc
    map { |_, x| block.call(x) }
      .tap { |new_grid| new_grid.default = block.call(@default) }
      .to_arrays
      .map { |r| r.join("") }
      .join("\n")
  end

  def bearing(from_coords, to_coords)
    angle_rads = Math.atan2(
      to_coords[1] - from_coords[1],
      to_coords[0] - from_coords[0]
    )
    angle_degs = (angle_rads / (2 * Math::PI)) * 360
    bearing_degs = (450 - angle_degs) % 360
    bearing_degs = (540 - bearing_degs) % 360 if @system == :y_down
    bearing_degs
  end

  def distance(from_coords, to_coords)
    Math.sqrt(
      ((to_coords[1] - from_coords[1]) ** 2) +
      ((to_coords[0] - from_coords[0]) ** 2)
    )
  end

  private

  def x_values
    @grid.keys.map(&:first).uniq
  end

  def y_values
    @grid.keys.map(&:last).uniq
  end
end
