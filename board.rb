class Board
  COLUMN_BREAK = " | "
  BREAKER = "\n" + ("-" * 9) + "\n"
  def initialize
    @grid = grid
  end

  def grid
    @grid ||= {top_left:    " ", top_center:    " ", top_right:    " ",
               middle_left: " ", center:        " ", middle_right: " ",
               bottom_left: " ", bottom_center: " ", bottom_right: " "}
  end

  def rows
    rowed = []
    grid.values.each_slice(3){ |val| rowed << val }
    rowed
  end

  def columns
    rows.transpose
  end

  def diagonals
    diagonal = []
    diagonal << [grid[:top_left], grid[:center], grid[:bottom_right]]
    diagonal << [grid[:top_right], grid[:center], grid[:bottom_left]]
    diagonal
  end

  def to_s
    full_board = []
    rows.each{ |row| full_board << row.join(COLUMN_BREAK) }
    full_board.join(BREAKER)
  end
end
