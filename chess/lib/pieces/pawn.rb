require './lib/pieces/piece'

class Pawn
  include Piece
  attr_accessor :double_step

  def initialize(color)
    @color = color
    @char = { white: '♙', black: '♟' }
    @notation = 'P'
    @continuous_movement = false
    @move_list = make_movelist(
      [[front(2), 0], [front(1), 0]]
    )
  end

  def move_piece(from, to, board)
    if (from[0] - to[0]).abs == 2 && !@moved
      @double_step = true
    elsif en_passant_tiles(from, board).include?(to)
      return move_en_passant(from, to, board)
    else
      @double_step = false
      @move_list = make_movelist([[front(1), 0]])
    end
    @moved = true

    super(from, to, board)
  end

  def move_en_passant(from, to, board)
    board[from[0]][to[1]] = nil
    board[from[0]][from[1]] = nil
    board[to[0]][to[1]] = self

    true
  end

  def front(coord)
    @color == :white ? coord * -1 : coord
  end

  def diagonal_pieces(pos, board)
    [[pos[0] + front(1), pos[1] + 1],
     [pos[0] + front(1), pos[1] - 1]].filter do |attack|
       board.enemy_piece?(@color, *attack)
     end
  end

  def en_passant_tiles(pos, board)
    [[pos[0], pos[1] - 1],
     [pos[0], pos[1] + 1]].map do |atk|
       next unless board.enemy_piece?(@color, *atk) &&
                   board[atk[0]][atk[1]]&.double_step &&
                   board[atk[0] + front(1)][atk[1]].nil?

       [atk[0] + front(1), atk[1]]
     end.compact
  end

  def available_tiles(pos, board)
    super(pos, board).filter { |t| board[t[0]][t[1]].nil? } + diagonal_pieces(pos, board) + en_passant_tiles(pos, board)
  end
end
