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
    @board.won?(@turn_queue.first) || @board.full?
  end

  def process_input(user_input)
    user_input = user_input.to_i
    [user_input - 1, @turn_queue.first] unless user_input > @board.slots[0].length ||
                                               user_input < 1
  end

  def advance_turn
    @turn_queue.reverse!
  end

  def print_gamestate
    @board.slots.each do |row|
      print '|'
      row.each do |slot|
        print slot.nil? ? '  |' : "#{slot}|"
      end
      puts
    end
  end

  def process_turn
    column, player = get_ply_input(
      'Type the input you want to drop your token into.',
      "#{@turn_queue.first} move: "
    ) while column.nil?

    @board.drop(column, player)
  end

  def match_winner
    if @board.won?(@turn_queue.first)
      @turn_queue.first
    elsif @board.won?(@turn_queue.last)
      @turn_queue.last
    else
      false
    end
  end
end
