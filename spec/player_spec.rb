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
        o_computer.send(:board=, x_moves_first_in_center)
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
          o_computer.send(:board=, x_moves_first_in_center)
          expect(o_computer.first_move).to eq([:top_left, :top_right, :bottom_left, :bottom_right])
        end
        
        it 'takes the center space if "X" is in a corner' do
          o_computer.send(:board=, x_moves_first_in_bottom_right_corner)
          expect(o_computer.first_move).to eq([:center])
        end

        it 'takes a space in the row or column including "X" if "X" starts on the side' do
          o_computer.send(:board=, x_moves_first_on_side)
          expect(o_computer.first_move).to eq([:top_left, :top_right, :bottom_center, :center])

          reset_boards
          o_computer.board.grid[:middle_left] = "X"
          expect(o_computer.first_move).to eq([:top_left, :bottom_left, :middle_right, :center])
        end
      end
    end

    describe '#second_move' do
      context 'marker is "X"' do
        it 'gives any move but the one directly across from "O" when "X" has the center and "O" has a side' do
          x_computer.send(:board=, x_started_in_the_center_and_o_took_a_side)
          expect(x_computer.second_move).to eq([:top_left, :top_center, :top_right, :bottom_left, :bottom_center, :bottom_right])
          expect(x_computer.second_move).not_to include(:middle_left)
        end

        it 'takes the center or a corner if "X" took a corner first and "O" takes a side' do
          x_computer.send(:board=, x_started_in_a_corner_and_o_takes_a_side)
          expect(x_computer.second_move).to eq([:top_left, :bottom_left, :center])
        end

        it 'takes one of the two remaining corners if "X" took a corner first and "O" also took a corner' do
          x_computer.send(:board=, x_started_in_a_corner_and_o_took_a_corner)
          expect(x_computer.second_move).to eq([:top_left, :bottom_left])
        end

        it 'moves anywhere if "X" took a corner first and "O" is in the center' do
          x_computer.send(:board=, x_started_in_a_corner_and_o_took_center)
          expect(x_computer.second_move).to eq([:top_left, :top_center, :top_right, :middle_left, :middle_right, :bottom_left, :bottom_center])
        end

        it 'moves anywhere besides the opposite side if "X" took a side first and "O" is in a corner or the center' do
          x_computer.send(:board=, x_started_on_the_side_and_o_is_in_the_center)
          expect(x_computer.second_move).to eq([:top_left, :top_center, :top_right, :bottom_left, :bottom_center, :bottom_right])

          reset_boards
          x_computer.send(:board=, x_started_on_the_side_and_o_is_in_a_corner)
          expect(x_computer.second_move).to eq([:top_left, :top_center, :top_right, :center, :bottom_left, :bottom_center])
        end
      end
    end

    describe '#next_move' do
      it 'returns a symbol indicating the best next move' do
        o_computer.send(:board=, x_moves_first_in_bottom_right_corner)
        expect(o_computer.next_move).to eq(:center)

        reset_boards
        o_computer.send(:board=, x_moves_first_on_side)
        expect(o_computer.next_move).to satisfy{ |move| [:top_right, :top_left, :center, :bottom_center].include? move }

        reset_boards
        o_computer.send(:board=, x_moves_first_in_center)
        expect(o_computer.next_move).to satisfy{ |move| [:top_left, :top_right, :bottom_left, :bottom_right].include? move }

        reset_boards
        o_computer.send(:board=, o_computer_can_win_by_row)
        expect(o_computer.next_move).to eq(:middle_right)

        reset_boards
        o_computer.send(:board=, x_computer_can_win_by_row)
        expect(o_computer.next_move).to eq(:bottom_left)
      end
    end

    describe '#tryna_win?' do
      it 'returns true if the computer can win by row in one move' do
        o_computer.send(:board=, o_computer_can_win_by_row)
        expect(o_computer.tryna_win?).to be true
      end

      it 'returns true if the computer can win by column in one move' do
        o_computer.send(:board=, o_computer_can_win_by_column)
        expect(o_computer.tryna_win?).to be true
      end

      it 'returns true if the computer can win by diagonal in one move' do
        o_computer.send(:board=, o_computer_can_win_by_diagonal)
        expect(o_computer.tryna_win?).to be true
      end

      it 'returns false if the computer can\'t win in one move' do
        o_computer.send(:board=, two_x_moves_one_o_and_x_takes_corners)
        expect(o_computer.tryna_win?).to be false
      end
    end

    describe '#tryna_win' do
      it 'chooses the winning move when the "X" computer can win by row' do
        x_computer.send(:board=, x_computer_can_win_by_row)
        expect(x_computer.tryna_win).to eq([:bottom_left])
      end
      
      it 'chooses the winning move when the "O" computer can win by row' do
        o_computer.send(:board=, o_computer_can_win_by_row)
        expect(o_computer.tryna_win).to eq([:middle_right])
      end
      
      it 'chooses the winning move when the "X" computer can win by column' do
        x_computer.send(:board=, x_computer_can_win_by_column)
        expect(x_computer.tryna_win).to eq([:top_right])
      end
      
      it 'chooses the winning move when the "O" computer can win by column' do
        o_computer.send(:board=, o_computer_can_win_by_column)
        expect(o_computer.tryna_win).to eq([:top_center])
      end
      
      it 'chooses the winning move when the "X" computer can win by diagonal' do
        x_computer.send(:board=, x_computer_can_win_by_diagonal)
        expect(x_computer.tryna_win).to eq([:bottom_right])
      end
      
      it 'chooses the winning move when the "O" computer can win by diagonal' do
        o_computer.send(:board=, o_computer_can_win_by_diagonal)
        expect(o_computer.tryna_win).to eq([:bottom_left])
      end
    end

    describe '#enemy_in_the_corner?' do
      it 'returns true if the enemy is in the corner' do
        o_computer.send(:board=, x_moves_first_in_bottom_right_corner)
        expect(o_computer.enemy_in_the_corner?).to be true
      end
    end

    describe '#enemy_on_the_side?' do
      it 'returns true if the enemy is on the side' do
        o_computer.send(:board=, x_moves_first_on_side)
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

    describe '#neighboring_keys' do
      it 'finds the one to two spaces next to a given space in a row' do
        expect(o_computer.neighboring_keys(:center, "row")).to eq([:middle_left, :middle_right])
        expect(o_computer.neighboring_keys(:top_center, "row")).to eq([:top_left, :top_right])
        expect(o_computer.neighboring_keys(:bottom_center, "row")).to eq([:bottom_left, :bottom_right])
        expect(o_computer.neighboring_keys(:bottom_left, "row")).to eq([:bottom_center])
        expect(o_computer.neighboring_keys(:top_right, "row")).to eq([:top_center])
      end

      it 'finds the one to two spaces next to a given space in a column' do
        expect(o_computer.neighboring_keys(:center, "col")).to eq([:top_center, :bottom_center])
        expect(o_computer.neighboring_keys(:middle_left, "col")).to eq([:top_left, :bottom_left])
        expect(o_computer.neighboring_keys(:middle_right, "col")).to eq([:top_right, :bottom_right])
        expect(o_computer.neighboring_keys(:top_center, "col")).to eq([:center])
        expect(o_computer.neighboring_keys(:bottom_center, "col")).to eq([:center])
        expect(o_computer.neighboring_keys(:top_right, "col")).to eq([:middle_right])
      end
    end

    describe '#defense_necessary?' do
      it 'returns true if the opponent can win in one move' do
        o_computer.send(:board=, x_computer_can_win_by_row)
        expect(o_computer.defense_necessary?).to be true
      end

      it 'returns false if the opponent can\'t win in one move' do
        o_computer.send(:board=, two_x_moves_one_o_and_x_takes_sides)
        expect(o_computer.defense_necessary?).to be false
      end
    end

    describe '#block_them' do
      it 'stops the opponent from winning if they have two marked spaces in a row' do
        o_computer.send(:board=, starting_grid)
        expect(o_computer.block_them).to eq([:middle_left])
      end

      it 'stops the opponent from winning if they have two marked spaces in a row' do
        x_computer.send(:board=, o_computer_can_win_by_diagonal)
        expect(x_computer.block_them).to eq([:bottom_left])
      end
    end

    describe '#side_in_row?' do
      it 'returns true if the side is a \'center\'' do
        expect(x_computer.side_in_row?(:top_center)).to be true
      end

      it 'returns false if the side is a \'middle\'' do
        expect(o_computer.side_in_row?(:middle_left)).to be false
      end
    end

    describe '#side_in_col?' do
      it 'returns true if the side is a \'middle\'' do
        expect(x_computer.side_in_col?(:middle_right)).to be true
      end

      it 'returns false if the side is a \'center\'' do
        expect(o_computer.side_in_col?(:bottom_center)).to be false
      end
    end

    #### O COMPUTER MODULE ####

    describe 'OComputer module' do
      describe '#o_gets_the_middle' do
        it 'returns a strategic move - not in the sides or a corner in an unpopulated row & col - when "X" has adjacent sides and "O" is in the middle' do
          o_computer.send(:board=, o_has_the_center_x_all_up_the_sides)
          expect(o_computer.o_gets_the_middle).to eq([:bottom_left, :bottom_right, :top_left])
        end

        it 'takes a space next to itself in an unobstructed row/col when "X" isn\'t on two sides and "O" is in the middle' do
          o_computer.send(:board=, o_has_the_center_x_in_side_and_corner)
          expect(o_computer.o_gets_the_middle).to eq([:top_center, :bottom_center, :top_left, :bottom_left])
        end
      end

      describe '#surrounding_keys' do
        it 'returns the row/col set that includes the given space' do
          expect(o_computer.surrounding_keys(:bottom_right)).to eq([[:bottom_left, :bottom_center, :bottom_right], [:top_right, :middle_right, :bottom_right]])
          expect(o_computer.surrounding_keys(:center)).to eq([[:middle_left, :center, :middle_right], [:top_center, :center, :bottom_center]])
        end
      end

      describe '#surrounding_values' do
        it 'returns the values of the row/col set that includes the given space' do
          o_computer.send(:board=, x_computer_can_win_by_diagonal)
          expect(o_computer.surrounding_values(:center)).to eq([["X", "X", "O"], ["O", "X", "X"]])
          expect(o_computer.surrounding_values(:top_left)).to eq([["X", "O", " "], ["X", "X", "O"]])
        end
      # { top_left:    "X", top_center:    "O", top_right:    " ",
      #   middle_left: "X", center:        "X", middle_right: "O",
      #   bottom_left: "O", bottom_center: "X", bottom_right: " " }
      end

      describe '#all_in_a_row?' do
        it 'returns true if the given combination is equal to two enemy marks and one computer mark' do
          expect(o_computer.all_in_a_row?(["X", "X", "O"])).to be true
          expect(x_computer.all_in_a_row?(["O", "X", "O"])).to be true
        end

        it 'returns false if the given combination is not equal to two enemy marks and one computer mark' do
          expect(o_computer.all_in_a_row?(["O", "X", "O"])).to be false
        end
      end

      describe '#x_on_the_side_and_corner' do
        context '"X" is in a corner and the middle space directly next to it with "O" taking the third space in the row/col' do 
          it 'returns the set of best strategic moves' do
            o_computer.send(:board=, x_and_o_all_in_a_row)
            expect(o_computer.x_on_the_side_and_corner).to eq([:middle_left, :bottom_left, :center])
          end
        end
      end

      describe '#o_second_move' do
        context '"O" is in a corner, and "X" is in a corner and a side adjacent to "O"' do
          it 'chooses the best strategic move' do
            o_computer.send(:board=, o_in_the_corner_x_in_side_and_other_corner)
            expect(o_computer.o_second_move).to eq([:middle_left, :center])
          end
        end

        context '"O" is in a corner, "X" is in and adjacent side and the opposite corner' do
          it 'chooses the best strategic move' do
            o_computer.send(:board=, o_in_the_corner_x_adjacent_side_and_in_opposite_corner)
            expect(o_computer.o_second_move).to eq([:middle_left, :center])
          end
        end

        context '"O" is in a corner and "X" has both adjacent sides' do
          it 'chooses the best strategic move' do
            o_computer.send(:board=, o_in_the_corner_x_adjacent)
            expect(o_computer.o_second_move).to eq([:bottom_center, :middle_left, :center])
          end
        end

        context '"O" is in the corner and "X" is in two sides - one adjacent, one not quite opposite' do
          it 'chooses the corner inline with itself' do
            o_computer.send(:board=, o_in_the_corner_x_in_two_sides)
            expect(o_computer.o_second_move).to eq([:bottom_right])
          end
        end

        context '"O" is in the center, and "X" is in two corner spots' do
          it 'chooses the best strategic move' do
            o_computer.send(:board=, o_in_the_center_x_in_opposing_corners)
            expect(o_computer.o_second_move).to eq([:top_center, :bottom_center, :middle_left, :middle_right])
          end
        end

        context '"O" is in the center, and "X" is in two sides' do
          it 'chooses the corners when the sides are opposite one another' do
            o_computer.send(:board=, o_in_the_center_x_on_opposing_sides)
            expect(o_computer.o_second_move).to eq([:top_left, :bottom_left, :top_right, :bottom_right])
          end

          it 'chooses corners EXCEPT for the one that doesn\'t have an "X" in its corresponding row and column' do
            o_computer.send(:board=, o_in_the_center_x_on_adjacent_sides)
            expect(o_computer.o_second_move).to eq([:bottom_left, :bottom_right, :top_left])
          end
        end

        context '"O" is in the center, "X" is in a corner and a side"' do
          it 'chooses the best strategic move' do
            o_computer.send(:board=, o_in_the_center_x_flying_askew)
            expect(o_computer.o_second_move).to eq([:top_center, :bottom_center, :top_right, :bottom_right])
          end
        end

        context '"X" is in the center and a side, "O" finishes the row' do
          it 'never takes a side space' do
            o_computer.send(:board=, x_centers_the_row)
            expect(o_computer.o_second_move).to eq([:top_left, :top_right, :bottom_left, :bottom_right])
            expect(o_computer.o_second_move).not_to include(:top_center, :middle_left, :middle_right, :bottom_center)
          end
        end

        context '"O" is on the side, "X" is also on two sides' do
          it 'chooses the best strategic move' do
            o_computer.send(:board=, sides_party)
            expect(o_computer.o_second_move).to eq([:top_left, :top_right])
          end
        end

        context '"O" is on the side, "X" is in an adjacent corner and directly across' do
          it 'chooses the best strategic move' do
            o_computer.send(:board=, o_what_are_you_looking_at)
            expect(o_computer.o_second_move).to eq([:top_left, :top_right, :center])
          end
        end
      end

      describe '#o_third_move' do
        context '"O" has taken the center and a side, "X" is in a corner and two more sides but not in any position to immediately win' do
          it 'returns the best strategic move' do
            o_computer.send(:board=, o_needs_a_third_strategic_move)
            expect(o_computer.o_third_move).to eq([:bottom_left, :bottom_right])
          end
        end

        context '"O" has taken the center and a side, "X" is in a side and two corners but not in any position to immediately win' do
          it 'returns the best strategic move' do
            o_computer.send(:board=, o_tried_to_win)
            expect(o_computer.o_third_move).to eq([:top_right, :bottom_right])
          end
        end

        it 'takes the center if the center is empty and "X" is in two corners' do
          o_computer.send(:board=, o_needs_to_take_center)
          expect(o_computer.o_third_move).to eq([:center])
        end
      end
    end
  end

  #### CONTROLLED BOARDS ###

  def reset_boards
    o_computer.send(:board=, nil)
    x_computer.send(:board=, nil)
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

