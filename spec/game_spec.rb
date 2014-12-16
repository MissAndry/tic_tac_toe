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
      expect(game.players.map{ |player| player.class }).to include(Human, ComputerAI)
    end
  end

  describe '#mark_space' do
    it 'marks the space where requested' do
      expect{ game.mark_space("top left", game.computer) }.to change{ game.board.rows[0][0] }
      expect{ game.mark_space("center", game.human) }.to change{ game.board.rows[1][1] }
    end

    it 'marks the space with the player\'s space character' do
      game.mark_space("bottom right", game.computer)
      expect( game.board.rows[2][2] ).to eq( game.computer.space )
    end

    it 'doesn\'t let a player change an already populated space' do
      game.mark_space("center", game.computer)
      game.mark_space("center", game.human)
      expect( game.board.rows[1][1] ).to eq( game.computer.space )
    end
  end

  describe '#add_underscore' do
    it 'replaces spaces with underscores' do
      expect( game.add_underscore("top left") ).to eq("top_left")
    end
  end

  describe '#winner' do
    it 'returns the winner if there is a filled row' do
      row_win( game.computer )
      expect( game.winner ).to be( game.computer )
    end

    it 'returns the winner if there is a filled column' do
      column_win( game.human )
      expect( game.winner ).to be( game.human )
    end

    it 'returns the winner if there is a filled diagonal' do
      diagonal_win( game.human )
      expect( game.winner ).to be( game.human )
    end
  end

  describe '#finished?' do
    it 'is true if there is a winner' do
      diagonal_win( game.computer )
      expect( game.finished? ).to be true
    end

    it 'is true if all the spaces on the board are filled' do
      fill_board
      expect( game.finished? ).to be true
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
    game.mark_space("top right", game.human)
    game.mark_space("middle right", game.human)
    game.mark_space("bottom right", game.computer)
    game.mark_space("top center", game.computer)
    game.mark_space("center", game.human)
    game.mark_space("bottom center", game.computer)
    game.mark_space("top left", game.computer)
    game.mark_space("middle left", game.computer)
    game.mark_space("bottom left", game.human)
  end
end
