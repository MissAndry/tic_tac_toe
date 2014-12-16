module ComputerAI
  def find_empty_spaces(board_grid)
    board_grid.keys.select{ |key| board_grid[key] == " " }
  end
end