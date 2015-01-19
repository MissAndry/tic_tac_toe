module OComputer
  def o_first_move
    if grid[:center] == enemy_marker
      board.corner_keys
    elsif enemy_in_the_corner?
      [:center]
    elsif enemy_on_the_side?
      side = board.find_side(enemy_marker)
      opposite = board.find_opposing_side(side)
      if board.col_values[1].include? enemy_marker
        neighbors = neighboring_spaces(side, "row")
      elsif board.row_values[1].include? enemy_marker
        neighbors = neighboring_spaces(side, "col")
      end
      neighbors + [opposite] + [:center]
    end
  end

  def o_second_move
    if board.side_values.count(enemy_marker) == 2 
      return x_all_in_the_corner
    elsif enemy_on_the_side? && board.corner_values.include?(enemy_marker)
      return x_on_the_side_and_corner
    elsif grid[:center] == marker
      return o_gets_the_middle
    end
    return go_anywhere
  end

  def x_all_in_the_corner
    if board.corner_values.include?(marker)
      return (board.side_keys + [:center]) - marked_spaces
    elsif board.side_values.include?(marker)
      side = board.find_opposing_side(marker)
      if side_in_row?(side)
        # binding.pry
        found_row = board.row_keys.select{ |row| row.include? side }.pop
        return [found_row.first, found_row.last]
      elsif side_in_col?(side)
        found_col = board.col_keys.select{ |col| col.include? side }.pop
        # binding.pry
        return [found_col.first, found_col.last]
      end
    end
  end

  def x_on_the_side_and_corner
    if board.side_values.include?(marker)
      side = board.find_opposing_side(marker)
      if side_in_row?(side)
        found_row = board.row_keys.select{ |row| row.include? side }.pop
        # binding.pry
        return [found_row.first, found_row.last]
      elsif side_in_col?(side)
        found_col = board.col_keys.select{ |col| col.include? side }.pop
        # binding.pry
        return [found_col.first, found_col.last]
      end
    elsif board.corner_values.include?(marker)
      corner = board.find_corner(marker)
      col_neighbor = neighboring_spaces(corner, "col")
      row_neighbor = neighboring_spaces(corner, "row")
      if grid[col_neighbor] == enemy_marker
        side = col_neighbor
      else
        side = row_neighbor
      end
      # binding.pry
      return [board.find_opposing_side(side), :center]
    end
  end

  def o_gets_the_middle
    if board.side_values.count(enemy_marker) == 2
      return go_anywhere
    else
      row_neighbor = neighboring_spaces(:center, "row")
      col_neighbor = neighboring_spaces(:center, "col")
      if row_neighbor.any?{ |key| grid[key] == enemy_marker }
        dir = col_neighbor
      else
        dir = row_neighbor
      end
      # binding.pry
      return dir
    end
  end
end