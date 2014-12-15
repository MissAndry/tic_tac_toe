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
end
