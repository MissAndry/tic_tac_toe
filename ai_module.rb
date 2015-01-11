require 'pry'

module ComputerAI
  def enemy_marker
    return "X" if self.space == "O"
    return "O" if self.space == "X"
  end

  def empty?(board_grid)
    board_grid.values.all? { |space| space == " " }
  end

  def taken_spaces(board_grid)
    board_grid.keys.select{ |key| board_grid[key] != " "}
  end

  def corner_spaces(board_grid)
    diagonals = grid_diag(board_grid.values)
    corners = diagonals.map{ |row| [row.first, row.last] }
    corners.flatten
  end

  def find_opposing_diagonal(board_grid)
    diagonals = grid_diag(board_grid)
    marked_row = diagonals.select{ |diag| diag.flatten.include?(enemy_marker) }.pop
    return if marked_row.nil?
    return marked_row.last if marked_row.last.include?(" ")
    marked_row.first
  end

  def later_moves(board_grid)
    all_combinations = all_rows_columns_diagonal_combos(board_grid)
    potential_moves = get_next_moves(all_combinations)
    potential_moves.each { |move| return move if move.class == Symbol }
  end

  def next_move(board_grid)
    if first_move?(board_grid)
      return first_move(board_grid).sample 
    elsif second_move?(board_grid)
      second = second_move(board_grid).sample 
      return second
    else
      return later_moves(board_grid)
    end
  end

  def defend(all_combinations, marker=self.space, blank_space=nil)
    blank_space = marker if blank_space.nil? 
    all_combinations.each do |combo|
      if combo.flatten.values_at(1, 3, 5).sort == [" ", blank_space, marker]
        combo.select{ |pair| return pair[0] if pair[1] == " " }
      end
    end
    nil
  end

  def first_move?(board_grid)
    board_grid.values.count(enemy_marker) <= 1
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
    board_grid.values.count(enemy_marker) == 2
  end

  def second_move(board_grid)
    all_combinations = all_rows_columns_diagonal_combos(board_grid)
    defense = defend(all_combinations, enemy_marker)
    if center_empty?(board_grid)
      [:center]
    elsif !defense.nil?
      [defense]
    else
      sides = side_spaces(board_grid).values_at(0, 2, 4, 6)
      sides - taken_spaces(board_grid)
    end
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

  def neighboring_space(board_grid)
    sides = side_spaces(board_grid).values_at(0, 2, 4, 6) 
    corners = grid_diag(board_grid).flatten.values_at(0, 2, 4, 6)
    
    corners.each.with_index { |value, index| return [sides[index]] if board_grid[value] == enemy_marker }
  end

  def side_spaces(board_grid)
    sides = []
    sides << grid_rows(board_grid).first[1]
    sides << grid_cols(board_grid).first[1]
    sides << grid_cols(board_grid).last[1]
    sides << grid_rows(board_grid).last[1]
    sides.flatten
  end

  def find_opposing_side(board_grid)
    opposite = []
    rows = grid_rows(board_grid)
    cols = grid_cols(board_grid)

    if rows.first[1].include? enemy_marker
      opposite += rows.first
    elsif rows.last[1].include? enemy_marker
      opposite += rows.last
    elsif cols.first[1].include? enemy_marker
      opposite += cols.first
    elsif cols.last[1].include? enemy_marker
      opposite += cols.last
    end
    
    unless opposite.empty?
      return opposite.flatten.values_at(0, 4)
    end
    opposite
  end

  def player_went_side_first(board_grid)
    starting_point = []
    rows = grid_rows(board_grid)
    cols = grid_cols(board_grid)
    opposite = find_opposing_side(board_grid)
    starting_point << rows[1].first.first if rows[1].last.last == enemy_marker
    starting_point << rows[1].last.first  if rows[1].first.last == enemy_marker
    starting_point << cols[1].first.first if cols[1].last.last == enemy_marker
    starting_point << cols[1].last.first  if cols[1].first.last == enemy_marker
    
    starting_point + opposite + [:center]
  end
end
