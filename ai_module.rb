require 'pry'

module ComputerAI
  def enemy_marker
    return "X" if marker == "O"
    "O"
  end

  def next_move
    return tryna_win.sample if tryna_win?
    return block_them.sample if defense_necessary?
    return first_move.sample if first_move?
    return second_move.sample if second_move?
    return go_anywhere.sample
  end

  def first_move?
    which_move == 1
  end

  def tryna_win?
    all_value_combos = board.row_values + board.col_values + board.diag_values
    all_value_combos.any? { |combo| combo.sort == [" ", marker, marker] }
  end

  def defense_necessary?
    all_value_combos = board.row_values + board.col_values + board.diag_values
    all_value_combos.any? { |combo| combo.sort == [" ", enemy_marker, enemy_marker] }
  end

  def first_move
    if marker == "X"
      go_anywhere
    elsif marker == "O"
      o_first_move
    end
  end

  def second_move
    if marker == "X"
      # binding.pry
      x_second_move
    elsif marker =="O"
      # binding.pry
      # o_second_move
      go_anywhere
    end
  end

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
        # binding.pry
      elsif board.row_values[1].include? enemy_marker
        neighbors = neighboring_spaces(side, "col")
        # binding.pry
      end
      neighbors + [opposite] + [:center]
    end
  end

  def x_second_move
    if grid[:center] == marker
      if board.sides.flatten.include? enemy_marker
        return go_anywhere - [board.find_opposing_side(enemy_marker)]
      end
    elsif board.corner_values.include? marker
      if board.sides.flatten.include? enemy_marker
        return (board.corner_keys - marked_spaces - column_including(enemy_marker)) + [:center]
      elsif board.corner_values.flatten.include? enemy_marker
        return board.corner_keys - marked_spaces
      end
    else
      if grid[:center] == enemy_marker || board.corner_values.include?(enemy_marker)
        return go_anywhere - [board.find_opposing_side(marker)]
      end
    end
    go_anywhere
  end

  def tryna_win
    all_combinations = board.diagonals + board.rows + board.columns
    potential_winner = all_combinations.select{ |combo| combo.flatten.values_at(1, 3, 5).sort == [" ", marker, marker] }.pop
    potential_winner.map{ |move| move.first if move.last == " " }.compact
  end

  def enemy_in_the_corner?
    board.corners.flatten.include? enemy_marker
  end

  def enemy_on_the_side?
    board.sides.flatten.include? enemy_marker
  end

  def block_them
    all_combinations = board.diagonals + board.rows + board.columns
    potential_moves = all_combinations.select { |combo| combo.flatten.values_at(1, 3, 5).sort == [" ", enemy_marker, enemy_marker] }.pop
    potential_moves.map{ |move| move.first if move.last == " " }.compact
  end

  def neighboring_spaces(space, direction)
    case direction
    when "row"
      dir = board.row_keys
    when "col"
      dir = board.col_keys
    end

    neighbor = []
    dir.each do |segment|
      segment.each_with_index do |val, index|
        neighbor << segment[index - 1] if val == space && index > 0
        neighbor << segment[index + 1] if val == space && index < segment.length
      end
    end
    neighbor.compact
  end

  def second_move?
    which_move == 2
  end

  def column_including(marking=marker)
    column = board.columns.select{ |col| col.flatten.include? marker }
    column.flatten.values_at(0, 2, 4)
  end

  def which_move
    grid_values.count(marker) + 1
  end

  def marked_spaces
    grid_keys.select{ |key| grid[key] != " " }
  end

  def go_anywhere
    grid_keys - marked_spaces
  end
end
