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
end
