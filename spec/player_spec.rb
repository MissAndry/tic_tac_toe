require_relative '../player'

describe 'Player' do
  let(:player){ Player.new }
end

describe 'Computer' do
  let(:computer){ Computer.new }
  it 'uses an "O" as a space' do
    expect(computer.space).to eq("O")
  end

  describe 'find_empty_spaces' do
    board_grid = { top_left:    "X", top_center:    " ", top_right:    " ",
                   middle_left: " ", center:        "O", middle_right: "X",
                   bottom_left: "X", bottom_center: " ", bottom_right: "O" }
    it 'returns empty spaces from a board grid' do
      expect(computer.find_empty_spaces(board_grid)).to eq([:top_center, :top_right, :middle_left, :bottom_center])
    end
  end
end

describe 'Human' do
  let(:human){ Human.new }
  it 'uses an "X" as a space' do
    expect(human.space).to eq("X")
  end
end