require_relative '../player'
require_relative '../board'
require 'pry'

describe 'Human' do
  let(:human){ Human.new }
  it 'uses an "X" as a marker unless otherwise stated' do
    expect(human.marker).to eq("X")
  end
end

describe 'Computer' do
  let(:board){ Board.new }
  let(:computer){ Computer.new(board) }

  it 'uses an "O" as a marker by default' do
    expect(computer.marker).to eq("O")
  end

  it 'has a copy of the board' do
    expect(computer.board).not_to be_nil
  end

  describe 'ComputerAI module' do
    let(:x_computer){ Computer.new(board, "X") }
    let(:o_computer){ Computer.new(board) }
    describe '#board_empty?' do
      it 'returns true if the passed-in board grid is empty' do
        computer.send(:board=, empty_board)
        expect(computer.board_empty?).to be true
      end

      it 'returns false if the passed-in board grid has any marked spaces' do
        computer.send(:board=, starting_grid)
        expect(computer.board_empty?).to be false
      end
    end

    describe '#first_move?' do
      it 'returns true if the computer hasn\'t moved yet' do
        o_computer.send(:board=, first_move_in_the_center)
        expect(o_computer.first_move?).to be true
      end

      it 'returns true even if the x hasn\'t made a mark' do
        x_computer.send(:board=, o_makes_the_first_move)
        expect(x_computer.first_move?).to be true
      end

      it 'returns false if the computer has made a move' do
        o_computer.send(:board=, starting_grid)
        x_computer.send(:board=, starting_grid)
        expect(o_computer.first_move?).to be false
        expect(x_computer.first_move?).to be false
      end
    end

    describe '#which_move' do
      it 'returns the number of the current move (1, 2, 3, etc.) based on the number of markers each player has' do
        x_computer.send(:board=, starting_grid)
        o_computer.send(:board=, starting_grid)
        expect(x_computer.which_move).to be 4
        expect(o_computer.which_move).to be 3
      end
    end

    describe '#marked_spaces' do
      it 'returns the keys of the board grid that have been marked' do
        o_computer.send(:board=, starting_grid)
        expect(o_computer.marked_spaces).to eq([:top_left, :center, :middle_right, :bottom_left, :bottom_right])
      end
    end

    describe '#go_anywhere' do
      it 'returns the keys of the board grid that have not been marked' do
        o_computer.send(:board=, starting_grid)
        expect(o_computer.go_anywhere).to eq([:top_center, :top_right, :middle_left, :bottom_center])
      end
    end

    describe '#enemy_marker' do
      it 'returns the marker of the enemy' do
        expect(x_computer.enemy_marker).to eq("O")
        expect(o_computer.enemy_marker).to eq("X")
      end
    end

    describe '#block_them' do
      pending 'stops the opponent from winning if they have two marked spaces in a row' do
        o_computer.send(:board=, starting_grid)
        expect(o_computer.block_them).to eq(:middle_left)
      end
    end
  end

  def starting_grid
    board.grid[:bottom_left] = "X"
    board.grid[:top_left] = "X"
    board.grid[:middle_right] = "X"
    board.grid[:bottom_right] = "O"
    board.grid[:center] = "O"
    board.grid
    # { top_left:    "X", top_center:    " ", top_right:    " ",
    #   middle_left: " ", center:        "O", middle_right: "X",
    #   bottom_left: "X", bottom_center: " ", bottom_right: "O" }
  end

  def two_human_moves_one_computer_corners_taken
    board.grid[:top_right] = "X"
    board.grid[:center] = "O"
    board.grid[:bottom_left] = "X"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    "X",
    #   middle_left: " ", center:        "O", middle_right: " ",
    #   bottom_left: "X", bottom_center: " ", bottom_right: " " }
  end

  def two_human_moves_one_computer_sides_taken
    board.grid[:top_center] = "X"
    board.grid[:center] = "O"
    board.grid[:bottom_left] = "X"
    board.grid
    # { top_left:    " ", top_center:    "X", top_right:    " ",
    #   middle_left: " ", center:        "O", middle_right: " ",
    #   bottom_left: "X", bottom_center: " ", bottom_right: " " }
  end

  def two_human_moves_one_computer_human_takes_center
    board.grid[:center] = "X"
    board.grid[:middle_right] = "X"
    board.grid[:bottom_right] = "O"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    " ",
    #   middle_left: " ", center:        "X", middle_right: "X",
    #   bottom_left: " ", bottom_center: " ", bottom_right: "O" }
  end

  def first_move_in_the_center
    board.grid[:center] = "X"
    board.grid
  end

  def first_move_on_the_side
    board.grid[:middle_right] = "X"
    board.grid
  end

  def bottom_left_corner_taken
    board.grid[:bottom_left] = "X"
    board.grid
  end

  def bottom_right_corner_taken
    board.grid[:bottom_right] = "X"
    board.grid
  end

  def top_left_corner_taken
    board.grid[:top_left] = "X"
    board.grid
  end

  def top_right_corner_taken
    board.grid[:top_right] = "X"
    board.grid
  end

  def computer_can_win_by_row
    board.grid[:top_left] = "X"
    board.grid[:middle_left] = "O"
    board.grid[:center] = "O"
    board.grid[:bottom_center] = "X"
    board.grid[:bottom_right] = "X"
    board.grid
    # { top_left:    "X", top_center:    " ", top_right:    " ",
    #   middle_left: "O", center:        "O", middle_right: " ",
    #   bottom_left: " ", bottom_center: "X", bottom_right: "X" }
  end

  def computer_can_win_by_column
    board.grid[:middle_left] = "X"
    board.grid[:center] = "O"
    board.grid[:bottom_left] = "X"
    board.grid[:bottom_center] = "O"
    board.grid[:bottom_right] = "X"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    " ",
    #   middle_left: "X", center:        "O", middle_right: " ",
    #   bottom_left: "X", bottom_center: "O", bottom_right: "X" }
  end

  def computer_can_win_by_diagonal
    board.grid[:top_left] = "O"
    board.grid[:top_center] = "X"
    board.grid[:middle_left] = "X"
    board.grid[:center] = "O"
    board.grid[:bottom_center] = "X"
    board.grid
    # { top_left:    "O", top_center:    "X", top_right:    " ",
    #   middle_left: "X", center:        "O", middle_right: " ",
    #   bottom_left: " ", bottom_center: "X", bottom_right: " " }
  end

  def human_can_win_by_row
    board.grid[:top_left] = "O"
    board.grid[:middle_left] = "X"
    board.grid[:center] = "O"
    board.grid[:middle_right] = "O"
    board.grid[:bottom_center] = "X"
    board.grid[:bottom_right] = "X"
    board.grid
    # { top_left:    "O", top_center:    " ", top_right:    " ",
    #   middle_left: "X", center:        "O", middle_right: "O",
    #   bottom_left: " ", bottom_center: "X", bottom_right: "X" }
  end

  def human_can_win_by_column
    board.grid[:center] = "O"
    board.grid[:middle_right] = "X"
    board.grid[:bottom_right] = "X"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    " ",
    #   middle_left: " ", center:        "O", middle_right: "X",
    #   bottom_left: " ", bottom_center: " ", bottom_right: "X" }
  end

  def human_can_win_by_diagonal
    board.grid[:top_left] = "X"
    board.grid[:top_center] = "O"
    board.grid[:middle_left] = "X"
    board.grid[:center] = "X"
    board.grid[:middle_right] = "O"
    board.grid[:bottom_left] = "O"
    board.grid[:bottom_center] = "X"
    board.grid
    # { top_left:    "X", top_center:    "O", top_right:    " ",
    #   middle_left: "X", center:        "X", middle_right: "O",
    #   bottom_left: "O", bottom_center: "X", bottom_right: " " }
  end

  def bottom_center_taken_first_center_taken_second
    board.grid[:middle_left] = "X"
    board.grid[:center] = "O"
    board.grid[:bottom_center] = "X"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    " ",
    #   middle_left: "X", center:        "O", middle_right: " ",
    #   bottom_left: " ", bottom_center: "X", bottom_right: " " }
  end

  def o_makes_the_first_move
    board.grid[:bottom_left] = "O"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    " ",
    #   middle_left: " ", center:        " ", middle_right: " ",
    #   bottom_left: "O", bottom_center: " ", bottom_right: " " }
  end

  def empty_board
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    " ",
    #   middle_left: " ", center:        " ", middle_right: " ",
    #   bottom_left: " ", bottom_center: " ", bottom_right: " " }
  end
end
