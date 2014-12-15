class Game
  COLUMN_BREAK = " | "
  BREAKER = "\n" + ("-" * 9) + "\n"
  def initialize
    super
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

  def to_s
    full_board = []
    rows.each{ |row| full_board << row.join(COLUMN_BREAK) }
    full_board.join(BREAKER)
  end

  def mark_space(where)
    where = add_underscore(where)
    grid[where.to_sym] = "X"
  end

  def add_underscore(str)
    str.gsub(" ", "_")
  end
end