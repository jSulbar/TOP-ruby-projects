require './lib/pieces/piece'

class Queen
  include Piece

  def initialize(color)
    @color = color
    @char = { white: '♕', black: '♛' }
    @continuous_movement = true
    @move_list = make_movelist(
      [-1, 0, 1].repeated_permutation(2).to_a.filter { |el| el != [0, 0] }
    )
  end
end
