class Player
  attr_reader :space
  def initialize(space="O")
    @space = space
  end
end

class ComputerAI < Player
end