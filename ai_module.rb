require 'pry'

module ComputerAI
  def board_empty?(board_grid)
    board_grid.values.all? { |space| space == " " }
  end
end
