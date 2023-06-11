require_relative '../../lib/playable'
require_relative './board'

# Connect-four class for playing... connect-four.
class ConnectFour
  include Playable

  def initialize(board = Board.new)
    @board = board
  end
end
