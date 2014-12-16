require_relative '../player'

describe 'Player' do
  let(:player){ Player.new }
end

describe 'Computer' do
  let(:computer){ Computer.new }

  starting_grid = { top_left:    "X", top_center:    " ", top_right:    " ",
                    middle_left: " ", center:        "O", middle_right: "X",
                    bottom_left: "X", bottom_center: " ", bottom_right: "O" }

  first_move_in_the_center = { top_left:    " ", top_center:    " ", top_right:    " ",
                               middle_left: " ", center:        "X", middle_right: " ",
                               bottom_left: " ", bottom_center: " ", bottom_right: " " }

  first_move_in_the_corner = { top_left:    " ", top_center:    " ", top_right:    " ",
                               middle_left: " ", center:        " ", middle_right: " ",
                               bottom_left: " ", bottom_center: " ", bottom_right: "X" }

  computer_can_win_by_row = { top_left:    "X", top_center:    " ", top_right:    " ",
                              middle_left: "O", center:        "O", middle_right: " ",
                              bottom_left: " ", bottom_center: "X", bottom_right: "X" }

  human_can_win_by_row = { top_left:    "X", top_center:    "O", top_right:    "O",
                           middle_left: " ", center:        " ", middle_right: "O",
                           bottom_left: " ", bottom_center: "X", bottom_right: "X" }

  computer_can_win_by_column = { top_left:    "X", top_center:    " ", top_right:    " ",
                                 middle_left: " ", center:        "O", middle_right: " ",
                                 bottom_left: " ", bottom_center: "O", bottom_right: "X" }

  human_can_win_by_column = { top_left:    "X", top_center:    " ", top_right:    " ",
                              middle_left: " ", center:        " ", middle_right: "X",
                              bottom_left: "O", bottom_center: "O", bottom_right: "X" }


  computer_can_win_by_diagonal = { top_left:    "O", top_center:    "X", top_right:    " ",
                                   middle_left: "X", center:        "O", middle_right: " ",
                                   bottom_left: " ", bottom_center: "X", bottom_right: " " }
  human_can_win_by_diagonal = { top_left:    "X", top_center:    "O", top_right:    " ",
                                middle_left: "X", center:        "X", middle_right: "O",
                                bottom_left: "O", bottom_center: "X", bottom_right: " " }

  it 'uses an "O" as a marker' do
    expect(computer.space).to eq("O")
  end

  describe 'ComputerAI module' do
    describe '#find_empty_spaces' do
      it 'returns the empty spaces on the board' do
        expect(computer.find_empty_spaces(starting_grid)).to eq({bottom_center: " ", middle_left: " ", top_center: " ", top_right: " "})
      end
    end

    describe '#first_move' do
      it 'returns the ideal first move (either a corner or center) depending on the opponent\'s first move' do
        expect(computer.first_move(first_move_in_the_center)).to eq([:top_left, :top_right, :bottom_left, :bottom_right])
        expect(computer.first_move(first_move_in_the_corner)).to eq([:center])
      end
    end

    describe '#next_move' do
      it 'wins the game if possible' do
        expect(computer.next_move(computer_can_win_by_row)).to eq(:middle_right)
        expect(computer.next_move(computer_can_win_by_column)).to eq(:top_center)
        expect(computer.next_move(computer_can_win_by_diagonal) ).to eq(:bottom_right)
      end

      it 'stops the opponent from winning' do
        expect(computer.next_move(human_can_win_by_row)).to eq(:bottom_left)
        expect(computer.next_move(human_can_win_by_column)).to eq(:top_right)
        expect(computer.next_move(human_can_win_by_diagonal)).to eq(:bottom_right)
      end
    end

    describe '#grid_rows' do
      it 'returns an array of rows as keys' do
        expect(computer.grid_rows(starting_grid.keys)).to eq([[:top_left, :top_center, :top_right],
                                                            [:middle_left, :center, :middle_right],
                                                            [:bottom_left, :bottom_center, :bottom_right]])
        expect(computer.grid_rows(starting_grid.values)).to eq([["X", " ", " "], [" ", "O", "X"], ["X", " ", "O"]])
      end
    end

    describe '#grid_cols' do
      it 'returns an array of columns as keys' do
        expect(computer.grid_cols(first_move_in_the_center.keys)).to eq([[:top_left, :middle_left, :bottom_left],
                                                            [:top_center, :center, :bottom_center],
                                                            [:top_right, :middle_right, :bottom_right]])
        expect(computer.grid_cols(starting_grid.values)).to eq([["X", " ", "X"], [" ", "O", " "], [" ", "X", "O"]])
      end
    end

    describe '#grid_diag' do
      it 'returns an array of diagonals' do
        expect(computer.grid_diag(computer_can_win_by_row.keys)).to eq([[:top_left, :center, :bottom_right],
                                                                   [:top_right, :center, :bottom_left]])
        expect(computer.grid_diag(starting_grid.values)) .to eq([["X", "O", "O"], [" ", "O", "X"]])
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
