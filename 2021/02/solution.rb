#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-02 Parts 1 & 2

input_file = 'input.txt'

# Common
position = 0

# Part 1
depth1 = 0

# Part 2
aim = 0
depth2 = 0

File.open(input_file).each_line do |line|
  command, value = line.split
  value = value.to_i
  case command
  when 'forward'
    position += value
    depth2 += value * aim
  when 'down'
    depth1 += value
    aim += value
  when 'up'
    depth1 -= value
    aim -= value
  end
end

puts "Part 1: #{position * depth1}" # => 1868935
puts "Part 2: #{position * depth2}" # => 1965970888
