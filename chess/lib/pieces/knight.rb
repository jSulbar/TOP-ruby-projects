require './lib/pieces/piece'

class Knight
  include Piece

  def initialize(color)
    @color = color
    @char = { white: '♘', black: '♞' }
    @notation = 'N'
    @continuous_movement = false
    @move_list = make_movelist([1, -1, -2, 2].permutation(2).to_a.filter do |coord|
      coord[0].abs != coord[1].abs
    end)
  end
end
