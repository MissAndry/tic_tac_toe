class Board
  COLUMN_BREAK = " | "
  PADDING = " " * 22
  BREAKER = "\n" + PADDING + ("-" * 9) + "\n"
  def initialize
    @grid = grid
  end

  def grid
    @grid ||= {top_left:    " ", top_center:    " ", top_right:    " ",
               middle_left: " ", center:        " ", middle_right: " ",
               bottom_left: " ", bottom_center: " ", bottom_right: " "}
  end

  def rows
    grid.each_slice(3).to_a
  end

  def columns
    rows.transpose
  end

  def diagonals
    diagonal = []
    diagonal << rows.map.with_index { |key, index| key[index] }
    diagonal << rows.map.with_index(1) { |key, index| key[-index] }
    diagonal
  end

  def sides
    go_through = rows + columns
    go_through.map { |side| side[1] unless side[1].include? :center }.compact
  end

  def corners
    corner = []
    corner << rows.first.first
    corner << rows.first.last
    corner << rows.last.first
    corner << rows.last.last
    corner
  end

  def row_values
    grid.values.each_slice(3).to_a
  end

  def row_keys
    grid.keys.each_slice(3).to_a
  end

  def col_values
    row_values.transpose
  end

  def col_keys
    row_keys.transpose
  end

  def diag_values
    diagonal = []
    diagonal << row_values.map.with_index{ |v, i| v[i] }
    diagonal << row_values.map.with_index(1){ |v, i| v[-i] }
    diagonal
  end

  def diag_keys
    diagonal = []
    diagonal << row_keys.map.with_index{ |v, i| v[i] }
    diagonal << row_keys.map.with_index(1){ |v, i| v[-i] }
    diagonal
  end

  def corner_values
    corners.flatten.values_at(1, 3, 5, 7)
  end

  def corner_keys
    corners.flatten.values_at(0, 2, 4, 6)
  end

  def side_values
    sides.flatten.values_at(1, 3, 5, 7)
  end

  def side_keys
    sides.flatten.values_at(0, 2, 4, 6)
  end

  def empty?
    grid.values.all? { |space| space == " " }
  end

  def find_sides(marker)
    side_keys.select{ |side| grid[side] == marker }
  end

  def find_corner(marker)
    corner_keys.select{ |corner| grid[corner] == marker }
  end

  def find_opposing_side(marker)
    side = marker if marker.is_a? Symbol
    side = find_sides(marker) if marker.is_a? String
    if side.to_s.include?("center")
      column = col_keys[1]
      return column.first if side.to_s.include?("bottom")
      return column.last
    else
      row = row_keys[1]
      return row.first if side.to_s.include?("right")
      return row.last
    end
  end

  def neighboring_keys(key, direction)
    case direction
    when "row"
      dir = row_keys
    when "col"
      dir = col_keys
    end

    neighbor = []
    dir.each do |segment|
      segment.each_with_index do |val, index|
        neighbor << segment[index - 1] if val == key && index > 0
        neighbor << segment[index + 1] if val == key && index < segment.length
      end
    end
    neighbor.compact
  end

  def row_neighbor(side)
    neighboring_keys(side, "row")
  end

  def col_neighbor(side)
    neighboring_keys(side, "col")
  end

  def find_row_neighbors(side_collection)
    side_collection.map{ |side| row_neighbor(side) }
  end

  def find_col_neighbors(side_collection)
    side_collection.map{ |side| col_neighbor(side) }
  end

  def surrounding_keys(key)
    (row_keys + col_keys).select{ |keys| keys.include? key }
  end

  def surrounding_values(starting_key)
    row_keys = surrounding_keys(starting_key)
    values = []
    row_keys.each do |set|
      values << set.map{ |key| grid[key] }
    end
    values
  end

  def side_in_col?(side)
    side.to_s.include?("middle")
  end

  def side_in_row?(side)
    side.to_s.include?("center")
  end

  def to_s
    full_board = []
    row_values.each{ |row| full_board << PADDING + row.join(COLUMN_BREAK) }
    full_board.join(BREAKER)
  end

  private

  def grid=(new_grid)
    @grid = new_grid
  end
end
