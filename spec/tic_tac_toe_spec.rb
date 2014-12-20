require_relative '../tic_tac_toe'

describe 'TicTacToe' do
  let(:tic_tac_toe){ TicTacToe.new }

  it 'sets a game on initialization' do
    expect(tic_tac_toe.game).not_to be nil
    expect(tic_tac_toe.game).to be_a Game
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

  context "computer player set first" do
    let(:tic_tac_computer_goes_first){ TicTacToe.new(player1: "computer", player2: "human") }
    it 'has the computer as the first player' do
      expect(tic_tac_computer_goes_first.player1).to be_a Computer
    end

    it 'has the human as the second player' do
      expect(tic_tac_computer_goes_first.player2).to be_a Human
    end

    it 'sets the computer player with "X" as a marker' do
      expect(tic_tac_computer_goes_first.player1.space).to eq("X")
    end

    it 'sets the human player with "O" as a marker' do
      expect(tic_tac_computer_goes_first.player2.space).to eq("O")
    end
  end

  context "two computer players" do
    let(:tic_tac_computer){ TicTacToe.new(player1: "computer", player2: "computer") }
    it 'initializes with two computer players' do
      expect(tic_tac_computer.players.all? { |player| player.is_a? Computer }).to be true
    end

    it 'sets the players with different markers' do
      expect(tic_tac_computer.player1.space).not_to eq(tic_tac_computer.player2.space)
    end
  end
end