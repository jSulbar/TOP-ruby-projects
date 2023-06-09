require 'pry-byebug'
require_relative '../../lib/playable'

# Board class for tictactoe
class Board
  attr_accessor :spaces

  def initialize
    @spaces = Array.new(3) { Array.new(3) { false } }
  end

  def match_end?
    columns = @spaces.transpose

    # Rows
    @spaces[0].all? or
      @spaces[1].all? or
      @spaces[2].all? or

      columns[0].all? or
      columns[1].all? or
      columns[2].all? or

      # Diagonals
      (@spaces[0][0] and
      @spaces[1][1] and
      @spaces[2][2]) or
      (@spaces[0][2] and
      @spaces[1][1] and
      @spaces[2][0])
  end

  def spaces_taken
    @spaces.reduce(0) do |res, row|
      res + row.count(true)
    end
  end
end

# Tictactoe class
class TicTacToe
  include Playable
  attr_accessor :boards, :turns, :current_turn, :next_turn

  def initialize
    @boards = {
      p1: Board.new,
      p2: Board.new
    }
    @turns = 0
    @current_turn = :p1
    @next_turn = :p2
  end

  def print_gamestate
    result = Array.new(3) { |v1| Array.new(3) { |v2| v2 + v1 } }

    result.each_index do |y|
      print("#{(y + 1).to_s} ")

      result[y].each_index do |x|
        print '|' if x.positive?

        if @boards[:p1].spaces[y][x]
          print 'X'
        elsif @boards[:p2].spaces[y][x]
          print 'O'
        else
          print '_'
        end
      end

      print "\n"
    end
    puts '  1 2 3'
  end

  def match_winner
    if @boards[:p1].match_end?
      'P1'
    elsif @boards[:p2].match_end?
      'P2'
    else
      false
    end
  end

  def process_turn
    plyrow, plycol = get_ply_input(
      'Type row/column separated by a space.',
      "#{@current_turn == :p1 ? 'P1' : 'P2'} move: ")

    if mark_space(plyrow, plycol)
      match_winner or !moves_possible?
    end
  end

  def advance_turn
    @current_turn, @next_turn = @next_turn, @current_turn
  end

  def process_input(user_input)
    move = user_input.split
    [move[0].to_i - 1, move[1].to_i - 1]
  end

  def moves_possible?
    @boards[:p1].spaces_taken + @boards[:p2].spaces_taken != 9
  end

  def game_over?
    !moves_possible? or match_winner
  end

  def mark_space(row, col)
    if !@boards[@next_turn].spaces[row][col]
      @boards[@current_turn].spaces[row][col] = true
      @turns += 1
    else
      false
    end
  end
end

# tictactoe = TicTacToe.new
# puts tictactoe.play
