require_relative 'ai_module'

class Player
  def initialize(marker=nil)
    @marker = marker
  end
end

class Computer < Player
  include ComputerAI
  attr_reader :board

  def initialize(board, marker=nil)
    @marker = marker
    @board = board
  end

  def marker
    @marker ||= "O"
  end

  def grid
    @board.grid
  end

  def grid_values
    grid.values
  end

  def grid_keys
    grid.keys
  end

  private

  def board=(new_board)
    @board.send(:grid=, new_board)
  end
end

class Human < Player
  def marker
    @marker ||= "X"
  end
end