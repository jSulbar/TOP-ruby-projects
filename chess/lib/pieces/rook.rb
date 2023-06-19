require './lib/pieces/piece'

class Rook
  include Piece

  def initialize(color)
    @color = color
    @char = { white: '♖', black: '♜' }
    @notation = 'R'
    @continuous_movement = true
    @move_list = make_movelist(
      [-1, 1, 0].permutation(2).entries.filter do |offset|
        offset.include?(0)
      end
    )
  end
end
