require_relative 'ai_module'

class Player
  def initialize(space=nil)
    @space = space
  end

  def space
    @space ||= "X"
  end
end

class Computer < Player
include ComputerAI
  def space
    "O"
  end
end

class Human < Player
end