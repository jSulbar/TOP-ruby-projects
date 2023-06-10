# Board class for Connect-Four CLI game
class Board
  attr_accessor :slots

  def initialize(rows = 6, columns = 7)
    @slots = Array.new(rows) { Array.new(columns, nil) }
  end

  def check_slot(row, column)
    if row >= @slots.length || column >= @slots[0].length
      nil
    elsif row.negative? || column.negative?
      nil
    else
      @slots[row][column]
    end
  end

  def won?(identifier)
    four_diagonal(identifier) || four_row(identifier) || four_column(identifier)
  end

  def four_diagonal(identifier, slots = @slots)
    slots.each_index do |row|
      slots[row].each_index do |slot|
        return true if [check_slot(row, slot), check_slot(row + 1, slot + 1),
                        check_slot(row + 2, slot + 2),
                        check_slot(row + 3, slot + 3)].all?(identifier)
        return true if [check_slot(row, slot), check_slot(row + 1, slot - 1),
                        check_slot(row + 2, slot - 2),
                        check_slot(row + 3, slot - 3)].all?(identifier)
      end
    end
    false
  end

  def four_row(identifier, slots = @slots)
    slots.each_index do |row|
      slots[row].each_index do |slot|
        break if slot + 3 >= slots[row].length
        return true if slots[row][slot..(slot + 3)].all?(identifier)
      end
    end
    false
  end

  def four_column(identifier, slots = @slots)
    four_row(identifier, slots.transpose)
  end
end
