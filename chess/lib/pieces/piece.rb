require './lib/movement_pattern'

# Generic chesspiece class
module Piece
  attr_accessor :notation

  def to_s
    @char[@color]
  end

  def available_tiles(pos, board)
    res = []
    @move_list.each do |move|
      if @continuous_movement
        res += move.follow_until(pos) { |follow| board.tile_tuple(*follow).nil? }
      else
        # TODO: Missing condition
        res.push(move.from_pos(pos))
      end
    end
    res
  end

  def make_movelist(min_offsets)
    min_offsets.map do |offset|
      MovementPattern.new(offset)
    end
  end
end
