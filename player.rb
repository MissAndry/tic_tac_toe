class Player
  attr_reader :space
  def initialize(space="X")
    @space = space
  end
end

class ComputerAI < Player
  def space
    "O"
  end
end

class Human < Player
end