require './lib/chessboard'
require '../lib/playable'
Dir['./lib/pieces/*'].each { |file| require file }

# Chess game class. Handles user input, turns, and
# general game status.
class Chess
  attr_accessor :chessboard

  include Playable

  def initialize(board)
    @GAME_NAME = 'Chess'
    @chessboard = board
    @turn_queue = %i[white black]
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

  def process_turn
  end

  def game_over?
    checkmate? || draw?
  end

  def checkmate?
  end

  def draw?
  end
end
