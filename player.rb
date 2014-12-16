require_relative 'ai_module'

class Player
end

class Computer < Player
include ComputerAI
  def space
    "O"
  end
end

class Human < Player
  def space
    "X"
  end
end