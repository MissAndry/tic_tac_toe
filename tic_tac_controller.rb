require_relative 'game'
require_relative 'game_view'
require 'pry'

class TicTacController
  AFFIRMATIVE = ["y", "yes", "yeah", "yep"]
  NEGATIVE = ["n", "no", "nope", "nah"]
  QUITTER = ["exit", "quit"]

  def tic_tac_toe
    @tic_tac_toe ||= Game.new
  end

  def run!
    start
    input = gets.chomp.downcase
   
    play_game(input)
    return if quit?(input)
    if tic_tac_toe && tic_tac_toe.winner
      puts GameView.winner(tic_tac_toe.winning_player)
    elsif tic_tac_toe && tic_tac_toe.finished?
      puts GameView.tie
    end
  end

  def start
    print GameView.clear_screen
    puts  GameView.welcome
    puts  GameView.game_options
    print GameView.prompt
  end

  def handle_starting_input(input)
    return if quit?(input)
    if AFFIRMATIVE.include? input
      @tic_tac_toe = Game.new
    elsif NEGATIVE.include? input
      @tic_tac_toe = Game.new(player1: "computer", player2: "computer")
    elsif input == "help"
      puts help?(input)
      puts  GameView.game_options
      print GameView.prompt
      input = gets.chomp.downcase
      handle_starting_input(input)
    else
      puts "\nPlease indicate whether or not you are human"
      puts  GameView.game_options
      print GameView.prompt
      input = gets.chomp.downcase
      handle_starting_input(input)
    end
  end

  def play_game(input)
    return if quit?(input)
    handle_starting_input(input)
    print GameView.clear_screen
    puts tic_tac_toe

    until tic_tac_toe.finished?
      return if quit?(input)
      if tic_tac_toe.player1.is_a? Human
        human_move(input)
      else
        computer_player1_move
      end

      computer_player2_move
      print GameView.clear_screen
      puts tic_tac_toe
    end
  end

  def help?(input)
    GameView.help if input == "help"
  end

  def quit?(input)
    QUITTER.include? input
  end

  def human_move(input)
    puts help?(input)
    puts GameView.shoot_prompt
    print GameView.prompt
    input = gets.chomp.downcase
    
    until !invalid_move?(input)
      return if quit?(input)
      puts help?(input)
      puts "\nThat move is invalid. Please try again." unless input == "help"
      puts GameView.shoot_prompt
      print GameView.prompt
      input = gets.chomp.downcase
    end
    
    tic_tac_toe.mark_space(input, tic_tac_toe.player1)
  end

  def computer_player2_move
    tic_tac_toe.mark_space(tic_tac_toe.player2.next_move(tic_tac_toe.board.grid), tic_tac_toe.player2) unless tic_tac_toe.finished?
  end

  def computer_player1_move
    tic_tac_toe.mark_space(tic_tac_toe.player1.next_move(tic_tac_toe.board.grid), tic_tac_toe.player1)
    sleep 0.4
  end

  def invalid_move?(input)
    move = tic_tac_toe.add_underscore(input).to_sym
    tic_tac_toe.board.grid[move] != " " || !tic_tac_toe.board.grid.keys.include?(move)
  end
end