require_relative '../player'

describe 'Player' do
  let(:player){ Player.new }
  it 'has its own space' do
    expect(player.space).not_to be_nil
    expect(player.space).not_to be_empty
  end

  it 'initializes with its own space' do
    player2 = Player.new("hey")
    expect(player2.space).to eq("hey")
  end

  it 'initializes with "X" as a space by default' do
    expect(player.space).to eq("X")
  end
end

describe 'ComputerAI' do
  let(:computer){ ComputerAI.new }
  it 'uses an "O" as a space' do
    expect(computer.space).to eq("O")
  end
end