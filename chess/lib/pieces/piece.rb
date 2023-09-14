require './lib/movement_pattern'

# Generic chesspiece class
module Piece
  attr_accessor :notation, :color

  def to_s
    @char[@color]
  end

  def followup_move(pos, board, move, allow_mate: true)
    if @continuous_movement
      result = move.follow_until(pos) do |follow_up|
        !board.can_move_to?(@color, *follow_up) ||
          (board.enemy_piece?(@color, *follow_up) &&
           allow_mate) ||
          (board.enemy_piece?(@color, *follow_up) &&
           !allow_mate &&
           follow_up != board.king_of(@color == :white ? :black : :white))
      end

      result.filter { |tile| board.can_move_to?(@color, *tile) }
    else
      result = move.from_pos(pos)
      result if board.can_move_to?(@color, *result)
    end
  end

  def available_tiles(pos, board, **kwargs)
    res = []
    @move_list.each do |move|
      if @continuous_movement
        res += followup_move(pos, board, move, **kwargs)
      else
        res.push(followup_move(pos, board, move))
      end
    end
    res.compact
  end

  def move_piece(from, to, board)
    return unless available_tiles(from, board).include?(to)

    board[from[0]][from[1]] = nil
    board[to[0]][to[1]] = self
    true
  end

  def make_movelist(min_offsets)
    min_offsets.map do |offset|
      MovementPattern.new(offset)
    end
  end
end
