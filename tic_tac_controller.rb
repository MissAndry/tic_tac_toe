require_relative 'game'
require_relative 'game_view'
require 'pry'

class TicTacController
  def start
    puts GameView.welcome
    puts GameView.game_options
    print GameView.prompt
  end

  def tic_tac_toe
    @tic_tac_toe
  end

  def run!
    start
    input = gets.chomp
    handle_starting_input(input)
    puts tic_tac_toe
    puts
   
    until tic_tac_toe.finished? || input == "exit" || input == "quit"
      if tic_tac_toe.players.any? { |player| player.is_a? Human }
        unless help?(input)
          puts GameView.shoot_prompt
          print GameView.prompt
          input = gets.chomp
        end
        tic_tac_toe.mark_space(input, tic_tac_toe.player1)
      else
        tic_tac_toe.mark_space(tic_tac_toe.player1.next_move(tic_tac_toe.board.grid), tic_tac_toe.player1)
      end
      tic_tac_toe.mark_space(tic_tac_toe.player2.next_move(tic_tac_toe.board.grid), tic_tac_toe.player2)
      puts tic_tac_toe
      puts
    end
  end

  def handle_starting_input(input)
    help?(input)
    if input.to_i == 1
      @tic_tac_toe = Game.new
    elsif input.to_i == 2
      @tic_tac_toe = Game.new(player1: "human", player2: "human")
    else
      @tic_tac_toe = Game.new(player1: "computer", player2: "computer")
    end
  end

  def help?(input)
    if input == "help"
      puts GameView.help
      print GameView.prompt
      input = gets.chomp
    end
  end
end

game = TicTacController.new
game.run!