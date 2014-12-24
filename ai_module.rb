require 'pry'

module ComputerAI
  def enemy_marker
    return "X" if self.space == "O"
    return "O" if self.space == "X"
  end

  def empty?(board_grid)
    board_grid.values.all? { |space| space == " " }
  end

  def taken_spaces(board_grid)
    board_grid.keys.select{ |key| board_grid[key] != " "}
  end

  def corner_spaces(board_grid)
    diagonals = grid_diag(board_grid.values)
    corners = diagonals.map{ |row| [row.first, row.last] }
    corners.flatten
  end

  def first_move(board_grid)
    if corner_spaces(board_grid).include? enemy_marker
      return [find_opposing_diagonal(board_grid).first]
    elsif board_grid[:center] != " "
      [:top_left, :top_right, :bottom_left, :bottom_right] - taken_spaces(board_grid)
    else
      [:top_left, :top_right, :center, :bottom_left, :bottom_right] - taken_spaces(board_grid)
    end
  end

  def later_moves(board_grid)
    all_combinations = all_rows_columns_diagonal_combos(board_grid)
    opposing_diag = find_opposing_diagonal(board_grid)
    potential_moves = get_next_moves(all_combinations)
    potential_moves << (opposing_diag) if !opposing_diag.nil?
    potential_moves.each { |move| return move if move.class == Symbol }
  end

  def next_move(board_grid)
    maybe_first = first_move(board_grid).sample
    return maybe_first if board_grid.values.count(enemy_marker) <= 1 && board_grid.values.count(self.space) <= 0
    later_moves(board_grid)
  end

  def find_opposing_diagonal(board_grid)
    diagonals = grid_diag(board_grid)
    marked_row = diagonals.select{ |diag| diag.flatten.include?(enemy_marker) }.pop
    return if marked_row.nil?
    return marked_row.last if marked_row.last.include?(" ")
    marked_row.first
  end

  def defend(all_combinations, marker=self.space, blank_space=nil)
    blank_space = marker if blank_space.nil? 
    all_combinations.each do |combo|
      if combo.flatten.values_at(1, 3, 5).sort == [" ", blank_space, marker]
        combo.select{ |pair| return pair[0] if pair[1] == " " }
      end
    end
  end

  def get_next_moves(all_combinations)
    moves = []
    moves << defend(all_combinations)
    moves << defend(all_combinations, enemy_marker)
    moves << defend(all_combinations, enemy_marker, " ")
    moves << defend(all_combinations, enemy_marker, self.space)
    moves
  end

  def all_rows_columns_diagonal_combos(board_grid)
    grid_rows(board_grid) + grid_cols(board_grid) + grid_diag(board_grid)
  end

  def grid_rows(board_grid)
    board_grid.each_slice(3).to_a
  end

  def grid_cols(board_grid)
    grid_rows(board_grid).transpose
  end

  def grid_diag(board_grid)
    diags = []
    diags << grid_rows(board_grid).map.with_index { |val, i| val[i] }
    diags << grid_rows(board_grid).map.with_index(1) { |val, i| val[-i] }
    diags
  end
end
