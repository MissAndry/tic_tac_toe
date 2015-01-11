require_relative 'game'
require_relative 'game_view'

class TicTacController
  AFFIRMATIVE = ["y", "yes", "yeah", "yep"]
  NEGATIVE = ["n", "no", "nope", "nah"]
  QUITTER = ["exit", "quit"]

  def initialize
    @user_input  = user_input
    @tic_tac_toe = tic_tac_toe
  end

  def tic_tac_toe
    @tic_tac_toe ||= Game.new
  end

  def user_input
    @user_input ||= String.new
  end

  def run!
    start
    @user_input = gets.chomp.downcase
   
    return if quit?
    play_game
    if tic_tac_toe && tic_tac_toe.winner
      puts GameView.winner(tic_tac_toe.winning_player)
    elsif tic_tac_toe && tic_tac_toe.finished?
      puts GameView.tie
    end
  end

  def start
    print GameView.clear_screen
    puts  GameView.welcome
    starting_prompt
  end

  def handle_starting_input
    return if quit?
    if user_input == "help"
      puts help?
      starting_prompt
      @user_input = gets.chomp.downcase
      handle_starting_input
    elsif AFFIRMATIVE.include? user_input
      tic_tac_toe
    elsif NEGATIVE.include? user_input
      @tic_tac_toe = Game.new(player1: "computer", player2: "computer")
    else
      puts GameView.human_indicator
      starting_prompt
      @user_input = gets.chomp.downcase
      handle_starting_input
    end
  end

  def play_game
    handle_starting_input
    print GameView.clear_screen
    puts tic_tac_toe
    
    until tic_tac_toe.finished? || quit?

      if tic_tac_toe.player1.is_a? Human
        human_move
      else
        computer_player1_move
      end

      computer_player2_move
      print GameView.clear_screen
      puts tic_tac_toe
    end
  end

  def prompt_next_move
    puts  GameView.shoot_prompt
    print GameView.prompt
  end

  def starting_prompt
    puts  GameView.game_options
    print GameView.prompt
  end

  def help?
    puts GameView.help(started?) if user_input == "help"
  end

  def help
    puts GameView.help(started?)
  end

  def started?
    tic_tac_toe.board.grid.values.all? { |space| space != " " }
  end

  def quit?
    QUITTER.include? user_input
  end

  def human_move
    puts help?
    prompt_next_move
    @user_input = gets.chomp.downcase
    
    until !invalid_move?
      return if quit?
      puts help?
      puts GameView.invalid_move unless user_input == "help"
      prompt_next_move
      @user_input = gets.chomp.downcase
    end
    
    tic_tac_toe.mark_space(user_input, tic_tac_toe.player1)
  end

  def computer_player2_move
    tic_tac_toe.mark_space(tic_tac_toe.player2.next_move(tic_tac_toe.board.grid), tic_tac_toe.player2) unless tic_tac_toe.finished? || quit?
  end

  def computer_player1_move
    tic_tac_toe.mark_space(tic_tac_toe.player1.next_move(tic_tac_toe.board.grid), tic_tac_toe.player1)
    sleep 0.4
  end

  def invalid_move?
    move = tic_tac_toe.add_underscore(user_input).to_sym
    tic_tac_toe.board.grid[move] != " " || !tic_tac_toe.board.grid.keys.include?(move)
  end
end