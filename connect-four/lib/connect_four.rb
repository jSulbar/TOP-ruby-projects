require_relative '../../lib/playable'
require_relative './board'

# Connect-four class for playing... connect-four.
class ConnectFour
  include Playable

  attr_accessor :turn_queue, :board

  def initialize(board = Board.new)
    @board = board
    @turn_queue = %w[P1 P2]
  end

  def game_over?
    @board.won? || @board.full?
  end

  def process_input(user_input)
    user_input = user_input.to_i
    [user_input - 1, @turn_queue.first] unless user_input > @board.slots[0].length ||
                                               user_input < 1
  end
end
