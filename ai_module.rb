module ComputerAI
  def find_empty_spaces(board_grid)
    board_grid.select{ |key| board_grid[key] == " " }
  end

  def first_move(board_grid)
    return [:center] if board_grid[:center] == " "
    [:top_left, :top_right, :bottom_left, :bottom_right]
  end

  def next_move(board_grid)
    # picked = nil
    # possible_moves = find_empty_spaces(board_grid)
    all_combinations = grid_rows(board_grid) + grid_cols(board_grid) + grid_diag(board_grid)
    all_combinations.each do |combo|
      if combo.flatten.values_at(1, 3, 5).sort == [" ", self.space, self.space] || combo.flatten.values_at(1, 3, 5).sort == [" ", "X", "X"]
        combo.select{ |pair| return pair[0] if pair[1] == " "}
      end
    end
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
