require 'pry'

module ComputerAI
  def enemy_marker
    return "X" if marker == "O"
    "O"
  end

  def next_move
    return first_move.sample if first_move?
    block_them.sample
  end

  def first_move?
    which_move == 1
  end

  def first_move
    if marker == "X"
      go_anywhere
    elsif marker == "O"
      o_first_move
    end
  end

  def o_first_move
    if grid[:center] == enemy_marker
      board.corners.flatten.values_at(0, 2, 4, 6)
    elsif enemy_in_the_corner?
      [:center]
    elsif enemy_on_the_side?
      row = board.rows.select{ |row| row.flatten.include? enemy_marker }
      col = board.columns.select{ |col| col.flatten.include? enemy_marker }
      row.flatten.values_at(0, 2) + col.flatten.values_at(0, 4)
    end
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

  def second_move?
    which_move == 2
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
