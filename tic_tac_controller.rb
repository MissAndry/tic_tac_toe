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
    @user_commands ||= String.new
  end

  def tic_tac_toe
    @tic_tac_toe
  end

  def start
    print GameView.clear_screen
    puts  GameView.welcome
    puts  GameView.game_options
    print GameView.prompt
  end

  def handle_starting_input(input)
    puts GameView.help if help?(input.downcase)

    if input.downcase == "y" || input.downcase == "yes"
      @tic_tac_toe = Game.new
    elsif input.downcase == "n" || input.downcase == "no"
      @tic_tac_toe = Game.new(player1: "computer", player2: "computer")
    else
      puts "\nPlease indicate whether or not you are human"
      puts  GameView.game_options
      print GameView.prompt
      input = gets.chomp
      handle_starting_input(input)
    end
  end

  def play_game(input)
    handle_starting_input(input)
    print GameView.clear_screen
    puts tic_tac_toe

    until tic_tac_toe.finished? || input == "exit" || input == "quit"
      if tic_tac_toe.player1.is_a? Human
        puts help?(input)
        puts GameView.shoot_prompt
        print GameView.prompt
        input = gets.chomp.downcase
        
        until !invalid_move?(input) || input == "exit" || input == "quit"
          puts help?(input)
          puts "\nThat move is invalid. Please try again." unless input == "help"
          puts GameView.shoot_prompt
          print GameView.prompt
          input = gets.chomp.downcase
        end
        
        tic_tac_toe.mark_space(input, tic_tac_toe.player1)
      else
        tic_tac_toe.mark_space(tic_tac_toe.player1.next_move(tic_tac_toe.board.grid), tic_tac_toe.player1)
        sleep 0.4
      end
      tic_tac_toe.mark_space(tic_tac_toe.player2.next_move(tic_tac_toe.board.grid), tic_tac_toe.player2) unless tic_tac_toe.finished?
      print GameView.clear_screen
      puts tic_tac_toe
    end
  end

  def help?(input)
    if input == "help"
      GameView.help
    end
  end

  def invalid_move?(input)
    move = tic_tac_toe.add_underscore(input).to_sym
    if tic_tac_toe.board.grid[move] != " " 
      return true
    elsif !tic_tac_toe.board.grid.keys.include? move
      return true
    else
      return false
    end
  end
end