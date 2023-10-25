require './lib/chessboard'
require '../lib/playable'
require 'yaml'
Dir['./lib/pieces/*'].each { |file| require file }

# Chess game class. Handles user input, turns, and
# general game status.
class Chess
  attr_accessor :chessboard, :turn_queue

  include Playable

  def initialize(board)
    @GAME_NAME = 'Chess'
    @chessboard = board
    @turn_queue = %i[white black]
    fill_board
  end

  def back_row(color)
    [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook].map { |piece| piece.new(color) }
  end

  def front_row(color)
    Array.new(8) { Pawn.new(color) }
  end

  def fill_board
    @chessboard[0] = back_row(:black)
    @chessboard[1] = front_row(:black)
    @chessboard[-2] = front_row(:white)
    @chessboard[-1] = back_row(:white)
  end

  def print_gamestate
    puts @chessboard
  end

  def match_winner
    if @resigned
      @turn_queue.last.to_s.capitalize
    elsif draw?
      nil
    else
      @turn_queue.first.to_s.capitalize
    end
  end

  def advance_turn
    @turn_queue.reverse!
  end

  def legal_move?(notation, from, to)
    return if from.nil? || to.nil?
    return if @chessboard[from[0]][from[1]]&.color != @turn_queue.first
    return if @chessboard[from[0]][from[1]]&.notation != notation
    return if check?(@chessboard.from_move(from, to))

    true
  end

  def process_input(notation)
    return @turn_queue.first if notation == 'RESIGN'
    return draw_agreement if notation == 'DRAW'
    return save_and_exit if notation == 'EXIT'

    if ['0-0', '0-0-0'].include?(notation)
      king = @chessboard.king_of(@turn_queue.first)
      return notation if @chessboard[king[0]][king[1]].can_castle?(
        @chessboard,
        queenside: notation == '0-0-0',
        tiles_covered: @chessboard.tiles_covered(@turn_queue.last)
      )
    end

    piece_notation, from, to = @chessboard.move_data(notation)
    return unless legal_move?(piece_notation, from, to)

    [piece_notation, from, to]
  end

  def dead_position?
    case [@chessboard.color_pieces(@turn_queue.first),
      @chessboard.color_pieces(@turn_queue.last)]
    in [[King], [King]]
      true
    in [[King], [King, Bishop]]
      true
    in [[King, Bishop], [King]]
      true
    in [[King], [King, Knight]]
      true
    in [[King, Knight], [King]]
      true
    in [[King, Bishop], [King, Bishop]] => pieces
      @chessboard.black?(*@chessboard.piece_pos(pieces[0][1])) ==
        @chessboard.black?(*@chessboard.piece_pos(pieces[1][1]))
    else
      false
    end
  end

  def save_game
    values = instance_variables.map { |attr| instance_variable_get(attr) }
    save = YAML.dump(Hash[instance_variables.zip(values)])
    File.binwrite("#{@GAME_NAME}.sav", save)
  end
  
  def load_game
    save = YAML.safe_load_file(
      "#{@GAME_NAME}.sav",
      permitted_classes: [Chess, Chessboard, Piece,
        King, Knight, Pawn, Bishop, Queen, Rook, Symbol, MovementPattern]
    )

    instance_variables.each do |attr|
      instance_variable_set(attr, save[attr])
    end
  end

  def process_turn
    received, from, to = get_ply_input(
      'Write your move in algebraic notation. Example: Qh4d8 moves a Queen from h4 to d8.',
      "#{@turn_queue.first.capitalize} to move: "
    ) while received.nil?

    if ['0-0-0', '0-0'].include?(received)
      king = @chessboard.king_of(@turn_queue.first)
      return @chessboard[king[0]][king[1]].castle(@chessboard, received == '0-0-0')
    end
    return if @draw_agreed
    return @resigned = true if received == @turn_queue.first
    return if @chessboard[from[0]][from[1]].move_piece(from, to, @chessboard)

    puts "You can't move there with that piece. Cause i said so."
    process_turn
  end

  def game_over?
    checkmate? || draw? || @resigned
  end

  def check?(board = @chessboard)
    board.tiles_covered(@turn_queue.last).include?(
      board.king_of(@turn_queue.first)
    )
  end

  def checkmate?(board = @chessboard)
    board.color_pieces(@turn_queue.first) do |from, piece|
      possible_moves = if piece.instance_of?(King)
                         piece.available_tiles(
                           from,
                           board,
                           tiles_covered: board.tiles_covered(@turn_queue.last)
                         )
                       else
                         piece.available_tiles(from, board, allow_mate: false)
                       end

      possible_moves.each do |to|
        return false unless check?(board.from_move(from, to))
      end
    end
    true
  end

  def draw_agreement
    puts "#{@turn_queue.first.to_s.capitalize} offers a draw. Do you accept? Y/N "
    @draw_agreed = true if gets.chomp == 'Y'
  end

  def draw?
    stalemate?(@chessboard) || @draw_agreed
  end

  def stalemate?(board = @chessboard)
    res = []
    board.color_pieces(@turn_queue.first) do |from, piece|
      res += if piece.instance_of?(King)
               piece.available_tiles(
                 from,
                 board,
                 tiles_covered: board.tiles_covered(@turn_queue.last)
               )
             else
               piece.available_tiles(from, board)
             end
    end

    res.empty? && !check?
  end
end
