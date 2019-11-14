module Enumerable
  # my_each 1
  def my_each
    return to_enum unless block_given?

    x = 0
    while x < size
      yield(self[x])
      x += 1
    end
    self
  end

  # my_each_with_index 2
  def my_each_with_index
    return to_enum unless block_given?

    (0...size).each { |x| yield self[x], x }
  end

  # my_select 3
  def my_select
    return to_enum unless block_given?

    selected_elements = []
    my_each do |x|
      selected_elements << x if yield x
    end
    selected_elements
  end

  # my_all? 4
  def my_all?(par = nil)
    if block_given?
      my_each { |x| return false unless yield(x) }
    elsif par.class == Class
      my_each { |x| return false unless x.class == par }
    elsif par.class == Regexp
      my_each { |x| return false unless x =~ par }
    elsif par.nil?
      my_each { |x| return false unless x }
    else
      my_each { |x| return false unless x == par }
    end
    true
  end

  # my_any? 5
  def my_any?(par = nil)
    if block_given?
      my_each { |x| return true if yield(x) }
    elsif par.class == Class
      my_each { |x| return true if x.class == par }
    elsif par.class == Regexp
      my_each { |x| return true if x =~ par }
    elsif par.nil?
      my_each { |x| return true if x }
    else
      my_each { |x| return true if x == par }
    end
    false
  end

  # my_none? 6
  def my_none?(par = nil)
    if block_given?
      my_each { |x| return false if yield(x) }
    elsif par.class == Class
      my_each { |x| return false if x.class == par }
    elsif par.class == Regexp
      my_each { |x| return false if x =~ par }
    elsif par.nil?
      my_each { |x| return false if x }
    else
      my_each { |x| return false if x == par }
    end
    true
  end

  # my_count 7
  def my_count(items = nil)
    count = 0
    if block_given?
      my_each { |x| count += 1 if yield(x) == true }
    elsif items.nil?
      my_each { count += 1 }
    else
      my_each { |x| count += 1 if x == items }
    end
    count
  end

  # my_map 8
  def my_map(proc = nil)
    return to_enum unless block_given?

    var = self
    result = []
    var.my_each do |x|
      result << (block_given? ? yield(x) : proc.call(x))
    end
    result
  end

  # my_inject 9
  def my_inject(*args)
    arr = to_a.dup
    if args[0].nil?
      memo = arr.shift
    elsif args[1].nil? && !block_given?
      symbol = args[0]
      memo = arr.shift
    elsif args[1].nil? && block_given?
      memo = args[0]
    else
      memo = args[0]
      symbol = args[1]
    end
    arr[0..-1].my_each do |elem|
      memo = if symbol
               memo.send(symbol, elem)
             else
               yield(memo, elem)
             end
    end
    memo
  end
end

# multiply_els 10
def multiply_els(value)
  value.my_inject :*
end