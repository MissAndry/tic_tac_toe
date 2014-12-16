require_relative '../player'

describe 'Player' do
  let(:player){ Player.new }
end

describe 'ComputerAI' do
  let(:computer){ ComputerAI.new }
  it 'uses an "O" as a space' do
    expect(computer.space).to eq("O")
  end
end

describe 'Human' do
  let(:human){ Human.new }
  it 'uses an "X" as a space' do
    expect(human.space).to eq("X")
  end
end