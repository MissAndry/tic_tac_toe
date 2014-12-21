require_relative 'board'
require_relative 'player'

class Game
  def initialize(options={})
    @player1      = options.fetch(:player1){ "human" }
    @player2      = options.fetch(:player2){ "computer" }
    @players      = players
    @board        = board
  end

  def human
    @human ||= players.select{ |player| player.is_a? Human }.pop
  end

  def computer
    @computer ||= players.select{ |player| player.is_a? Computer }.pop
  end

  def board
    @board ||= Board.new
  end

  def players
    @players ||= add_players(@player1, @player2)
  end

  def player1
    @players.first
  end

  def player2
    @players.last
  end

  def add_players(player_1, player_2)
    people = []
    case player_1
    when "human"
      people << Human.new("X")
    when "computer"
      people << Computer.new("X")
    end

    case player_2
    when "human"
      people << Human.new("O")
    when "computer"
      people << Computer.new("O")
    end
    people
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
    nil
  end

  def to_s
    @board.to_s
  end
end
