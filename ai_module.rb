require 'pry'

module ComputerAI
  def next_move(board_grid)
    if first_move?(board_grid)
      return first_move(board_grid).sample 
    elsif second_move?(board_grid)
      second = second_move(board_grid).sample
      binding.pry
      return second
    else
      later = later_moves(board_grid)
      binding.pry
      return later
    end
  end

  def enemy_marker
    return "X" if self.space == "O"
    return "O" if self.space == "X"
  end

  def taken_spaces(board_grid)
    board_grid.keys.select{ |key| board_grid[key] != " "}
  end

  def corner_spaces(board_grid)
    diagonals = grid_diag(board_grid)
    corners = diagonals.map{ |row| [row.first, row.last] }
    corners.flatten
  end

  def find_opposing_diagonal(board_grid, marker=enemy_marker)
    diagonals = grid_diag(board_grid)
    marked_row = diagonals.select{ |diag| diag.flatten.include?(marker) }.pop
    return if marked_row.nil?
    return marked_row.last if marked_row.last.include?(" ")
    marked_row.first
  end

  def later_moves(board_grid)
    return [:center] if board_grid[:center] == " "
    return final_move(board_grid) if final_move?(board_grid)
    all_combinations = all_rows_columns_diagonal_combos(board_grid)
    potential_moves = get_next_moves(all_combinations)
    potential_moves.each{ |move| return move if move.class == Symbol }
  end

  def defend(all_combinations, marker=self.space, blank_space=nil)
    blank_space = marker if blank_space.nil? 
    all_combinations.each do |combo|
      if combo.flatten.values_at(1, 3, 5).sort == [" ", blank_space, marker]
        combo.each{ |pair| return pair[0] if pair[1] == " " }
      end
    end
  end

  def first_move?(board_grid)
    board_grid.values.count(space) == 0
  end

  def first_move(board_grid)
    if corner_spaces(board_grid).include? enemy_marker
      return [:center]
    elsif board_grid[:center] == enemy_marker
      [:top_left, :top_right, :bottom_left, :bottom_right]
    elsif side_spaces(board_grid).include? enemy_marker
      player_went_side_first(board_grid) - taken_spaces(board_grid)
    else
      board_grid.keys
    end
  end

  def second_move?(board_grid)
    board_grid.values.count(space) == 1
  end

  def second_move(board_grid)
    next_move = []
    sides = side_spaces(board_grid)
    corners = corner_spaces(board_grid)
    taken = taken_spaces(board_grid)
    all_combinations = all_rows_columns_diagonal_combos(board_grid)
    defense = defend(all_combinations, enemy_marker)
    
    if defense.is_a? Symbol
      next_move << defense
    elsif sides.count(enemy_marker) == 2 && !corners.include?(space)
      sides = neighboring_corner(board_grid)
      next_move = sides - taken
    elsif board_grid[opposite_center(board_grid, space).pop] == enemy_marker
      next_move = board_grid.keys - [:center]
      next_move -= taken
      binding.pry
    elsif corners.include?(enemy_marker) && !board_grid[:center] == " "
      marker = ""
      if !sides.include?(space)
        marker = space
      else
        marker = enemy_marker
      end

      sides = side_rows_and_cols(board_grid)
      move = sides.select{ |side| side.flatten.values_at(1, 3, 5).sort == [" ", " ", marker] }.flatten.values_at(0, 2, 4)
      binding.pry
      next_move << move.first if board_grid[move.first] == " "
      next_move << move.last if board_grid[move.last] == " "
    elsif board_grid[:center] == enemy_marker && corners.include?(space)
      sides += find_opposing_diagonal(board_grid, space)
      next_move = sides.values_at(0, 2, 4, 6, 8) - taken
    elsif sides.include?(space) && board_grid[:center] == enemy_marker
      next_move = board_grid.keys - opposite_center(board_grid, space)
      binding.pry

      next_move -= taken
      binding.pry
    else
      next_move = board_grid.keys - taken
    end
    return next_move
  end

  def final_move?(board_grid)
    board_grid.values.count(self.space) == board_grid.length/2
  end

  def final_move(board_grid)
    board_grid.keys.each{ |key| return key if board_grid[key] == " " }
  end

  def center_empty?(board_grid)
    board_grid[:center] == " "
  end

  def get_next_moves(all_combinations)
    moves = []
    moves << defend(all_combinations)
    moves << defend(all_combinations, enemy_marker)
    moves << defend(all_combinations, enemy_marker, " ")
    moves << defend(all_combinations, enemy_marker, self.space)
    moves
  end

  def all_rows_columns_diagonal_combos(board_grid)
    grid_diag(board_grid) + grid_cols(board_grid) + grid_rows(board_grid)
  end

  def grid_rows(board_grid)
    board_grid.each_slice(3).to_a
  end

  def grid_cols(board_grid)
    grid_rows(board_grid).transpose
  end

  def grid_diag(board_grid)
    diags = []
    diags << grid_rows(board_grid).map.with_index { |val, i| val[i] }
    diags << grid_rows(board_grid).map.with_index(1) { |val, i| val[-i] }
    diags
  end

  def neighboring_corner(board_grid)
    spaces = []
    corners = corner_spaces(board_grid).flatten.values_at(0, 2, 4, 6)
    no_center = side_rows_and_cols(board_grid)
    
    corners.each do |corner|
      no_center.each do |combo|
        if combo.flatten.include?(corner) && combo.flatten.include?(enemy_marker)
          spaces << corner
        end
      end
    end
    return spaces
  end

  def neighboring_side(board_grid)
    spaces = []
    sides = side_spaces(board_grid).flatten.values_at(0, 2, 4, 6)
    no_center = side_rows_and_cols(board_grid)

    sides.each do |side|
      no_center.each do |combo|
        if combo.flatten.include?(side) && combo.flatten.include?(space)
          spaces << side
        end
      end
    end
    return spaces
  end

  def side_rows_and_cols(board_grid)
    rows = grid_rows(board_grid)
    cols = grid_cols(board_grid)
    
    no_center = []
    no_center += rows.select{ |row| !row.flatten.include?(:center) }
    no_center += cols.select{ |col| !col.flatten.include?(:center) }
    no_center
  end

  def side_spaces(board_grid)
    sides = []
    sides << grid_rows(board_grid).first[1]
    sides << grid_cols(board_grid).first[1]
    sides << grid_cols(board_grid).last[1]
    sides << grid_rows(board_grid).last[1]
    sides.flatten
  end

  def furthest_corners(board_grid, marker=enemy_marker)
    opposite = []
    rows = grid_rows(board_grid)
    cols = grid_cols(board_grid)

    if rows.first[1].include? marker
      opposite += rows.first
    elsif rows.last[1].include? marker
      opposite += rows.last
    elsif cols.first[1].include? marker
      opposite += cols.first
    elsif cols.last[1].include? marker
      opposite += cols.last
    end
    
    unless opposite.empty?
      return opposite.flatten.values_at(0, 4)
    end
    opposite
  end

  def opposite_center(board_grid, marker=enemy_marker)
    rows = []
    cols = []
    opposite = []
    sides = side_rows_and_cols(board_grid)
    rows << sides[0].flatten
    rows << sides[1].flatten
    cols << sides[2].flatten
    cols << sides[3].flatten

    opposite << rows.first[2] if rows.last.include?(marker)
    opposite << rows.last[2] if rows.first.include?(marker)
    opposite << cols.first[2] if cols.last.include?(marker)
    opposite << cols.last[2] if cols.first.include?(marker)

    opposite
  end

  def player_went_side_first(board_grid)
    starting_point = []
    rows = grid_rows(board_grid)
    cols = grid_cols(board_grid)
    opposite = furthest_corners(board_grid)
    starting_point << rows[1].first.first if rows[1].last.last == enemy_marker
    starting_point << rows[1].last.first  if rows[1].first.last == enemy_marker
    starting_point << cols[1].first.first if cols[1].last.last == enemy_marker
    starting_point << cols[1].last.first  if cols[1].first.last == enemy_marker
    
    starting_point + opposite + [:center]
  end
end
