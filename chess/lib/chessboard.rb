# Chessboard class
class Chessboard
  attr_accessor :board_size, :board

  def initialize(board_size = 8)
    @board = Array.new(board_size) { Array.new(board_size, nil) }
  end

  def tile_char(row, column, piece = ' ')
    if white?(row, column)
      "\u001b[47m\u001b[30m#{piece} \u001b[0m\u001b[0m"
    else
      "\u001b[100m\u001b[30m#{piece} \u001b[0m\u001b[0m"
    end
  end

  def print_board
    print "  #{('a'..'z').to_a[0..@board.length - 1].join(' ')}\n"

    @board.each_index do |row|
      print "#{(row - @board.length).abs} "
      @board[row].each_index do |column|
        print tile_char(row, column)
      end
      puts
    end
  end

  def index_from_notation(position)
    tile_tuple((position[1].to_i - @board.length).abs,
               ('a'..'z').to_a.index(position[0]))
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

  def [](subscript)
    @board[subscript]
  end

  def []=(subscript, val)
    @board[subscript] = val
  end
end