#### X FIRST MOVES ####

  def o_makes_the_first_move
    board.grid[:bottom_left] = "O"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    " ",
    #   middle_left: " ", center:        " ", middle_right: " ",
    #   bottom_left: "O", bottom_center: " ", bottom_right: " " }
  end
  
#### O FIRST MOVES ####

  def x_moves_first_in_center
    board.grid[:center] = "X"
    board.grid
  end

  def x_moves_first_on_side
    board.grid[:top_center] = "X"
    board.grid
  end

  def x_moves_first_in_bottom_right_corner
    board.grid[:bottom_right] = "X"
    board.grid
  end

#### X SECOND MOVES ####

  def x_started_in_the_center_and_o_took_a_side
    board.grid[:center] = "X"
    board.grid[:middle_right] = "O"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    " ",
    #   middle_left: " ", center:        "X", middle_right: "O",
    #   bottom_left: " ", bottom_center: " ", bottom_right: " " }
  end

  def x_started_in_a_corner_and_o_takes_a_side
    board.grid[:bottom_right] = "X"
    board.grid[:middle_right] = "O"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    " ",
    #   middle_left: " ", center:        " ", middle_right: "O",
    #   bottom_left: " ", bottom_center: " ", bottom_right: "X" }
  end

  def x_started_in_a_corner_and_o_took_center
    board.grid[:bottom_right] = "X"
    board.grid[:center] = "O"
    board.grid
  end

  def x_started_in_a_corner_and_o_took_a_corner
    board.grid[:bottom_right] = "X"
    board.grid[:top_right] = "O"
    board.grid
  end

  def x_started_on_the_side_and_o_is_in_the_center
    board.grid[:middle_left] = "X"
    board.grid[:center] = "O"
    board.grid
  end

  def x_started_on_the_side_and_o_is_in_a_corner
    board.grid[:middle_left] = "X"
    board.grid[:bottom_right] = "O"
    board.grid
  end

