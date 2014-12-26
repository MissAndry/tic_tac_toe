class GameView
  def initialize(game)
    @game = game
  end

  def self.welcome
<<-welcome
              You're playing Tic-Tac-Toe

welcome
#Please declare if you are a human or a computer
  end

  def self.prompt
    "::> "
  end

  def self.game_options
    "One player or two?"
  end

  def self.shoot_prompt
    "Where would you like to move? (Type \"help\" for options)"
  end

  def self.help
<<-HELP

MARKER OPTIONS
top center:   Mark the top center corner
top left:     Mark the top left corner
center:       Mark the center of the board
middle right: Mark the middle right space on the board

You get it. The full list of marker options is:
top left,    top center,    top right,
middle left, center,        middle right,
bottom left, bottom center, bottom right

OTHER OPTIONS
help:         Display this screen
quit:         Quit the game

HELP
  end

  def self.render
    @game.to_s
  end

  def self.winner(winner)
    "#{winner} wins!"
  end

  def self.tie
    "Cat game!"
  end
end
