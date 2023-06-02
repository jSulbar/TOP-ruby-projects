require './chessboard'

board = Chessboard.new
to_move = board.random_pos

def knight_moves(board, cur_pos, end_pos, cur_depth = 0, max_depth: 6)
  return cur_pos if cur_pos == end_pos && cur_depth.zero? || cur_depth > max_depth

  avail_moves = board.moves_at_pos(*cur_pos)
  if avail_moves.include?(end_pos)
    [avail_moves[avail_moves.index(end_pos)]].prepend(cur_pos)
  else
    children = []
    avail_moves.each do |node|
      child = knight_moves(board, node, end_pos, cur_depth + 1)
      children.push(child.prepend(cur_pos)) if child&.include?(end_pos)
    end
    children.min_by(&:length)
  end
end

puts "Got #{board.position}."
puts "#{to_move} destination."
board.print_board

solution = knight_moves(board, board.position, to_move)
puts "Made it in #{solution.length - 1} moves, here's the path: "
solution.each { |move| p move }
