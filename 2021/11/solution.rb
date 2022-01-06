#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-11 Parts 1 & 2

input_file = 'input.txt'

def increment(map)
  map.each_index { |i| map[i].each_index { |j| map[i][j] += 1 } }
end

def neighbors(i, j, map)
  result = [
    [i + 1, j + 1],
    [i + 1, j],
    [i + 1, j - 1],
    [i, j + 1],
    [i, j - 1],
    [i - 1, j + 1],
    [i - 1, j],
    [i - 1, j - 1]
  ]
  result.select do |x, y|
    0 <= x && x < map.size && 0 <= y && y < map[x].size
  end
end

def flash(map)
  flashes = 0
  # while there are flashing octopi
  while map.flatten.any? { |n| n > 9 }
    index = map.flatten.find_index { |n| n > 9 }
    i, j = index.divmod(map.size)
    map[i][j] = -99 # This cell may not flash again this cycle
    flashes += 1
    neighbors(i, j, map).each do |x, y|
      map[x][y] += 1
    end
  end
  flashes
end

# Bring octopi that have flashed back to 0
def normalize(map)
  map.each_index do |i|
    map[i].each_index { |j| map[i][j] = [map[i][j], 0].max }
  end
end

input = []

File.open(input_file).each_line do |line|
  input << line.strip.chars.map(&:to_i)
end

number_of_flashes = 0

# make copy of input because we will modify the array
map = input.map(&:dup)
100.times do
  increment(map)
  number_of_flashes += flash(map)
  normalize(map)
end
puts "There are #{number_of_flashes} flashes in the first 100 cycles"

# restore the input for a fresh start
# in case the first synced flash is before cycle 100
map = input
(0..).each do |iteration|
  increment(map)
  if flash(map) == map.flatten.size
    # account of 0-indexing
    puts "First synced flash is on cycle #{iteration + 1}"
    break
  end
  normalize(map)
end
