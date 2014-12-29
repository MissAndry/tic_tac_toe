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
    grid.values.each_slice(3).to_a
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

  def to_s
    full_board = []
    rows.each{ |row| full_board << PADDING + row.join(COLUMN_BREAK) }
    full_board.join(BREAKER)
  end
end
