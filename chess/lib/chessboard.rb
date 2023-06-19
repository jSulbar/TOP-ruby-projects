require './lib/pieces/king'

# Chessboard class
class Chessboard
  attr_accessor :board_size, :board

  def initialize(board_size = 8)
    @board = Array.new(board_size) { Array.new(board_size, nil) }
  end

  def tile_char(row, column)
    if white?(row, column)
      "\u001b[47m\u001b[30m#{@board[row][column] || ' '} \u001b[0m\u001b[0m"
    else
      "\u001b[100m\u001b[30m#{@board[row][column] || ' '} \u001b[0m\u001b[0m"
    end
  end

  def tiles_covered(color)
    res = []
    @board.each_index do |row|
      @board[row].each_index do |column|
        piece = @board[row][column]
        next if piece.nil?

        res += piece.available_tiles([row, column], self) if piece.color == color
      end
    end
    res
  end

  def enemy_piece?(color, row, column)
    !@board[row][column].nil? && @board[row][column].color != color
  end

  def ally_piece?(color, row, column)
    !@board[row][column].nil? && @board[row][column].color == color
  end

  def to_s
    str = "  #{('a'..'z').to_a[0..@board.length - 1].join(' ')}\n"

    @board.each_index do |row|
      str += "#{(row - @board.length).abs} "
      @board[row].each_index do |column|
        str += tile_char(row, column)
      end
      str += "\n"
    end
    str
  end

  def index_from_notation(position)
    tile_tuple((position[1].to_i - @board.length).abs,
               ('a'..'z').to_a.index(position[0]))
  end

  def move_data(notation)
    [notation[0],
     index_from_notation(notation[1..2]),
     index_from_notation(notation[3..4])]
  end

  def off_bounds?(coord)
    # Board will have symmetrical size so just 1 coordinate
    # needs to be tested.
    coord > @board.length - 1 || coord.negative?
  end

  def tile_tuple(row, column)
    return if off_bounds?(row) || off_bounds?(column)

    [row, column]
  end

  def white?(row, column)
    row += 1
    column += 1

    !(row % 2).zero? && !(column % 2).zero? ||
      (row % 2).zero? && (column % 2).zero?
  end

  def black?(row, column)
    !white?(row, column)
  end

  def empty?
    @board.map(&:compact).flatten == []
  end

  def [](subscript)
    @board[subscript]
  end

  def []=(subscript, val)
    @board[subscript] = val
  end
end
