class Player
end

class Computer < Player
  def space
    "O"
  end
end

class Human < Player
  def space
    "X"
  end
end