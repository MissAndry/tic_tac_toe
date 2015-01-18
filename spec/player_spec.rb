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

    describe '#first_move' do
      context 'marker is "X"' do
        it 'tells the computer to go anywhere' do
          expect(x_computer.first_move).to eq(starting_grid.keys)
        end
      end

      context 'marker is "O" and "X" has already gone' do
       it 'takes a corner space if "X" is in the center' do
          o_computer.send(:board=, first_move_in_the_center)
          expect(o_computer.first_move).to eq([:top_left, :top_right, :bottom_left, :bottom_right])
        end
        
        it 'takes the center space if "X" is in a corner' do
          o_computer.send(:board=, bottom_right_corner_taken)
          expect(o_computer.first_move).to eq([:center])
        end

        it 'takes a space in the row or column including "X" if "X" starts on the side' do
          o_computer.send(:board=, first_move_on_the_side)
          expect(o_computer.first_move).to eq([:middle_left, :center, :top_right, :bottom_right])
        end
      end
    end

    describe '#next_move' do
      it 'returns a symbol indicating the best next move' do
        o_computer.send(:board=, bottom_right_corner_taken)
        expect(o_computer.next_move).to eq(:center)

        o_computer.send(:board=, nil)
        o_computer.send(:board=, first_move_on_the_side)
        expect(o_computer.next_move).to satisfy{ |move| [:middle_left, :center, :top_right, :bottom_right].include? move }

        o_computer.send(:board=, nil)
        o_computer.send(:board=, first_move_in_the_center)
        expect(o_computer.next_move).to satisfy{ |move| [:top_left, :top_right, :bottom_left, :bottom_right].include? move }

        o_computer.send(:board=, nil)
        o_computer.send(:board=, computer_can_win_by_row)
        expect(o_computer.next_move).to eq(:middle_right)
      end
    end

    describe '#tryna_win?' do
      it 'returns true if the computer can win by row in one move' do
        o_computer.send(:board=, computer_can_win_by_row)
        expect(o_computer.tryna_win?).to be true
      end

      it 'returns true if the computer can win by column in one move' do
        o_computer.send(:board=, computer_can_win_by_column)
        expect(o_computer.tryna_win?).to be true
      end

      it 'returns true if the computer can win by diagonal in one move' do
        o_computer.send(:board=, computer_can_win_by_diagonal)
        expect(o_computer.tryna_win?).to be true
      end

      it 'returns false if the computer can\'t win in one move' do
        o_computer.send(:board=, two_human_moves_one_computer_corners_taken)
        expect(o_computer.tryna_win?).to be false
      end
    end

    describe '#tryna_win' do
      it 'chooses the winning move when the "X" computer can win by row' do
        x_computer.send(:board=, human_can_win_by_row)
        expect(x_computer.tryna_win).to eq([:bottom_left])
      end
      
      it 'chooses the winning move when the "O" computer can win by row' do
        o_computer.send(:board=, computer_can_win_by_row)
        expect(o_computer.tryna_win).to eq([:middle_right])
      end
      
      it 'chooses the winning move when the "X" computer can win by column' do
        x_computer.send(:board=, human_can_win_by_column)
        expect(x_computer.tryna_win).to eq([:top_right])
      end
      
      it 'chooses the winning move when the "O" computer can win by column' do
        o_computer.send(:board=, computer_can_win_by_column)
        expect(o_computer.tryna_win).to eq([:top_center])
      end
      
      it 'chooses the winning move when the "X" computer can win by diagonal' do
        x_computer.send(:board=, human_can_win_by_diagonal)
        expect(x_computer.tryna_win).to eq([:bottom_right])
      end
      
      it 'chooses the winning move when the "O" computer can win by diagonal' do
        o_computer.send(:board=, computer_can_win_by_diagonal)
        expect(o_computer.tryna_win).to eq([:bottom_left])
      end
    end

    describe '#enemy_in_the_corner?' do
      it 'returns true if the enemy is in the corner' do
        o_computer.send(:board=, bottom_right_corner_taken)
        expect(o_computer.enemy_in_the_corner?).to be true
      end
    end

    describe '#enemy_on_the_side?' do
      it 'returns true if the enemy is on the side' do
        o_computer.send(:board=, first_move_on_the_side)
        expect(o_computer.enemy_on_the_side?).to be true
      end
    end

    describe '#which_move' do
      it 'returns the number of the current move (1, 2, 3, etc.) based on the number of markers each player has on the board' do
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

    describe '#neighboring_spaces' do
      it 'finds the one to two spaces next to a given space in a row' do
        expect(o_computer.neighboring_spaces(:center, "row")).to eq([:middle_left, :middle_right])
        expect(o_computer.neighboring_spaces(:top_center, "row")).to eq([:top_left, :top_right])
        expect(o_computer.neighboring_spaces(:bottom_center, "row")).to eq([:bottom_left, :bottom_right])
        expect(o_computer.neighboring_spaces(:bottom_left, "row")).to eq([:bottom_center])
        expect(o_computer.neighboring_spaces(:top_right, "row")).to eq([:top_center])
      end

      it 'finds the one to two spaces next to a given space in a column' do
        expect(o_computer.neighboring_spaces(:center, "col")).to eq([:top_center, :bottom_center])
        expect(o_computer.neighboring_spaces(:middle_left, "col")).to eq([:top_left, :bottom_left])
        expect(o_computer.neighboring_spaces(:middle_right, "col")).to eq([:top_right, :bottom_right])
        expect(o_computer.neighboring_spaces(:top_center, "col")).to eq([:center])
        expect(o_computer.neighboring_spaces(:bottom_center, "col")).to eq([:center])
        expect(o_computer.neighboring_spaces(:top_right, "col")).to eq([:middle_right])
      end
    end

    describe '#defense_necessary?' do
      it 'returns true if the opponent can win in one move' do
        o_computer.send(:board=, human_can_win_by_row)
        expect(o_computer.defense_necessary?).to be true
      end

      it 'returns false if the opponent can\'t win in one move' do
        o_computer.send(:board=, two_human_moves_one_computer_sides_taken)
        expect(o_computer.defense_necessary?).to be false
      end
    end

    describe '#block_them' do
      it 'stops the opponent from winning if they have two marked spaces in a row' do
        o_computer.send(:board=, starting_grid)
        expect(o_computer.block_them).to eq([:middle_left])
      end
      it 'stops the opponent from winning if they have two marked spaces in a row' do
        x_computer.send(:board=, computer_can_win_by_diagonal)
        expect(x_computer.block_them).to eq([:bottom_left])
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
    board.grid[:top_right] = "O"
    board.grid[:top_center] = "X"
    board.grid[:middle_left] = "X"
    board.grid[:center] = "O"
    board.grid[:bottom_center] = "X"
    board.grid
    # { top_left:    " ", top_center:    "X", top_right:    "O",
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
