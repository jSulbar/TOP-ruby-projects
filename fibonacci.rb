def fibs_rec(num, res = [0, 1])
  if res[-1] >= n
    res
  else
    fibs(num, res.push(res[-2] + res[-1]))
  end
end

def fibs(num, res = [0, 1])
  res.push(res[-2] + res[-1]) until res[-1] >= num
  res
end

def merge_sort(arr)
  if arr.length == 2
    arr[0] > arr[1] ? arr.reverse : arr
  elsif arr.empty? || arr.length == 1
    arr
  else
    first_half = merge_sort(arr[...(arr.length / 2).round])
    latter_half = merge_sort(arr[(arr.length / 2).round...])
    new_arr = []

    until first_half.empty? || latter_half.empty?
      if latter_half.first <= first_half.first
        new_arr.push(latter_half.shift)
      else
        new_arr.push(first_half.shift)
      end
    end

    new_arr + first_half + latter_half
  end
end
