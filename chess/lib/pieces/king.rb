require './lib/pieces/piece'

class King
  include Piece

  def initialize(color)
    @color = color
    @char = { white: '♔', black: '♚' }
    @notation = 'K'
    @continuous_movement = false
    @move_list = make_movelist([-1, 0, 1].repeated_permutation(2).to_a.filter do |coord|
      coord != [0, 0]
    end)
  end

  def available_tiles(pos, board, tiles_covered: nil)
    if tiles_covered
      super(pos, board).filter { |tile| !tiles_covered.include?(tile) }
    else
      super(pos, board)
    end
  end

  def starting_row
    @color == :white ? 7 : 0
  end

  def can_castle?(board, queenside: false, tiles_covered: nil)
    king_row = starting_row
    rook_column = queenside ? 0 : 7
    empty_columns = queenside ? [1, 2, 3] : [5, 6]
    king_columns = queenside ? [2, 3, 4] : [4, 5, 6]

    return false if @moved == true || board[king_row][rook_column]&.moved == true
    return false if tiles_covered.intersect?(king_columns.map { |i| [king_row, i] })
    return false unless board[king_row][empty_columns[0]..empty_columns[1]].all?(nil)

    true
  end

  def castle(board, queenside)
    king_row = starting_row
    rook_column = queenside ? 0 : 7

    board[king_row][queenside ? 2 : 6] = board[king_row][4]
    board[king_row][queenside ? 3 : 5] = board[king_row][rook_column]
    board[king_row][4] = nil
    board[king_row][rook_column] = nil
    true
  end
end
