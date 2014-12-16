module ComputerAI
  def find_empty_spaces(board_grid)
    board_grid.keys.select{ |key| board_grid[key] == " " }
  end

  def first_move(board_grid)
    return [:center] if board_grid[:center] == " "
    [:top_left, :top_right, :bottom_left, :bottom_right]
  end
end