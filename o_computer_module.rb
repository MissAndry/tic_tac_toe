module OComputer
  def o_first_move
    if grid[:center] == enemy_marker
      board.corner_keys
    elsif enemy_in_the_corner?
      [:center]
    elsif enemy_on_the_side?
      side = board.find_sides(enemy_marker).pop
      opposite = board.find_opposing_side(enemy_marker)
      if board.col_values[1].include? enemy_marker
        neighbors = neighboring_spaces(side, "row")
      elsif board.row_values[1].include? enemy_marker
        neighbors = neighboring_spaces(side, "col")
      end
      neighbors + [opposite] + [:center]
    end
  end

  def o_second_move
    if grid[:center] == marker
      return o_gets_the_middle
    elsif grid[:center] == enemy_marker && board.corner_values.include?(enemy_marker)
      return board.corner_keys - marked_spaces
    elsif board.side_values.count(enemy_marker) == 2 
      return x_all_up_the_sides
    elsif enemy_on_the_side? && enemy_in_the_corner?
      return x_on_the_side_and_corner
    end
    return go_anywhere
  end

  def o_third_move
    if grid[:center] == marker && board.side_values.include?(marker)
      if board.side_values.count(enemy_marker) == 2
        neighbors = []
        board.find_sides(enemy_marker).each do |side|
          neighbors << neighboring_spaces(side, "row")
          neighbors << neighboring_spaces(side, "col")
        end
        neighbors.select!{ |combo| combo.length == 2 }

        neighbors.select do |combo| 
          # binding.pry
          return combo if combo.all? { |value| 
            # binding.pry
            !surrounding_values(value).flatten.include?(marker) 
          }
        end
      end
    end
    [:center]
  end

  def x_all_up_the_sides
    if board.corner_values.include?(marker)
      # binding.pry
      return (board.side_keys + [:center]) - marked_spaces
    elsif board.side_values.include?(marker)
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
      corner = board.find_corner(marker).pop
      surr_vals = surrounding_values(corner)
      surr_keys = surrounding_keys(corner)

      if surr_vals.any?{ |vals| all_in_a_row?(vals) }
        moves = surr_keys.select.with_index{ |combo, index| combo if !surr_vals[index].include?(enemy_marker) }.pop
        return moves - marked_spaces
      end

      col_neighbor = neighboring_spaces(corner, "col").pop
      row_neighbor = neighboring_spaces(corner, "row").pop
      # binding.pry
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
      sides = board.find_sides(enemy_marker)
      row_neighbor = []
      col_neighbor = []
      sides.each do |side|
        row_neighbor << neighboring_spaces(side, "row")
        col_neighbor << neighboring_spaces(side, "col")
      end
      moves = []
      moves << row_neighbor.select{ |row| row.length == 2 }.flatten
      moves << col_neighbor.select{ |col| col.length == 2 }.flatten
      return moves.flatten.compact.uniq
    else
      dir = board.side_keys
      row_neighbor = neighboring_spaces(:center, "row")
      col_neighbor = neighboring_spaces(:center, "col")
      if row_neighbor.any?{ |key| grid[key] == enemy_marker }
        dir -= row_neighbor
        row_neighbor.each { |key| dir += neighboring_spaces(key, "col") if grid[key] == enemy_marker }
      end
      if col_neighbor.any?{ |key| grid[key] == enemy_marker }
        dir -= col_neighbor
        col_neighbor.each { |key| dir += neighboring_spaces(key, "row") if grid[key] == enemy_marker }
      end
      return dir
    end
  end
end