require_relative 'ai_module'

class Player
  def initialize(space=nil)
    @space = space
  end
end

class Computer < Player
include ComputerAI
  def space
    @space ||= "O"
  end
end

class Human < Player
  def space
    @space ||= "X"
  end
end