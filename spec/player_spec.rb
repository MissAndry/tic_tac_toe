require_relative '../player'

describe 'Player' do
  let(:player){ Player.new }
end

describe 'Human' do
  let(:human){ Human.new }
  it 'uses an "X" as a marker' do
    expect(human.space).to eq("X")
  end
end

describe 'Computer' do
  let(:computer){ Computer.new }

  it 'uses an "O" as a marker' do
    expect(computer.space).to eq("O")
  end

  describe 'ComputerAI module' do
    describe '#enemy_marker' do
      it 'returns an "O" if the computer\'s marker is an "X", and vice versa' do
        x_marks_the_spot = Computer.new("X")
        o_no_you_didnt = Computer.new("O")
        expect(x_marks_the_spot.enemy_marker).to eq("O")
        expect(o_no_you_didnt.enemy_marker).to eq("X")
      end
    end

    describe '#first_move' do
      it 'returns the ideal first move (either a corner or center) depending on the opponent\'s first move' do
        expect(computer.first_move(first_move_in_the_center)).to eq([:top_left, :top_right, :bottom_left, :bottom_right])
        expect(computer.first_move(bottom_left_corner_taken)).to eq([:top_right])
      end
    end

    describe '#next_move' do
      it 'wins the game if possible' do
        expect(computer.next_move(computer_can_win_by_row)).to eq(:middle_right)
        expect(computer.next_move(computer_can_win_by_column)).to eq(:top_center)
        expect(computer.next_move(computer_can_win_by_diagonal)).to eq(:bottom_right)
      end

      it 'stops the opponent from winning' do
        expect(computer.next_move(human_can_win_by_row)).to eq(:bottom_left)
        expect(computer.next_move(human_can_win_by_column)).to eq(:top_right)
        expect(computer.next_move(human_can_win_by_diagonal)).to eq(:bottom_right)
        expect(computer.next_move(starting_grid)).to eq(:middle_left)
        expect(computer.next_move(two_human_moves_one_computer_human_takes_center)).to eq(:middle_left)
      end

      it 'chooses the winning move over the defensive move' do
        computer_can_win_by_row[:top_center] = "X"
        computer_can_win_by_column[:top_right] = "X"
        expect(computer.next_move(computer_can_win_by_row)).to eq(:middle_right)
        expect(computer.next_move(computer_can_win_by_column)).to eq(:top_center)
      end

      it 'takes the empty corners first' do
        expect(computer.next_move(two_human_moves_one_computer_corners_taken)).to eq(:top_left)
        expect(computer.next_move(two_human_moves_one_computer_sides_taken)).to eq(:top_left)
      end

      it 'takes empty corners when the computer has the first move' do
        expect([:top_left, :top_right, :bottom_left, :bottom_right]).to include(computer.next_move(empty_board))
      end
    end

    describe '#find_opposing_diagonal' do
      it 'finds the diagonal opposite from a taken diagonal' do
        expect(computer.find_opposing_diagonal(bottom_left_corner_taken)).to eq([:top_right, " "])
        expect(computer.find_opposing_diagonal(bottom_right_corner_taken)).to eq([:top_left, " "])
        expect(computer.find_opposing_diagonal(top_left_corner_taken)).to eq([:bottom_right, " "])
        expect(computer.find_opposing_diagonal(top_right_corner_taken)).to eq([:bottom_left, " "])
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

  def starting_grid
    { top_left:    "X", top_center:    " ", top_right:    " ",
      middle_left: " ", center:        "O", middle_right: "X",
      bottom_left: "X", bottom_center: " ", bottom_right: "O" }
  end

  def two_human_moves_one_computer_corners_taken # => the strategy of taking the corners currently makes the computer beatable 12/16
    { top_left:    " ", top_center:    " ", top_right:    "X",
      middle_left: " ", center:        "O", middle_right: " ",
      bottom_left: "X", bottom_center: " ", bottom_right: " " }
  end

  def two_human_moves_one_computer_sides_taken
    { top_left:    " ", top_center:    "X", top_right:    " ",
      middle_left: " ", center:        "O", middle_right: " ",
      bottom_left: "X", bottom_center: " ", bottom_right: " " }
  end

  def two_human_moves_one_computer_human_takes_center
    { top_left:    " ", top_center:    " ", top_right:    " ",
      middle_left: " ", center:        "X", middle_right: "X",
      bottom_left: " ", bottom_center: " ", bottom_right: "O" }
  end

  def first_move_in_the_center
    { top_left:    " ", top_center:    " ", top_right:    " ",
      middle_left: " ", center:        "X", middle_right: " ",
      bottom_left: " ", bottom_center: " ", bottom_right: " " }
  end

  def bottom_left_corner_taken
    { top_left:    " ", top_center:    " ", top_right:    " ",
      middle_left: " ", center:        " ", middle_right: " ",
      bottom_left: "X", bottom_center: " ", bottom_right: " " }
  end

  def bottom_right_corner_taken
    { top_left:    " ", top_center:    " ", top_right:    " ",
      middle_left: " ", center:        " ", middle_right: " ",
      bottom_left: " ", bottom_center: " ", bottom_right: "X" }
  end

  def top_left_corner_taken
    { top_left:    "X", top_center:    " ", top_right:    " ",
      middle_left: " ", center:        " ", middle_right: " ",
      bottom_left: " ", bottom_center: " ", bottom_right: " " }
  end

  def top_right_corner_taken
    { top_left:    " ", top_center:    " ", top_right:    "X",
      middle_left: " ", center:        " ", middle_right: " ",
      bottom_left: " ", bottom_center: " ", bottom_right: " " }
  end

  def computer_can_win_by_row
    { top_left:    "X", top_center:    " ", top_right:    " ",
      middle_left: "O", center:        "O", middle_right: " ",
      bottom_left: " ", bottom_center: "X", bottom_right: "X" }
  end

  def computer_can_win_by_column
    { top_left:    " ", top_center:    " ", top_right:    " ",
      middle_left: "X", center:        "O", middle_right: " ",
      bottom_left: "X", bottom_center: "O", bottom_right: "X" }
  end

  def computer_can_win_by_diagonal
    { top_left:    "O", top_center:    "X", top_right:    " ",
      middle_left: "X", center:        "O", middle_right: " ",
      bottom_left: " ", bottom_center: "X", bottom_right: " " }
  end

  def human_can_win_by_row
    { top_left:    "X", top_center:    "O", top_right:    "O",
      middle_left: " ", center:        " ", middle_right: "O",
      bottom_left: " ", bottom_center: "X", bottom_right: "X" }
  end

  def human_can_win_by_column
    { top_left:    "X", top_center:    " ", top_right:    " ",
      middle_left: " ", center:        " ", middle_right: "X",
      bottom_left: "O", bottom_center: "O", bottom_right: "X" }
  end

  def human_can_win_by_diagonal
    { top_left:    "X", top_center:    "O", top_right:    " ",
      middle_left: "X", center:        "X", middle_right: "O",
      bottom_left: "O", bottom_center: "X", bottom_right: " " }
  end

  def empty_board
    { top_left:    " ", top_center:    " ", top_right:    " ",
      middle_left: " ", center:        " ", middle_right: " ",
      bottom_left: " ", bottom_center: " ", bottom_right: " " }
  end
end
