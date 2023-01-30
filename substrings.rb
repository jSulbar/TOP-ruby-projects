def substrings(str, dict)
  dict.reduce(Hash.new(0)) do |res, sub|
    res[sub] = str.split.reduce(0) do |count, word|
      word.upcase.include?(sub.upcase) ? count + 1 : count
    end
    res.reject { |_, val| val.zero? }
  end
end
