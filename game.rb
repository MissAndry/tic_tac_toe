require_relative 'board'
require_relative 'player'

class Game
  def initialize
    @players  = players
  end

  def human
    @human ||= Human.new
  end

  def computer
    @computer ||= ComputerAI.new
  end

  def players
    @players ||= [human, computer]
  end

  def board
    @board ||= Board.new
  end

  def mark_space(where, player)
    where = add_underscore(where)
    board.grid[where.to_sym] = player.space
  end

  def add_underscore(str)
    str.gsub(" ", "_")
  end
end
