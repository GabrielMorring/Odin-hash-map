require_relative "lib/hash_map"

test = HashMap.new

test.set("apple", "red")
test.set("banana", "yellow")
test.set("carrot", "orange")
test.set("dog", "brown")
test.set("elephant", "gray")
test.set("frog", "green")
test.set("grape", "purple")
test.set("hat", "black")
test.set("ice cream", "white")
test.set("jacket", "blue")
test.set("kite", "pink")
test.set("lion", "golden")

puts test.length
puts test.capacity

test.set("kite", "red")

puts test.length
puts test.capacity

test.set("moon", "silver")
test.set("hi", "hihihihi")

puts test.length
puts test.capacity
p test.entries
p test.entry_count
