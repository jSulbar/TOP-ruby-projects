require './lib/chessboard'
require '../lib/playable'
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

  def match_winner?
  end

  def advance_turn
    @turn_queue.reverse!
  end

  def process_input(notation)
    return @turn_queue.first if notation == 'RESIGN'

    piece_notation, from, to = @chessboard.move_data(notation)
    return if from.nil? || to.nil?
    return if @chessboard[from[0]][from[1]].notation != piece_notation

    [piece_notation, from, to]
  end

  def process_turn
    _, from, to = get_ply_input(
      'Write your move in algebraic notation. Example: Qh4d8 moves a Queen from h4 to d8.',
      "#{@turn_queue.first.capitalize} to move: "
    ) while from.nil?
    piece = @chessboard[from[0]][from[1]]

    if piece.available_tiles(from, @chessboard).include?(to)
      @chessboard[from[0]][from[1]] = nil
      @chessboard[to[0]][to[1]] = piece
    else
      puts "You can't move there with that piece. Cause i said so."
      process_turn
    end
  end

  def game_over?
    checkmate? || draw?
  end

  def checkmate?
  end

  def draw?
  end
end
