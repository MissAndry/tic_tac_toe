require 'pry'

module ComputerAI
  def find_empty_spaces(board_grid)
    board_grid.select{ |key| board_grid[key] == " " }
  end

  def taken_spaces(board_grid)
    board_grid.select{ |key| board_grid[key] != " "}
  end

  def first_move(board_grid)
    return [:center] if (board_grid[:center] == " " && board_grid.values.include?("X"))
    [:top_left, :top_right, :bottom_left, :bottom_right] - taken_spaces(board_grid)
  end

  def next_move(board_grid)
    all_combinations = all_rows_columns_diagonal_combos(board_grid)
    opposing_diag = find_opposing_diagonal(board_grid)
    
    potential_moves = get_next_moves(all_combinations)
    potential_moves.unshift(opposing_diag) if !opposing_diag.nil?
    maybe_first = first_move(board_grid).sample

    return maybe_first if board_grid.values.count("X") <= 1
    potential_moves.each { |move| return move if move.class == Symbol }
  end

  def find_opposing_diagonal(board_grid)
    diagonals = grid_diag(board_grid)
    marked_row = diagonals.select{ |diag| diag.flatten.include?("X") }.pop
    return if marked_row.nil?
    return marked_row.last if marked_row.last.include?(" ")
    marked_row.first
  end

  def defend(all_combinations, marker=space, blank_space=nil)
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
    moves << defend(all_combinations, "X")
    moves << defend(all_combinations, "X", " ")
    moves
  end

  def all_rows_columns_diagonal_combos(board_grid)
    grid_rows(board_grid) + grid_cols(board_grid) + grid_diag(board_grid)
  end

  def grid_rows(grid_keys_or_vals)
    grid_keys_or_vals.each_slice(3).to_a
  end

  def grid_cols(grid_keys_or_vals)
    grid_rows(grid_keys_or_vals).transpose
  end

  def grid_diag(grid_keys_or_vals)
    diags = []
    diags << grid_rows(grid_keys_or_vals).map.with_index { |val, i| val[i] }
    diags << grid_rows(grid_keys_or_vals).map.with_index(1) { |val, i| val[-i] }
    diags
  end
end
