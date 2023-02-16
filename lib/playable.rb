# Generic module for text-based interactive games.
module Playable
  def play
    load_prompt if File.exist?("#{@GAME_NAME}.sav")
    loop do
      system('cls') || system('clear') unless $DEBUG
      print_gamestate

      process_turn
      break if game_over?

      advance_turn
    end
    puts "#{match_winner || 'No one'} won!"
  end

  def load_prompt
    puts 'You have a saved game. Will you load? (Y/N) '
    load_game if gets.chomp.upcase == 'Y'
  end

  def get_ply_input(usage, legend = nil)
    puts usage
    print legend unless legend.nil?

    process_input(gets.chomp)
  end

  def save_game
    values = instance_variables.map { |attr| instance_variable_get(attr) }
    p values if $DEBUG
    save = MessagePack.pack Hash[instance_variables.zip values]
    File.binwrite("#{@GAME_NAME}.sav", save)
  end

  def save_and_exit
    save_game
    exit(0)
  end

  def load_game
    save = File.binread("#{@GAME_NAME}.sav")
    save = MessagePack.unpack save
    p save if $DEBUG

    instance_variables.each do |attr|
      instance_variable_set(attr, save[attr.to_s])
    end

    p instance_variables if $DEBUG
  end
end
