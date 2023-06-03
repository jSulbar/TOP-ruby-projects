# Values higher than what indexing allows for
# alphabet array cause issues, this gets any value of
# the sort and turns it to an usable index.
def rollover_shift(shift)
  correction = if shift >= 25
                 -26
               elsif shift <= -26
                 26
               else
                 0
               end
  shift += correction until shift < 25 && shift > -26
  shift
end

def get_shifted_index(char, alphabet, shift)
  alphabet[
    rollover_shift(
      alphabet.index(char.upcase) + shift
    )
  ]
end

def caesar_cipher(str, alphabet, shift = 3)
  str.split('').map do |char|
    if char.match(/^[[:alpha:]]+$/)
      shifted = get_shifted_index(char, alphabet, shift)
      char == char.upcase ? shifted : shifted.downcase
    else
      char
    end
  end.join
end
