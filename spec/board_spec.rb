require_relative '../board'

describe 'Board' do
  let(:board){ Board.new }
  it 'has nine spaces' do
    expect(board.grid.length).to be 9
  end

  describe '#rows' do
    it 'returns an array of all the rows' do
      expect(board.rows).to eq(Array.new(3, Array.new(3, " ")))
    end
  end

  describe '#column' do
    it 'returns an array of all the columns' do
      expect(board.columns).to eq(board.rows.transpose)
    end
  end

  describe '#to_s' do
    it 'prints the board as a string' do
      expect(board.to_s).to eq(board.rows[0].join(Board::COLUMN_BREAK) + Board::BREAKER + board.rows[1].join(Board::COLUMN_BREAK) + Board::BREAKER + board.rows[2].join(Board::COLUMN_BREAK))
    end
  end
end