module OComputer
  def o_first_move
    if grid[:center] == enemy_marker
      board.corner_keys
    elsif enemy_in_the_corner?
      [:center]
    elsif enemy_on_the_side?
      side = board.find_sides(enemy_marker)
      opposite = board.find_opposing_side(enemy_marker)
      if board.col_values[1].include? enemy_marker
        neighbors = board.find_row_neighbors(side).pop
      elsif board.row_values[1].include? enemy_marker
        neighbors = board.find_col_neighbors(side).pop
      end
      neighbors + [opposite] + [:center]
    end
  end

  def o_second_move
    if grid[:center] == marker
      return o_gets_the_middle
    elsif grid[:center] == enemy_marker
      return board.corner_keys - marked_spaces
    elsif board.side_values.count(enemy_marker) == 2 
      return x_all_up_the_sides
    elsif enemy_on_the_side? && enemy_in_the_corner?
      return x_on_the_side_and_corner
    end
    return go_anywhere
  end

  def o_third_move
    return [:center] if grid[:center] == " "
    if grid[:center] == marker && board.side_values.include?(marker)
      if board.side_values.include?(enemy_marker)
        sides = board.find_sides(enemy_marker)
        neighbors = board.find_row_neighbors(sides) + board.find_col_neighbors(sides)
        neighbors.select!{ |combo| combo.length == 2 }
        neighbors.select do |combo|
          return combo if combo.all? { |value| !board.surrounding_values(value).flatten.include?(marker) }
        end
      end
    end
    go_anywhere
  end

  def x_all_up_the_sides
    if board.corner_values.include?(marker)
      return o_corners_on_x(marker)
    elsif board.side_values.include?(marker)
      side = board.find_opposing_side(marker)
      if board.side_in_row?(side)
        found_row = board.row_keys.select{ |row| row.include? side }.pop
        return [found_row.first, found_row.last]
      elsif board.side_in_col?(side)
        found_col = board.col_keys.select{ |col| col.include? side }.pop
        return [found_col.first, found_col.last]
      end
    end
  end

  def x_on_the_side_and_corner
    if board.side_values.include?(marker)
      side = board.find_opposing_side(marker)
      if board.side_in_row?(side)
        found_row = board.row_keys.select{ |row| row.include? side }.pop
        return [found_row.first, found_row.last, :center]
      elsif board.side_in_col?(side)
        found_col = board.col_keys.select{ |col| col.include? side }.pop
        return [found_col.first, found_col.last, :center]
      end

    elsif board.corner_values.include?(marker)
      corner = board.find_corner(marker).pop
      surr_vals = board.surrounding_values(corner)
      surr_keys = board.surrounding_keys(corner)

      if surr_vals.any?{ |vals| all_in_a_row?(vals) }
        moves = surr_keys.select.with_index{ |combo, index| combo if !surr_vals[index].include?(enemy_marker) }.pop
        moves << :center
        return moves - marked_spaces
      end

      col_neighbor = board.col_neighbor(corner).pop
      row_neighbor = board.row_neighbor(corner).pop
      if grid[col_neighbor] == enemy_marker
        side = col_neighbor
      else
        side = row_neighbor
      end
      return [board.find_opposing_side(side), :center]
    end
  end

  def o_gets_the_middle
    if board.side_values.count(enemy_marker) == 2
      sides = board.find_sides(enemy_marker)
      row_neighbor = board.find_row_neighbors(sides)
      col_neighbor = board.find_col_neighbors(sides)

      moves = []
      moves << row_neighbor.select{ |row| row.length == 2 }.flatten
      moves << col_neighbor.select{ |col| col.length == 2 }.flatten
      return moves.flatten.compact.uniq
    else
      dir = board.side_keys
      row_neighbor = board.row_neighbor(:center)
      col_neighbor = board.col_neighbor(:center)
      
      if row_neighbor.any?{ |key| grid[key] == enemy_marker }
        dir -= row_neighbor
        row_neighbor.each { |key| dir += board.col_neighbor(key) if grid[key] == enemy_marker }
      end

      if col_neighbor.any?{ |key| grid[key] == enemy_marker }
        dir -= col_neighbor
        col_neighbor.each { |key| dir += board.row_neighbor(key) if grid[key] == enemy_marker }
      end
      
      return dir
    end
  end

  def o_corners_on_x(corner)
    corner = board.find_corner(marker).pop
    if board.surrounding_values(corner).flatten.count(enemy_marker) == 1
      return o_corner_u_so_pretty(corner)
    else
      return (board.side_keys + [:center]) - marked_spaces
    end
  end

  def o_corner_u_so_pretty(corner)
    row = board.row_keys.select{ |keys| keys.include? corner }.pop
    col = board.col_keys.select{ |keys| keys.include? corner }.pop

    marked = board.find_sides(enemy_marker)
    move = row unless marked.any?{ |key| row.include? key }
    move = col unless marked.any?{ |key| col.include? key }
    return [move.first] if move.last == corner
    return [move.last] if move.first == corner
  end
end