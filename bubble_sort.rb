def bubble_sort(arr)

    changed = false
    arr.each_with_index do |val, i|

        if i == arr.size - 1

            if changed
                return bubble_sort arr
            else
                return arr
            end

        elsif arr[i + 1] < val

            changed = true
            arr[i] = arr[i + 1]
            arr[i + 1] = val
            
        end

    end

end

rng = Random.new(Random.seed)
p bubble_sort Array.new(rng.rand(30)) {|i| rng.rand }