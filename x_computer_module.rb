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
    else
      if grid[:center] == enemy_marker || board.corner_values.include?(enemy_marker)
        return go_anywhere - [board.find_opposing_side(marker)]
      end
    end
    go_anywhere
  end
end