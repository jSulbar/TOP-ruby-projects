def stock_picker(days = [17, 3, 6, 9, 15, 8, 6, 1, 10])
  best_days = [-1, -1]

  days.each_with_index do |present, i|
    days.last(days.size - i - 1).each do |future|
      if future - present > days[best_days[1]] - days[best_days[0]]
        best_days = [i, days.index(future)]
      end
    end
  end

  best_days
end

p stock_picker
