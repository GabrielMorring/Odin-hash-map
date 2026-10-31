require "pry-byebug"

class HashMap
  attr_reader :capacity, :entry_count

  def initialize
    @load_factor = 0.75
    @capacity = 16
    @array = Array.new(@capacity)
    @entry_count = 0
  end

  def hash(key)
    hash_code = 0
    prime_num = 31

    key.each_char { |c| hash_code = (prime_num * hash_code) + c.ord }

    hash_code % @capacity
  end

  def set(key, value)
    double_size if @entry_count >= max_entries
    new_node = [key, value]

    index = hash(key)
    raise IndexError if index.negative? || index >= @array.length

    bucket = @array[index]

    if bucket.nil?
      bucket = [new_node]
      @entry_count += 1
      @array[index] = bucket
      return
    end

    collision = true

    bucket.map! do |node|
      if node[0] == key
        collision = false
        new_node
      else
        node
      end
    end

    return unless collision

    @array[index] << new_node
    @entry_count += 1
  end

  def double_size
    old_array = @array.dup
    old_entry_count = @entry_count
    @capacity *= 2
    @array = Array.new(@capacity)
    old_array.flatten!(1)
    old_array.reject! { |entry| entry.nil? }
    old_array.each do |entry|
      key = entry[0]
      value = entry[1]
      set(key, value)
    end
    @entry_count = old_entry_count
  end

  def max_entries
    (@load_factor * @capacity).to_i
  end

  def get(key)
    index = hash(key)
    raise IndexError if index.negative? || index >= @array.length

    bucket = @array[index]

    bucket.each { |node| return node[1] if node[0] == key } unless bucket.nil?

    nil
  end

  def has?(key)
    return false if get(key).nil?

    true
  end

  def remove(key)
    index = hash(key)
    raise IndexError if index.negative? || index >= @array.length

    bucket = @array[index]

    return nil if bucket.nil?

    value = nil

    @array[index].filter! do |node|
      if node[0] == key
        value = node[1]
        false
      else
        true
      end
    end
    @array[index] = nil if @array[index].empty?
    value
  end

  def length
    count = 0
    @array.flatten(1).each do |item|
      count += 1 unless item.nil?
    end
    count
  end

  def clear
    @capacity = 16
    @array = Array.new(@capacity)
    @entry_count = 0
  end

  def entries
    @array.flatten(1).filter { |item| !item.nil? }
  end

  def keys
    entries.map { |entry| entry[0] }
  end

  def values
    entries.map { |entry| entry[1] }
  end
end
