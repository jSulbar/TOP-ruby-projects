require_relative 'lib/playable'

# Class for Mastermind code objects
class MastermindCode
  include Enumerable
  attr_accessor :sequence

  def initialize(code)
    @sequence = if !code.class == String
                  raise TypeError 'Invalid Mastermind code. ' \
                  'Use a string.'
                else
                  code.to_s.split('')
                end

    @length = @sequence.size
  end

  def each(&block)
    if block_given?
      @sequence.each(&block)
    else
      to_enum(:each)
    end
  end

  def to_s
    @sequence.join
  end
end

# Class for guess objects in Mastermind
class Guess < MastermindCode
  attr_accessor :rating

  def inject_rating(rating)
    @rating = rating
  end

  def to_s
    rate_s = @rating.reduce('') do |res, h|
      count = ''
      if h[0] == :correct
        @rating[:correct].times { count += '!' }
      elsif h[0] == :present
        @rating[:present].times { count += '?' }
      else
        @rating[:wrong].times { count += 'O' }
      end
      res + count
    end
    "#{@sequence.join} | #{rate_s}"
  end
end

class MastermindCodemaker
  def initialize
  end

  def make_code
    @code = MastermindCode.new(rand(10_000..99_999).to_s)
    puts "Pepperoni secret code: #{@code.to_s}" if $DEBUG
  end

  def rate_guess(guess)
    result = empty_rating

    if guess.class != Guess
      raise TypeError "rate_guess got #{guess.class}, " \
        'expected MastermindCode'
    end
    puts "Guess #{guess.sequence.join} vs. Code #{@code.to_s}!" if $DEBUG

    result[:correct] = correct_count(guess)
    result[:present] = present_count(guess, result[:correct])
    result[:wrong] = @code.sequence.size - (result[:correct] + result[:present])

    guess.inject_rating(result)
    guess
  end

  def code_length
    @code.sequence.size
  end

  def code?
    !@code.nil?
  end

  def secret_code
    @code
  end

  private

  attr_accessor :code

  def empty_rating
    {
      correct: 0,
      present: 0,
      wrong: 0,
    }
  end

  def present_count(guesscode, correct_count)
    common = guesscode.sequence.map do |v|
      @code.sequence.include?(v) ? v : nil
    end.compact

    common.uniq.reduce(0) do |res, n|
      puts "present_count: |res, n| = #{res}, #{n}" if $DEBUG

      if guesscode.count(n) > @code.count(n) ||
         @code.count(n) == guesscode.count(n)
        res + @code.count(n)
      elsif @code.count(n) > guesscode.count(n)
        res + guesscode.count(n)
      end
    end - correct_count
  end

  def correct_count(guesscode)
    result = 0
    @code.sequence.map(&:clone).zip(guesscode.sequence).map do |v|
      puts "rate_guess: v[0], v[1] = #{v[0]}, #{v[1]}" if $DEBUG
      if v[0] == v[1]
        result += 1
        '!'
      end
    end
    result
  end
end

# Mastermind main game class
class Mastermind
  include Playable
  attr_accessor :turn_limit, :turns

  def initialize(codemaker, turn_limit = 12)
    @codemaker = codemaker
    @turn_limit = turn_limit
    @history = []
    @turn = 1
  end

  private

  attr_accessor :turns, :guesses, :turn_limit, :codemaker

  def process_input(code)
    Guess.new(code)
  end

  def process_turn
    @codemaker.make_code unless @codemaker.code?

    guess = get_ply_input(
      "Type a #{@codemaker.code_length} digit number and press enter.",
      'Your guess: '
    )

    @history.push(@codemaker.rate_guess(guess))
  end

  def advance_turn
    @turn += 1
  end

  def match_winner
    if @turn == @turn_limit
      "The Codemaker [with code #{@codemaker.secret_code}]"
    elsif @history.last.rating[:correct] == @history.last.sequence.size
      'The Codebreaker'
    else
      false
    end
  end

  def print_gamestate
    puts "Turn #{@turn}/#{@turn_limit}."

    puts 'Your guesses: '
    puts @history
  end

  def game_over?
    @turn == @turn_limit or match_winner
  end
end

$DEBUG = false

codemaker = MastermindCodemaker.new
vibeos_game = Mastermind.new(codemaker)
vibeos_game.play
