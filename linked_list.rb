# Node for linked list
class Node
  attr_accessor :next

  def initialize(value)
    @value = value
  end

  def value
    @value
  end
end

# Linked list class
class LinkedList
  def append(value)
    if @head.nil?
      @head = Node.new(value)
    else
      tail.next = Node.new(value)
    end
  end

  def prepend(value)
    prev = @head
    @head = Node.new(value)
    @head.next = prev
  end

  def size
    current = @head
    size = 1
    until current.next.nil?
      size += 1 unless current.next.nil?
      current = current.next
    end
    size
  end

  def head
    @head
  end

  def tail
    current = @head
    current = current.next until current.next.nil?
    current
  end

  def at(index)
    i = 0
    current = @head
    until i == index
      break if current.next.nil?

      i += 1
      current = current.next
    end
    current
  end

  def pop
    current = @head
    current = current.next until current.next.next.nil?
    popped = current.next
    current.next = nil
    popped
  end

  def contains?(value)
    current = @head
    while current.value != value
      return false if current.next.nil?

      current = current.next
    end
    true
  end

  def find(value)
    current = @head
    i = 0
    while current.value != value
      return nil if current.next.nil?

      current = current.next
      i += 1
    end
    i
  end

  def to_s
    current = @head
    res = "(#{current.value}) -> "
    until current.next.nil?
      current = current.next
      res += "(#{current.value}) -> "
    end

    "#{res} nil"
  end

  def insert_at(value, index)
    current = @head
    i = 0
    until i == index
      current = current.next
      i += 1
    end

    new_node = Node.new(value)
    new_node.next = current.next
    current.next = new_node
  end

  def remove_at(index)
    current = @head
    i = 0
    until i == index - 1 || index.zero?
      current = current.next
      i += 1
    end

    # Garbage collection SHOULD just get rid of the unused var
    @head = @head.next if index.zero?
    current.next = current.next.next if index.positive?
  end
end
