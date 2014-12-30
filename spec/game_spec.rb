require_relative '../game'

describe 'Game' do
  let(:game){ Game.new }

  it 'has players' do
    expect( game.players ).not_to be nil
  end

  it 'has a board' do
    expect( game.board ).not_to be nil
  end

  describe '#players' do
    it 'has two players' do
      expect( game.players.length ).to be 2
    end

    it 'has one Human player and one Computer player' do
      expect(game.players).to include(Human, Computer)
    end
  end

  describe 'player1' do
    it 'is the first player' do
      expect(game.player1).to eq(game.players[0])
    end
  end

  describe 'player2' do
    it 'is the second player' do
      expect(game.player2).to eq(game.players[1])
    end
  end

  describe '#mark_space' do
    it 'marks the space where requested' do
      expect{ game.mark_space("top left", game.player2) }.to change{ game.board.rows[0][0] }
      expect{ game.mark_space("center", game.player1) }.to change{ game.board.rows[1][1] }
    end

    it 'marks the space with the player\'s space character' do
      game.mark_space("bottom right", game.player2)
      expect( game.board.rows[2][2] ).to eq( game.player2.space )
    end

    it 'doesn\'t let a player change an already populated space' do
      game.mark_space("center", game.player2)
      game.mark_space("center", game.player1)
      expect( game.board.rows[1][1] ).to eq( game.player2.space )
    end

    it 'works with symbols' do
      expect{ game.mark_space(:center, game.player1) }.not_to raise_error
      expect{ game.mark_space(:top_right, game.player1) }.to change{ game.board.rows[0][2] }
    end
  end

  describe '#add_underscore' do
    it 'replaces spaces with underscores' do
      expect( game.add_underscore("top left") ).to eq("top_left")
    end
  end

  describe '#winner' do
    it 'returns the winner if there is a filled row' do
      row_win( game.player2 )
      expect( game.winner ).to eq( game.player2 )
    end

    it 'returns the winner if there is a filled column' do
      column_win( game.player1 )
      expect( game.winner ).to eq( game.player1 )
    end

    it 'returns the winner if there is a filled diagonal' do
      diagonal_win( game.player1 )
      expect( game.winner ).to eq( game.player1 )
    end
  end

  describe '#finished?' do
    it 'is true if there is a winner' do
      diagonal_win( game.player2 )
      expect( game.finished? ).to be true
    end

    it 'is true if all the spaces on the board are filled' do
      fill_board
      expect( game.finished? ).to be true
    end
  end

  context "two computer players" do
    let(:tic_tac_computer){ Game.new(player1: "computer", player2: "computer") }
    it 'initializes with two computer players' do
      expect(tic_tac_computer.players.all? { |player| player.is_a? Computer }).to be true
    end

    it 'sets the players with different markers' do
      expect(tic_tac_computer.player1.space).not_to eq(tic_tac_computer.player2.space)
    end

    it 'always results in a tie' do
      until tic_tac_computer.finished?
        tic_tac_computer.mark_space(tic_tac_computer.player1.next_move(tic_tac_computer.board.grid), tic_tac_computer.player1)
        tic_tac_computer.mark_space(tic_tac_computer.player2.next_move(tic_tac_computer.board.grid), tic_tac_computer.player2)
      end
      expect(tic_tac_computer.winner).to be nil
    end
  end

  def diagonal_win(player)
    game.mark_space("top right", player)
    game.mark_space("center", player)
    game.mark_space("bottom left", player)
  end

  def row_win(player)
    game.mark_space("middle left", player)
    game.mark_space("center", player)
    game.mark_space("middle right", player)
  end

  def column_win(player)
    game.mark_space("top right", player)
    game.mark_space("middle right", player)
    game.mark_space("bottom right", player)
  end

  def fill_board
    game.mark_space("top right", game.player1)
    game.mark_space("middle right", game.player1)
    game.mark_space("bottom right", game.player2)
    game.mark_space("top center", game.player2)
    game.mark_space("center", game.player1)
    game.mark_space("bottom center", game.player2)
    game.mark_space("top left", game.player2)
    game.mark_space("middle left", game.player2)
    game.mark_space("bottom left", game.player1)
  end
end
