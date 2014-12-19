require_relative 'game'
require_relative 'game_view'

class TicTacToe
  def initialize
    @board   = board
    # @players = players
    @player1 = player1
    @player2 = player2
  end

  def board
    @board = Board.new
  end

  def players
    @players ||= add_players
  end

  def player1
    @player1 ||= players.first
  end

  def player2
    @player2 ||= players.last
  end

  def add_players(player_1="human", player_2="computer")
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
end