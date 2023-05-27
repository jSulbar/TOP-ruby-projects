# Generic node class for binary tree
class Node
  attr_accessor :data, :left, :right

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def traverse(value)
    value = value.data if value.is_a?(Node)

    if value > @data && !@right.nil?
      @right
    elsif value < @data && !@left.nil?
      @left
    end
  end

  def leaf?
    @left.nil? && @right.nil?
  end

  def deconstruct
    [@left, @right]
  end

  def create_child(value)
    if value > @data
      @right = Node.new(value)
      @right
    elsif value < @data
      @left = Node.new(value)
      @left
    end
  end

  def get_child(value)
    if value == @left&.data
      @left
    elsif value == @right&.data
      @right
    end
  end

  def replace_by_val(value, node)
    if value == @left&.data
      @left = node
      @left
    elsif value == @right&.data
      @right = node
      @right
    end
  end

  def replace_children(node)
    @left = node.left
    @right = node.right
  end

  def leaf_child?
    @right&.leaf? || @left&.leaf?
  end
end

# Class for binary search tree instances.
class Tree
  attr_accessor :root

  def initialize(arr)
    build_tree(arr.sort.uniq)
  end

  def from_node(node = @root)
    return unless block_given?

    current = node
    loop do
      current = yield(current)
    end
    current
  end

  def build_tree(arr, has_root = false)
    return if arr.empty?

    half = (arr.length / 2).round

    if !has_root
      @root = Node.new(arr[half], build_tree(arr[...half], true),
                       build_tree(arr[half + 1...], true))
      @root
    elsif arr.length == 1
      Node.new(arr.first)
    else
      Node.new(arr.delete_at(half),
               build_tree(arr[...half], true),
               build_tree(arr[half...], true))
    end
  end

  def max(node = @root)
    from_node(node) do |current|
      return current if current.leaf?

      current.right
    end
  end

  def min(node = @root)
    from_node(node) do |current|
      return current if current.leaf?

      current.left
    end
  end

  def insert(value)
    from_node do |node|
      next_node = node.traverse(value)
      if next_node.nil?
        node.create_child(value)
        break
      else
        next_node
      end
    end
  end

  def parent(node)
    find(node.data) { |parent| parent.get_child(node.data) }
  end

  def succ(node)
    min(node.right)
  end

  def pred(node)
    max(node.left)
  end

  def delete(value)
    return succ_delete(@root) if value == @root.data

    node = find(value)
    if node.leaf?
      leaf_delete(node)
    elsif !node.leaf_child?
      succ_delete(node)
    else
      move_delete(node)
    end
  end

  def find(value)
    from_node do |node|
      return node if block_given? && yield(node)
      return node if value == node.data

      node.traverse(value)
    end
  end

  def level_order(node = @root)
    current = node
    queue = [current]
    loop do
      break if queue.empty?

      current = queue.shift
      yield current

      queue.push(current.left) unless current.left.nil?
      queue.push(current.right) unless current.right.nil?
    end
  end

  def inorder(node = @root, reverse: false, &block)
    depth_first(2, node, reverse, &block)
  end

  def preorder(node = @root, reverse: false, &block)
    depth_first(1, node, reverse, &block)
  end

  def postorder(node = @root, reverse: false, &block)
    depth_first(3, node, reverse, &block)
  end

  def leaf_nodes(node = @root)
    leaves = []
    level_order(node) { |leaf| leaves.push(leaf) if leaf.leaf? }
    leaves
  end

  def height(node)
    return 0 if node.leaf?

    leaf_nodes(node).map do |leaf|
      height = 0
      from_node(node) do |current|
        break if current == leaf || current.nil?

        height += 1
        current.traverse(leaf)
      end
      height
    end.max
  end

  def depth(node)
    depth = 0
    from_node do |current|
      return depth if current == node

      depth += 1
      node.traverse(current)
    end
  end

  def balanced?
    (height(@root.left) - height(@root.right)).abs < 2
  end

  def rebalance
    new = []
    inorder do |node|
      new.push(node.data)
    end
    build_tree(new.sort)
  end

  private

  def depth_first(present_step, node, reverse, &block)
    present_right = reverse ? true : false
    3.times do |i|
      if i == present_step - 1
        yield node
        next
      end

      if present_right
        depth_first(present_step, node.right, reverse, &block) unless node.right.nil?
      else
        depth_first(present_step, node.left, reverse, &block) unless node.left.nil?
        present_right = reverse ? false : true
      end
    end
  end

  def succ_delete(node)
    successor = parent(succ(node))
    if node != @root
      parent(node).replace_by_val(node.data, successor.left)
                  .replace_children(node)
    else
      successor.left.replace_children(@root)
      @root = successor.left
    end
    successor.left = nil
    node
  end

  def move_delete(node)
    moved = node.left.nil? ? node.right : node.left
    node.replace_by_val(moved.data, nil)

    parent(node).replace_by_val(node.data, moved)
                .replace_children(node)
    node
  end

  def leaf_delete(node)
    parent(node).replace_by_val(node.data, nil)
    node
  end
end

def depth_first_test(tree)
  puts
  print 'Inorder: '
  tree.inorder { |node| print "#{node.data} > " }
  puts

  print 'Preorder: '
  tree.preorder { |node| print "#{node.data} > " }
  puts

  print 'Postorder: '
  tree.postorder { |node| print "#{node.data} > " }
  puts
end

randarr = (Array.new(15) { rand 1..100 }).sort.uniq
t = Tree.new(randarr)
puts "Balanced? #{t.balanced?}"

depth_first_test(t)

5.times { |i| t.insert(100 + i) }
puts "Balanced? #{t.balanced?}"

t.rebalance
puts "Balanced? #{t.balanced?}"

depth_first_test(t)
