require_relative 'game'
require_relative 'game_view'
require 'pry'

class TicTacController
  def initialize
    @user_commands = user_commands
  end

  def run!
    start
    input = gets.chomp
   
    play_game(input)

    if tic_tac_toe.winner
      puts GameView.winner(tic_tac_toe.winning_player)
    elsif tic_tac_toe.finished?
      puts GameView.tie
    end
  end

  def user_commands
    @user_commands ||= Array.new
  end

  def tic_tac_toe
    @tic_tac_toe
  end

  def start
    print GameView.clear_screen
    puts GameView.welcome
    puts GameView.game_options
    print GameView.prompt
  end

  def handle_starting_input(input)
    if input == "y"
      @tic_tac_toe = Game.new
    else
      @tic_tac_toe = Game.new(player1: "computer", player2: "computer")
    end
  end

  def play_game(input)
    handle_starting_input(input)
    print GameView.clear_screen
    puts tic_tac_toe

    until tic_tac_toe.finished? || input == "exit" || input == "quit"
      if tic_tac_toe.player1.is_a? Human
        help?(input)
        puts GameView.shoot_prompt
        print GameView.prompt
        input = gets.chomp
        @user_commands << input

        tic_tac_toe.mark_space(input, tic_tac_toe.player1)
      else
        tic_tac_toe.mark_space(tic_tac_toe.player1.next_move(tic_tac_toe.board.grid), tic_tac_toe.player1)
      end
      tic_tac_toe.mark_space(tic_tac_toe.player2.next_move(tic_tac_toe.board.grid), tic_tac_toe.player2) unless help_or_quit?
      print GameView.clear_screen
      puts tic_tac_toe
    end
  end

  def help?(input)
    if input == "help"
      puts GameView.help
    end
  end

  def help_or_quit?
    user_commands.last == "help" || user_commands.last == "quit" || user_commands.last == "exit"
  end
end

game = TicTacController.new
game.run!