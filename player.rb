require_relative 'ai_module'

class Player
  def initialize(marker=nil)
    @marker = marker
  end
end

class Computer < Player
include ComputerAI
  def marker
    @marker ||= "O"
  end
end

class Human < Player
  def marker
    @marker ||= "X"
  end
end