require './lib/pieces/piece'

class Pawn
  include Piece
  attr_accessor :double_step

  def initialize(color)
    @color = color
    @char = { white: '♙', black: '♟' }
    @notation = 'P'
    @continuous_movement = false
    @move_list = make_movelist(
      [[front(2), 0], [front(1), 0]]
    )
  end

  def front(coord)
    @color == :white ? coord * -1 : coord
  end

  def diagonal_pieces(pos, board)
    [[pos[0] + front(1), pos[1] + 1],
     [pos[0] + front(1), pos[1] - 1]].filter do |attack|
       board.enemy_piece?(@color, *attack)
     end
  end

  def en_passant_tiles(pos, board)
    [[pos[0], pos[1] - 1],
     [pos[0], pos[1] + 1]].map do |atk|
       if board.enemy_piece?(@color, *atk) && board[atk[0]][atk[1]]&.double_step
         [atk[0] + front(1), atk[1]]
       end
     end.compact
  end

  def available_tiles(pos, board)
    @double_step = false if @double_step
    super(pos, board) + diagonal_pieces(pos, board) + en_passant_tiles(pos, board)
  end
end