#### O SECOND MOVES ####
  def two_x_moves_one_o_and_x_takes_corners
    board.grid[:top_right] = "X"
    board.grid[:center] = "O"
    board.grid[:bottom_left] = "X"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    "X",
    #   middle_left: " ", center:        "O", middle_right: " ",
    #   bottom_left: "X", bottom_center: " ", bottom_right: " " }
  end

  def two_x_moves_one_o_and_x_takes_sides
    board.grid[:top_center] = "X"
    board.grid[:center] = "O"
    board.grid[:bottom_left] = "X"
    board.grid
    # { top_left:    " ", top_center:    "X", top_right:    " ",
    #   middle_left: " ", center:        "O", middle_right: " ",
    #   bottom_left: "X", bottom_center: " ", bottom_right: " " }
  end

  def two_x_moves_one_o_and_x_takes_center
    board.grid[:center] = "X"
    board.grid[:middle_right] = "X"
    board.grid[:bottom_right] = "O"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    " ",
    #   middle_left: " ", center:        "X", middle_right: "X",
    #   bottom_left: " ", bottom_center: " ", bottom_right: "O" }
  end

  def o_has_the_center_x_all_up_the_sides
    board.grid[:middle_left] = "X"
    board.grid[:center] = "O"
    board.grid[:bottom_center] = "X"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    " ",
    #   middle_left: "X", center:        "O", middle_right: " ",
    #   bottom_left: " ", bottom_center: "X", bottom_right: " " }
  end

  def o_has_the_center_x_in_side_and_corner
    board.grid[:middle_left] = "X"
    board.grid[:center] = "O"
    board.grid[:bottom_right] = "X"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    " ",
    #   middle_left: "X", center:        "O", middle_right: " ",
    #   bottom_left: " ", bottom_center: " ", bottom_right: "X" }
  end

  def x_and_o_all_in_a_row
    board.grid[:top_right] = "X"
    board.grid[:top_center] = "X"
    board.grid[:top_left] = "O"
    board.grid
  end

  def o_in_the_corner_x_in_side_and_other_corner
    board.grid[:middle_right] = "X"
    board.grid[:bottom_left] = "X"
    board.grid[:bottom_right] = "O"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    " ",
    #   middle_left: " ", center:        " ", middle_right: "X",
    #   bottom_left: "X", bottom_center: " ", bottom_right: "O" }
  end

  def o_in_the_corner_x_adjacent_side_and_in_opposite_corner
    board.grid[:top_left] = "X"
    board.grid[:middle_right] = "X"
    board.grid[:bottom_right] = "O"
    board.grid
    # { top_left:    "X", top_center:    " ", top_right:    " ",
    #   middle_left: " ", center:        " ", middle_right: "X",
    #   bottom_left: " ", bottom_center: " ", bottom_right: "O" }
  end

  def o_in_the_corner_x_in_two_sides
    board.grid[:top_center] = "X"
    board.grid[:top_right] = "O"
    board.grid[:middle_left] = "X"
    board.grid
    # { top_left:    " ", top_center:    "X", top_right:    "O",
    #   middle_left: "X", center:        " ", middle_right: " ",
    #   bottom_left: " ", bottom_center: " ", bottom_right: " " }
  end

  def o_in_the_corner_x_adjacent
    board.grid[:top_center] = "X"
    board.grid[:top_right] = "O"
    board.grid[:middle_right] = "X"
    board.grid
    # { top_left:    " ", top_center:    "X", top_right:    "O",
    #   middle_left: " ", center:        " ", middle_right: "X",
    #   bottom_left: " ", bottom_center: " ", bottom_right: " " }
  end

  def o_in_the_center_x_flying_askew
    board.grid[:center] = "O"
    board.grid[:bottom_left] = "X"
    board.grid[:middle_right] = "X"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    " ",
    #   middle_left: " ", center:        "O", middle_right: "X",
    #   bottom_left: "X", bottom_center: " ", bottom_right: " " }
  end

  def o_in_the_center_x_in_opposing_corners
    board.grid[:center] = "O"
    board.grid[:top_right] = "X"
    board.grid[:bottom_left] = "X"
    board.grid
  end

  def o_in_the_center_x_on_opposing_sides
    board.grid[:center] = "O"
    board.grid[:middle_left] = "X"
    board.grid[:middle_right] = "X"
    board.grid
  end

  def o_in_the_center_x_on_adjacent_sides
    board.grid[:center] = "O"
    board.grid[:middle_left] = "X"
    board.grid[:bottom_center] = "X"
    board.grid
  end

  def x_centers_the_row
    board.grid[:top_center] = "X"
    board.grid[:center] = "X"
    board.grid[:bottom_center] = "O"
    board.grid
    # { top_left:    " ", top_center:    "X", top_right:    " ",
    #   middle_left: " ", center:        "X", middle_right: " ",
    #   bottom_left: " ", bottom_center: "O", bottom_right: " " }
  end

  def sides_party
    board.grid[:top_center] = "X"
    board.grid[:middle_right] = "X"
    board.grid[:bottom_center] = "O"
    board.grid
    # { top_left:    " ", top_center:    "X", top_right:    " ",
    #   middle_left: " ", center:        " ", middle_right: "X",
    #   bottom_left: " ", bottom_center: "O", bottom_right: " " }
  end

  def o_what_are_you_looking_at
    board.grid[:top_center] = "X"
    board.grid[:bottom_center] = "O"
    board.grid[:bottom_right] = "X"
    board.grid
    # { top_left:    " ", top_center:    "X", top_right:    " ",
    #   middle_left: " ", center:        " ", middle_right: " ",
    #   bottom_left: " ", bottom_center: "O", bottom_right: "X" }
  end

