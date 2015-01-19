require_relative 'x_computer_module'
require_relative 'o_computer_module'
require 'pry'

module ComputerAI
  include XComputer
  include OComputer


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
      x_second_move
    elsif marker =="O"
      o_second_move
    end
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
    board.side_values.include? enemy_marker
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

  def side_in_col?(side)
    side.match(/middle/)
  end

  def side_in_row?(side)
    side.match(/center/)
  end
end
