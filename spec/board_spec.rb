require_relative '../board'

describe 'Board' do
  let(:board){ Board.new }
  it 'has nine spaces' do
    expect(board.grid.length).to be 9
  end

  describe '#rows' do
    it 'returns an array of all the rows' do
      expect(board.rows).to eq([[[:top_left, " "], [:top_center, " "], [:top_right, " "]],
       [[:middle_left, " "], [:center, " "], [:middle_right, " "]],
       [[:bottom_left, " "], [:bottom_center, " "], [:bottom_right, " "]]])
    end
  end

  describe '#columns' do
    it 'returns an array of all the columns' do
      expect(board.columns).to eq(board.rows.transpose)
    end
  end

  describe '#diagonals' do
    it 'returns an array of both diagonals' do
      expect(board.diagonals).to eq([[board.rows[0][0], board.rows[1][1], board.rows[2][2]], [board.rows[0][2], board.rows[1][1], board.rows[2][0]]])
    end
  end

  describe '#sides' do
    it 'returns the key, value pairs of the side of the board' do
      expect(board.sides).to eq([[:top_center, " "], [:bottom_center, " "], [:middle_left, " "], [:middle_right, " "]])
    end
  end

  describe '#corners' do
    it 'returns the key, value pairs of the corners of the board' do
      expect(board.corners).to eq([[:top_left, " "], [:top_right, " "], [:bottom_left, " "], [:bottom_right, " "]])
    end
  end

  describe '#row_keys' do
    it 'returns the keys of the rows' do
      expect(board.row_keys).to eq([[:top_left, :top_center, :top_right], [:middle_left, :center, :middle_right], [:bottom_left, :bottom_center, :bottom_right]])
    end
  end

  describe '#col_keys' do
    it 'returns the keys of the columns' do
      expect(board.col_keys).to eq([[:top_left, :middle_left, :bottom_left], [:top_center, :center, :bottom_center], [:top_right, :middle_right, :bottom_right]])
    end
  end

  describe '#diag_keys' do
    it 'returns the keys of the diagonals' do
      expect(board.diag_keys).to eq([[:top_left, :center, :bottom_right], [:top_right, :center, :bottom_left]])
    end
  end

  describe '#side_keys' do
    it 'returns the keys of the sides' do
      expect(board.side_keys).to eq([:top_center, :bottom_center, :middle_left, :middle_right])
    end
  end

  describe '#corner_keys' do
    it 'returns the keys of the corners' do
      expect(board.corner_keys).to eq([:top_left, :top_right, :bottom_left, :bottom_right])
    end
  end

  describe '#find_side' do
    it 'finds the side spaces occupied by the given marker' do
      board.grid[:middle_right] = "X"
      board.grid[:top_left] = "X"
      expect(board.find_sides("X")).to eq([:middle_right])

      board.grid[:top_center] = "X"
      expect(board.find_sides("X")).to eq([:top_center, :middle_right])
      
      board.grid[:middle_right] = " "
      board.grid[:top_center] = "O"
      expect(board.find_sides("O")).to eq([:top_center])
    end
  end

  describe '#find_opposing_side' do
    it 'finds the side space opposite the space occupied by the given marker' do
      board.grid[:middle_right] = "X"
      expect(board.find_opposing_side("X")).to eq(:middle_left)

      board.grid[:top_center] = "O"
      expect(board.find_opposing_side("O")).to eq(:bottom_center)
    end
  end

  describe '#find_corner' do
    it 'finds the corner spaces occupied by the given marker' do
      board.grid[:top_left] = "X"
      board.grid[:middle_right] = "X"
      expect(board.find_corner("X")).to eq([:top_left])

      board.grid[:bottom_left] = "X"
      expect(board.find_corner("X")).to eq([:top_left, :bottom_left])
    end
  end

  describe '#empty?' do
    it 'returns true if the board is empty' do
      expect(board.empty?).to be true
    end

    it 'returns false if the board is not empty' do
      board.grid[:center] = "X"
      expect(board.empty?).to be false
    end
  end

  describe '#neighboring_keys' do
    it 'finds the one to two spaces next to a given space in a row' do
      expect(board.neighboring_keys(:center, "row")).to eq([:middle_left, :middle_right])
      expect(board.neighboring_keys(:top_center, "row")).to eq([:top_left, :top_right])
      expect(board.neighboring_keys(:bottom_center, "row")).to eq([:bottom_left, :bottom_right])
      expect(board.neighboring_keys(:bottom_left, "row")).to eq([:bottom_center])
      expect(board.neighboring_keys(:top_right, "row")).to eq([:top_center])
    end

    it 'finds the one to two spaces next to a given space in a column' do
      expect(board.neighboring_keys(:center, "col")).to eq([:top_center, :bottom_center])
      expect(board.neighboring_keys(:middle_left, "col")).to eq([:top_left, :bottom_left])
      expect(board.neighboring_keys(:middle_right, "col")).to eq([:top_right, :bottom_right])
      expect(board.neighboring_keys(:top_center, "col")).to eq([:center])
      expect(board.neighboring_keys(:bottom_center, "col")).to eq([:center])
      expect(board.neighboring_keys(:top_right, "col")).to eq([:middle_right])
    end
  end

  describe '#row_neighbor' do
    it 'returns the keys neighboring the given space in a row' do
      expect(board.row_neighbor(:center)).to eq([:middle_left, :middle_right])
    end
  end

  describe '#col_neighbor' do
    it 'returns the keys neighboring the given space in a column' do
      expect(board.col_neighbor(:center)).to eq([:top_center, :bottom_center])
    end
  end

  describe '#find_row_neighbors' do
    it 'returns the neighboring keys in a row for a collection' do
      expect(board.find_row_neighbors([:center, :middle_right])).to eq([[:middle_left, :middle_right], [:center]])
    end
  end

  describe '#find_col_neighbors' do
    it 'returns the neighboring keys in a row for a collection' do
      expect(board.find_col_neighbors([:center, :middle_right])).to eq([[:top_center, :bottom_center], [:top_right, :bottom_right]])
    end
  end

  describe '#surrounding_keys' do
    it 'returns the row/col set that includes the given space' do
      expect(board.surrounding_keys(:bottom_right)).to eq([[:bottom_left, :bottom_center, :bottom_right], [:top_right, :middle_right, :bottom_right]])
      expect(board.surrounding_keys(:center)).to eq([[:middle_left, :center, :middle_right], [:top_center, :center, :bottom_center]])
    end
  end

  describe '#surrounding_values' do
    it 'returns the values of the row/col set that includes the given space' do
      board.send(:grid=, marked_board)
      expect(board.surrounding_values(:center)).to eq([["X", "X", "O"], ["O", "X", "X"]])
      expect(board.surrounding_values(:top_left)).to eq([["X", "O", " "], ["X", "X", "O"]])
    end
  end

  describe '#side_in_row?' do
    it 'returns true if the side is a \'center\'' do
      expect(board.side_in_row?(:top_center)).to be true
    end

    it 'returns false if the side is a \'middle\'' do
      expect(board.side_in_row?(:middle_left)).to be false
    end
  end

  describe '#side_in_col?' do
    it 'returns true if the side is a \'middle\'' do
      expect(board.side_in_col?(:middle_right)).to be true
    end

    it 'returns false if the side is a \'center\'' do
      expect(board.side_in_col?(:bottom_center)).to be false
    end
  end

  describe '#to_s' do
    it 'prints the board as a string' do
      expect(board.to_s).to eq("                        |   |  \n                      ---------\n                        |   |  \n                      ---------\n                        |   |  ")
    end
  end
  
  def marked_board
    { top_left:    "X", top_center:    "O", top_right:    " ",
      middle_left: "X", center:        "X", middle_right: "O",
      bottom_left: "O", bottom_center: "X", bottom_right: " " }
  end
end
