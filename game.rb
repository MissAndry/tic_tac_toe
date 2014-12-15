require_relative 'board'
require_relative 'player'

class Game





  def mark_space(where)
    where = add_underscore(where)
    board.grid[where.to_sym] = "X"
  end

  def add_underscore(str)
    str.gsub(" ", "_")
  end
end