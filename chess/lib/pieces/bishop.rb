require './lib/pieces/piece'

class Bishop
  include Piece

  def initialize(color)
    @color = color
    @char = { white: '♗', black: '♝' }
    @notation = 'B'
    @continuous_movement = true
    @move_list = make_movelist(
      [-1, 1].repeated_permutation(2).entries
    )
  end
end
