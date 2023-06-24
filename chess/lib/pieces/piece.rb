require './lib/movement_pattern'

# Generic chesspiece class
module Piece
  attr_accessor :notation, :color

  def to_s
    @char[@color]
  end

  def followup_move(pos, board, move)
    if @continuous_movement
      result = move.follow_until(pos) do |follow_up|
        !board.can_move_to?(@color, *follow_up) ||
          board.enemy_piece?(@color, *follow_up)
      end

      result.filter { |tile| board.can_move_to?(@color, *tile) }
    else
      result = move.from_pos(pos)
      result if board.can_move_to?(@color, *result)
    end
  end

  def available_tiles(pos, board)
    res = []
    @move_list.each do |move|
      if @continuous_movement
        res += followup_move(pos, board, move)
      else
        res.push(followup_move(pos, board, move))
      end
    end
    res.compact
  end

  def make_movelist(min_offsets)
    min_offsets.map do |offset|
      MovementPattern.new(offset)
    end
  end
end
