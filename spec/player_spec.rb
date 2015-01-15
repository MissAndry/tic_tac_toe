require_relative '../player'

describe 'Human' do
  let(:human){ Human.new }
  it 'uses an "X" as a marker unless otherwise stated' do
    expect(human.marker).to eq("X")
  end
end

describe 'Computer' do
  let(:computer){ Computer.new }

  it 'uses an "O" as a marker by default' do
    expect(computer.marker).to eq("O")
  end

  describe 'ComputerAI module' do
    describe '#board_empty?' do
      it 'returns true if the passed-in board grid is empty' do
        expect(computer.board_empty?(empty_board)).to be true
      end

      it 'returns false if the passed-in board grid has any marked spaces' do
        expect(computer.board_empty?(starting_grid)).to be false
      end
    end
  end

  def starting_grid
    { top_left:    "X", top_center:    " ", top_right:    " ",
      middle_left: " ", center:        "O", middle_right: "X",
      bottom_left: "X", bottom_center: " ", bottom_right: "O" }
  end

  def two_human_moves_one_computer_corners_taken
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

  def first_move_on_the_side
    { top_left:    " ", top_center:    " ", top_right:    " ",
      middle_left: " ", center:        " ", middle_right: "X",
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
    { top_left:    "O", top_center:    " ", top_right:    " ",
      middle_left: "X", center:        "O", middle_right: "O",
      bottom_left: " ", bottom_center: "X", bottom_right: "X" }
  end

  def human_can_win_by_column
    { top_left:    " ", top_center:    " ", top_right:    " ",
      middle_left: " ", center:        "O", middle_right: "X",
      bottom_left: " ", bottom_center: " ", bottom_right: "X" }
  end

  def human_can_win_by_diagonal
    { top_left:    "X", top_center:    "O", top_right:    " ",
      middle_left: "X", center:        "X", middle_right: "O",
      bottom_left: "O", bottom_center: "X", bottom_right: " " }
  end

  def bottom_center_taken_first_center_taken_second
    { top_left:    " ", top_center:    " ", top_right:    " ",
      middle_left: "X", center:        "O", middle_right: " ",
      bottom_left: " ", bottom_center: "X", bottom_right: " " }
  end

  def empty_board
    { top_left:    " ", top_center:    " ", top_right:    " ",
      middle_left: " ", center:        " ", middle_right: " ",
      bottom_left: " ", bottom_center: " ", bottom_right: " " }
  end
end
