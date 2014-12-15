require_relative '../game'

describe 'Game' do
  let(:game){ Game.new }

  it 'has nine spaces' do
    expect(game.grid.length).to be 9
  end

  describe '#rows' do
    it 'returns an array of all the rows' do
      expect(game.rows).to eq(Array.new(3, Array.new(3, " ")))
    end
  end

  describe '#column' do
    it 'returns an array of all the columns' do
      expect(game.columns).to eq(game.rows.transpose)
    end
  end

  describe '#to_s' do
    it 'prints the game as a string' do
      expect(game.to_s).to eq(game.rows[0].join(Game::COLUMN_BREAK) + Game::BREAKER + game.rows[1].join(Game::COLUMN_BREAK) + Game::BREAKER + game.rows[2].join(Game::COLUMN_BREAK))
    end
  end

  describe '#mark_space' do
    it 'marks the space where requested' do
      expect{ game.mark_space("top left") }.to change{ game.rows[0][0] }
    end
  end
  
  describe '#add_underscore' do
    it 'replaces spaces with underscores' do
      expect( game.add_underscore("top left") ).to eq("top_left")
    end
  end
end