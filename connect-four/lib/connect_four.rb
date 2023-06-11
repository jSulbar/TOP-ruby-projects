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
end
