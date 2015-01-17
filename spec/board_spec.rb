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

  describe '#empty?' do
    it 'returns true if the board is empty' do
      expect(board.empty?).to be true
    end

    it 'returns false if the board is not empty' do
      board.grid[:center] = "X"
      expect(board.empty?).to be false
    end
  end

  describe '#to_s' do
    it 'prints the board as a string' do
      expect(board.to_s).to eq(Board::PADDING + board.rows[0].join(Board::COLUMN_BREAK) + Board::BREAKER + Board::PADDING + board.rows[1].join(Board::COLUMN_BREAK) + Board::BREAKER + Board::PADDING + board.rows[2].join(Board::COLUMN_BREAK))
    end
  end
end
