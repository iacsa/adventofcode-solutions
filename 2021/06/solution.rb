#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-06 Part 1 & 2

input_file = 'input.txt'

days = Array.new(9, 0)
fish_sums = []

File.open(input_file).each_line do |line|
  fishes = line.split(',').map(&:to_i)
  fishes.each { |fish| days[fish] += 1 }
  fish_sums << days.sum
end

256.times do
  days.rotate!(1)
  days[6] += days[8]
  fish_sums << days.sum
end

puts "Part 1 - After 80 days: #{fish_sums[80]}" # => 351092
puts "Part 2 - After 256 days: #{fish_sums[256]}" # => 1595330616005