#### O THIRD MOVES ####
  def o_needs_a_third_strategic_move
    board.grid[:top_left] = "X"
    board.grid[:top_center] = "O"
    board.grid[:center] = "O"
    board.grid[:middle_right] = "X"
    board.grid[:bottom_center] = "X"
    board.grid
    # { top_left:    "X", top_center:    "O", top_right:    " ",
    #   middle_left: " ", center:        "O", middle_right: "X",
    #   bottom_left: " ", bottom_center: "X", bottom_right: " " }
  end

  def o_tried_to_win
    board.grid[:top_left] = "X"
    board.grid[:middle_left] = "O"
    board.grid[:center] = "O"
    board.grid[:middle_right] = "X"
    board.grid[:bottom_left] = "X"
    board.grid
    # { top_left:    "X", top_center:    " ", top_right:    " ",
    #   middle_left: "O", center:        "O", middle_right: "X",
    #   bottom_left: "X", bottom_center: " ", bottom_right: " " }
  end

  def o_needs_to_take_center
    board.grid[:top_right] = "X"
    board.grid[:middle_left] = "X"
    board.grid[:middle_right] = "O"
    board.grid[:bottom_left] = "O"
    board.grid[:bottom_right] = "X"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    "X",
    #   middle_left: "X", center:        " ", middle_right: "O",
    #   bottom_left: "O", bottom_center: " ", bottom_right: "X" }
  end

#### X CAN WIN ####
  def x_computer_can_win_by_row
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

  def x_computer_can_win_by_column
    board.grid[:center] = "O"
    board.grid[:middle_right] = "X"
    board.grid[:bottom_right] = "X"
    board.grid
    # { top_left:    " ", top_center:    " ", top_right:    " ",
    #   middle_left: " ", center:        "O", middle_right: "X",
    #   bottom_left: " ", bottom_center: " ", bottom_right: "X" }
  end

  def x_computer_can_win_by_diagonal
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
    
#### O CAN WIN ####
  def o_computer_can_win_by_row
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

  def o_computer_can_win_by_column
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

  def o_computer_can_win_by_diagonal
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
end
