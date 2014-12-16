module ComputerAI
  def find_empty_spaces(board_grid)
    board_grid.keys.select{ |key| board_grid[key] == " " }
  end

  def first_move(board_grid)
    return [:center] if board_grid[:center] == " "
    [:top_left, :top_right, :bottom_left, :bottom_right]
  end

  def next_move(board_grid)
    
  end

  def grid_rows(grid_keys)
    rowed = []
    grid_keys.each_slice(3){ |val| rowed << val }
    rowed
  end

  def grid_cols(grid_keys)
    grid_rows(grid_keys).transpose
  end

  def grid_diag(grid_keys)
    diags = []
    diags << grid_rows(grid_keys).map.with_index { |val, i| val[i] }
    diags << grid_rows(grid_keys).map.with_index(1) { |val, i| val[-i] }
    diags
  end
end