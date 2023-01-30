# Generic module for text-based interactive games.
module Playable
  def play
    loop do
      system('cls') || system('clear') unless $DEBUG
      print_gamestate

      process_turn
      break if game_over?

      advance_turn
    end

    puts "#{match_winner || 'No one'} won!"
  end

  def get_ply_input(usage, legend = nil)
    puts usage
    print legend unless legend.nil?

    process_input(gets.chomp)
  end

  def save_game(state_obj)
    state_obj = MessagePack.pack state_obj
    File.binwrite("#{@GAME_NAME}.sav", state_obj)
  end

  def load_game
    save = File.binread("#{@GAME_NAME}.sav")
    MessagePack.unpack save
  end
end
