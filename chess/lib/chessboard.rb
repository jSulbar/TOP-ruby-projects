# Chessboard class
class Chessboard
  attr_accessor :position, :board_size

  def initialize(position = [2, 3], board_size = 8, free_movement: false)
    @free_movement = free_movement
    @board = Array.new(board_size) { Array.new(board_size, false) }
    @position = position
    @valid_moves = moves_at_pos(*@position)
  end

  def tile_char(row, column)
    if @position[0] == row && @position[1] == column
      'KNI'
    elsif @valid_moves.include?([row, column])
      '-X-'
    elsif white?(row, column)
      '|||'
    else
      '   '
    end
  end

  def print_board
    print "   #{(0..@board.length - 1).to_a.join('  ')}\n"

    @board.each_index do |row|
      print "#{row} "
      @board[row].each_index do |column|
        print tile_char(row, column)
      end
      puts
    end
  end

  def move(row, column)
    return if !@free_movement && !@valid_moves.include?([row, column])

    @board[@position[0]][@position[1]] = false
    @position = [row, column]
    @valid_moves = moves_at_pos(*@position)
    @board[row][column] = true
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

  def moves_at_pos(row, column)
    [
      tile_tuple(row + 1, column + 2), tile_tuple(row - 1, column + 2),
      tile_tuple(row + 1, column - 2), tile_tuple(row - 1, column - 2),
      tile_tuple(row + 2, column + 1), tile_tuple(row - 2, column + 1),
      tile_tuple(row + 2, column - 1), tile_tuple(row - 2, column - 1)
    ].compact
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

  def random_pos
    [rand(0..7), rand(0..7)]
  end
end
