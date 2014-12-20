require_relative 'game'
require_relative 'game_view'

class TicTacToe
  def initialize(options={})
    @player1 = options.fetch(:player1){ "human" }
    @player2 = options.fetch(:player2){ "computer" }
    @players = players
    @game    = game
  end

  def player1
    players.first
  end

  def player2
    players.last
  end

  def players
    @players ||= add_players(@player1, @player2)
  end

  def game
    @game ||= Game.new
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

  def to_s
    game.to_s
  end
end