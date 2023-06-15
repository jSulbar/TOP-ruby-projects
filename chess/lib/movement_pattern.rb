# Represents a movement inside the board
# concretely established by the attribute @minimum_offset,
# a size 2 array containing [y, x] where its values
# represent the minimum offset from a coordinate.
class MovementPattern
  attr_accessor :minimum_offset

  def initialize(minimum_offset)
    @minimum_offset = minimum_offset
  end

  def from_pos(pos)
    Array.new(2) do |i|
      if @minimum_offset[i].zero?
        pos[i]
      elsif @minimum_offset[i].negative?
        pos[i] - @minimum_offset[i].abs
      else
        pos[i] + @minimum_offset[i]
      end
    end
  end

  def follow_until(pos)
    return unless block_given?

    res = [from_pos(pos)]
    loop do
      break if yield res.last

      res.push(
        [res.last[0] + @minimum_offset[0],
         res.last[1] + @minimum_offset[1]]
      )
    end
    res
  end
end
