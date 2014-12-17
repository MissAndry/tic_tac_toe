require 'pry'

module ComputerAI
  def find_empty_spaces(board_grid)
    board_grid.select{ |key| board_grid[key] == " " }
  end

  def first_move(board_grid)
    return [:center] if (board_grid[:center] == " " && board_grid.values.include?("X"))
    [:top_left, :top_right, :bottom_left, :bottom_right]
  end

  def next_move(board_grid)
    moves = []
    all_combinations = grid_rows(board_grid) + grid_cols(board_grid) + grid_diag(board_grid)
    moves << defend(all_combinations)
    moves << defend(all_combinations, "X")
    moves << defend(all_combinations, "X", " ")

    moves.each { |move| return move if move.class == Symbol }
    return first_move(board_grid).sample
  end

  def defend(all_combinations, marker=space, blank_space=nil)
    blank_space = marker if blank_space.nil? # the idea is to pass in a " " when you're searching for a move in a started yet sparsely populated board, but you need a test first! Then, up above, save the output of all of these things //(plus the starting move)// and return the one that is a symbol (because it'll return the whole array if it doesn't match anything)
    # SO: TODO - figure out some strategy past choosing a corner space
    # You can probably do it
    # Soon you should make views and test that it works with a dynamically created board
    all_combinations.each do |combo|
      if combo.flatten.values_at(1, 3, 5).sort == [" ", blank_space, marker]
        combo.select{ |pair| return pair[0] if pair[1] == " " }
      end
    end
  end

  def grid_rows(grid_keys_or_vals)
    grid_keys_or_vals.each_slice(3).to_a
  end

  def grid_cols(grid_keys_or_vals)
    grid_rows(grid_keys_or_vals).transpose
  end

  def grid_diag(grid_keys_or_vals)
    diags = []
    diags << grid_rows(grid_keys_or_vals).map.with_index { |val, i| val[i] }
    diags << grid_rows(grid_keys_or_vals).map.with_index(1) { |val, i| val[-i] }
    diags
  end
end
