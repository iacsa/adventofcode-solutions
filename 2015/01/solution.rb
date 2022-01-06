#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2015-12-01 Parts 1 & 2

input_file = 'input.txt'

input = File.read(input_file).strip

# Part 1
puts 'Santa ends up on floor:'
puts input.count('(') - input.count(')')

# Part 2
puts 'Santa first enters the basement on character:'
floor = 0
input.chars.each_with_index do |c, i|
  floor += 1 if c == '('
  floor -= 1 if c == ')'
  if floor.negative?
    puts i + 1 # Account for 0-based index
    break
  end
end
