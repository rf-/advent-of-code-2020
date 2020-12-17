require './shared'

input = File.read('day17.input').strip.lines.map(&:chomp)

# Part 1

neighbors3 =
  (-1..1).flat_map do |dx|
    (-1..1).flat_map do |dy|
      (-1..1).flat_map do |dz|
        dx == 0 && dy == 0 && dz == 0 ? [] : [[dx, dy, dz]]
      end
    end
  end

step3 = -> (grid) do
  new_grid = Set.new

  xs, ys, zs = grid.to_a.then { |cs| cs[0].zip(*cs[1..]) }
  x_range = xs.min - 1 .. xs.max + 1
  y_range = ys.min - 1 .. ys.max + 1
  z_range = zs.min - 1 .. zs.max + 1
  x_range.each do |x|
    y_range.each do |y|
      z_range.each do |z|
        active = grid.include?([x, y, z])
        neighbors = neighbors3.count do |dx, dy, dz|
          grid.include?([x + dx, y + dy, z + dz])
        end

        if (
          (active && (neighbors == 2 || neighbors == 3)) ||
          (!active && neighbors == 3)
        )
          new_grid.add([x, y, z])
        end
      end
    end
  end

  new_grid
end

grid3 = Set.new
input.each_with_index do |line, y|
  line.chars.each_with_index do |cell, x|
    grid3.add([x, y, 0]) if cell == '#'
  end
end

6.times { grid3 = step3.(grid3) }
result_1 = grid3.size

puts result_1 # 269

# Part 2

neighbors4 =
  (-1..1).flat_map do |dx|
    (-1..1).flat_map do |dy|
      (-1..1).flat_map do |dz|
        (-1..1).flat_map do |dw|
          dx == 0 && dy == 0 && dz == 0 && dw == 0 ? [] : [[dx, dy, dz, dw]]
        end
      end
    end
  end

step4 = -> (grid) do
  new_grid = Set.new

  xs, ys, zs, ws = grid.to_a.then { |cs| cs[0].zip(*cs[1..]) }
  x_range = xs.min - 1 .. xs.max + 1
  y_range = ys.min - 1 .. ys.max + 1
  z_range = zs.min - 1 .. zs.max + 1
  w_range = ws.min - 1 .. ws.max + 1
  x_range.each do |x|
    y_range.each do |y|
      z_range.each do |z|
        w_range.each do |w|
          active = grid.include?([x, y, z, w])
          neighbors = neighbors4.count do |dx, dy, dz, dw|
            grid.include?([x + dx, y + dy, z + dz, w + dw])
          end

          if (
            (active && (neighbors == 2 || neighbors == 3)) ||
            (!active && neighbors == 3)
          )
            new_grid.add([x, y, z, w])
          end
        end
      end
    end
  end

  new_grid
end

grid4 = Set.new
input.each_with_index do |line, y|
  line.chars.each_with_index do |cell, x|
    grid4.add([x, y, 0, 0]) if cell == '#'
  end
end

6.times { grid4 = step4.(grid4) }
result_2 = grid4.size

puts result_2 # 1380
