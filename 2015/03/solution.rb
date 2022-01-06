#!/usr/bin/env ruby

# frozen_string_literal: true

# Target Version: 2.7.4

# Advent of Code challenge for 2015-12-03 Parts 1 & 2

require 'set'

input_file = 'input.txt'

# For part 1, use santa_count = 1 (Santa)
# For part 2, use santa_count = 2 (Santa and Robo Santa)
def solution(input, santa_count)
  current_houses = Array.new(santa_count) { |_| [0, 0] }
  visited_houses = Hash.new { |hash, key| hash[key] = Set[] }
  visited_houses[0].add(0)

  santa = 0
  input.each_char do |arrow|
    case arrow
    when '^'
      current_houses[santa][1] += 1
    when '>'
      current_houses[santa][0] += 1
    when '<'
      current_houses[santa][0] -= 1
    when 'v'
      current_houses[santa][1] -= 1
    end

    visited_houses[current_houses[santa][0]].add(current_houses[santa][1])
    santa = (santa + 1) % santa_count
  end

  visited_houses.map { |_, value| value.size }.sum
end

input = File.read(input_file).strip

puts "Part 1: #{solution(input, 1)}"
puts "Part 2: #{solution(input, 2)}"
