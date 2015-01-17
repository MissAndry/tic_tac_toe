require 'pry'

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

  def to_s
    full_board = []
    rows.each{ |row| full_board << PADDING + row.join(COLUMN_BREAK) }
    full_board.join(BREAKER)
  end

  private

  def grid=(new_grid)
    @grid = new_grid
  end
end
