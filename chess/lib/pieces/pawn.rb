require './lib/pieces/piece'

class Pawn
  include Piece

  def initialize(color)
    @color = color
    @char = { white: '♙', black: '♟' }
    @continuous_movement = false
    @move_list = make_movelist(
      color == :black ? [[1, 0]] : [[-1, 0]]
    )
  end
end
