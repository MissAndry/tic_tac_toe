require_relative '../tic_tac_toe'

describe 'TicTacToe' do
  let(:tic_tac_toe){ TicTacToe.new }

  it 'sets a board on initialization' do
    expect(tic_tac_toe.board).not_to be nil
  end

  it 'has two players' do
    expect(tic_tac_toe.players.length).to eq 2
  end

  it 'defaults to a human and a computer player' do
    expect(tic_tac_toe.players).to include(Human, Computer)
  end

  describe 'player1' do
    it 'is the first player' do
      expect(tic_tac_toe.player1).to eq(tic_tac_toe.players[0])
    end
  end

  describe 'player2' do
    it 'is the second player' do
      expect(tic_tac_toe.player2).to eq(tic_tac_toe.players[1])
    end
  end

  context "one human player, one computer player" do
  end
end