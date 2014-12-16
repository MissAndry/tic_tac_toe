require_relative 'board'
require_relative 'player'

class Game
  def initialize
    @human    = human
    @computer = computer
    @board    = board
  end

  def human
    @human ||= Human.new
  end

  def computer
    @computer ||= Computer.new
  end

  def board
    @board ||= Board.new
  end

  def players
    @players ||= [human, computer]
  end

  def finished?
    board.rows.flatten.all? { |x| x != " " } || winner != nil
  end

  def mark_space(where, player)
    where = add_underscore(where).to_sym if where.class == String
    board.grid[where] = player.space unless board.grid[where] != " "
  end

  def add_underscore(str)
    str.gsub(" ", "_")
  end

  def winner
    players.each do |player|
      return player if board.rows.any? { |row| row.all? { |space| space == player.space } }
      return player if board.columns.any? { |column| column.all? { |space| space == player.space } }
      return player if board.diagonals.any? { |diagonal| diagonal.all? { |space| space == player.space } }
    end
  end
end
