require 'pry'

module XComputer
  def x_second_move
    if grid[:center] == marker
      if board.side_values.include? enemy_marker
        return go_anywhere - [board.find_opposing_side(enemy_marker)]
      end
    
    elsif board.corner_values.include? marker
      if board.side_values.include? enemy_marker
        return (board.corner_keys - marked_spaces - column_including(enemy_marker)) + [:center]
      elsif board.corner_values.flatten.include? enemy_marker
        return board.corner_keys - marked_spaces
      end
    
    elsif grid[:center] == enemy_marker
      return go_anywhere - [board.find_opposing_side(marker)]
    
    elsif board.corner_values.include? enemy_marker 
      side = board.find_sides(marker).pop
      surr = board.surrounding_values(side)

      if board.side_values.include?(marker) && surr.any?{ |combo| combo.include?(enemy_marker) }
        opposite = board.find_opposing_side(side)
        surr_keys = board.surrounding_keys(opposite)
        move = surr_keys.select{ |combo| !combo.include?(:center) }.pop
        return move - board.side_keys
      end
      
      return go_anywhere - [board.find_opposing_side(marker)]
    end
    go_anywhere
  end

  def x_third_move
    if enemy_on_the_side?
      enemy_side = board.find_sides(enemy_marker)
      moves = board.find_col_neighbors(enemy_side) if board.side_in_col?(enemy_side)
      moves = board.find_row_neighbors(enemy_side) if board.side_in_row?(enemy_side)
    elsif enemy_in_the_corner?
      moves = board.corner_keys - marked_spaces
    end
    return [:center] if grid[:center] == " " && moves.nil?
    return moves.flatten - marked_spaces unless moves.nil?
    go_anywhere
  end
end