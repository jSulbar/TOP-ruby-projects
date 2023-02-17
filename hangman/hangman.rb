require 'msgpack'
require_relative '../lib/playable'

# Class for creating Hangman games
class Hangman
  include Playable

  def initialize(wordlist)
    # @wordlist = wordlist
    @secret_word = wordlist.sample.chomp.upcase
    @word_progress = Array.new(@secret_word.length, '_')

    @hangman_count = 0
    @turn_limit = @secret_word.length + @secret_word.length / 2
    @GAME_NAME = self.class.name
  end

  attr_accessor :wordlist, :secret_word, :word_progress, :hangman_count,
                :turn_limit

  private

  def print_gamestate
    print_hangman
    puts "#{@word_progress.join}. Input a letter below and press enter:"
  end

  def print_hangman
    puts @secret_word if $DEBUG
  end

  def randomized_word
    @wordlist.sample.chomp
  end

  def process_input(input)
    return save_and_exit if input[0] == '#'

    input.match(/^[[:alpha:]]+$/) ? input[0] : process_input(gets.chomp)
  end

  def match_answer(ans, secret_word)
    if secret_word.include?(ans)
      @word_progress[secret_word.index(ans)] = ans
      match_answer(ans, secret_word.sub(ans, '_'))
    end
  end

  def process_turn
    ans = get_ply_input(
      "Input a letter (#{(@turn_limit - @hangman_count) + 1} turns remaining)",
      'To save the game and exit, use #: '
    )
    match_answer(ans.upcase, @secret_word.to_s)
  end

  def advance_turn
    @hangman_count += 1
  end

  def game_over?
    @secret_word == @word_progress.join || @hangman_count >= @turn_limit
  end

  def match_winner
    puts "Word was #{@secret_word}."
    @secret_word == @word_progress.join ? 'You' : 'The hangman'
  end
end

$DEBUG = false
# wordlist too long to see error on terminal,
# redirect errors to a text file
$stderr.reopen('err.txt', 'w') if $DEBUG

wordlist = File.open('google-10000-english-no-swears.txt', 'r').readlines
hangman = Hangman.new(wordlist)
hangman.play
