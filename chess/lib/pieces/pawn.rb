require './lib/pieces/piece'

class Pawn
  include Piece

  def initialize(color)
    @color = color
    @char = { white: '♙', black: '♟' }
    @continuous_movement = false
    @move_list = make_movelist(
      [[front(2), 0], [front(1), 0]]
    )
  end

  def front(coord)
    @color == :white ? coord * -1 : coord
  end
end
