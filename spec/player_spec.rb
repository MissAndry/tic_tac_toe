require_relative '../player'

describe 'Player' do
  let(:player){ Player.new }
end

describe 'Computer' do
  let(:computer){ Computer.new }
  
  started_grid = { top_left:    "X", top_center:    " ", top_right:    " ",
                   middle_left: " ", center:        "O", middle_right: "X",
                   bottom_left: "X", bottom_center: " ", bottom_right: "O" }

  center_first = { top_left:    " ", top_center:    " ", top_right:    " ",
                   middle_left: " ", center:        "X", middle_right: " ",
                   bottom_left: " ", bottom_center: " ", bottom_right: " " }

  corner_first = { top_left:    " ", top_center:    " ", top_right:    " ",
                   middle_left: " ", center:        " ", middle_right: " ",
                   bottom_left: " ", bottom_center: " ", bottom_right: "X" }
  
  it 'uses an "O" as a space' do
    expect(computer.space).to eq("O")
  end

  describe 'ComputerAI module' do
    describe '#find_empty_spaces' do
      it 'returns empty spaces from a board grid' do
        expect(computer.find_empty_spaces(started_grid)).to eq([:top_center, :top_right, :middle_left, :bottom_center])
      end
    end

    describe '#first_move' do
      it 'returns the ideal first move (either a corner or center) depending on the human\'s first move' do
        expect(computer.first_move(center_first)).to eq([:top_left, :top_right, :bottom_left, :bottom_right])
        expect(computer.first_move(corner_first)).to eq([:center])
      end
    end
  end
end

describe 'Human' do
  let(:human){ Human.new }
  it 'uses an "X" as a space' do
    expect(human.space).to eq("X")
  end
end