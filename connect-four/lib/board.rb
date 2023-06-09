# Board class for Connect-Four CLI game
class Board
  attr_accessor :slots

  def initialize(rows = 6, columns = 7)
    @slots = Array.new(rows) { Array.new(columns, nil) }
  end
end
