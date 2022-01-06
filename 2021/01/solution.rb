#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-01 Parts 1 & 2
# Calculate how often the depth given in the input file increases

def count_increases(depths, window_size)
  # When examining two overlapping windows, it is possible to
  # ignore the terms they share
  # d[n] + d[n+1] + d[n+2] < d[n+1] + d[n+2] + d[n+3] <=> d[n] < d[n+3]
  depths[...-window_size].zip(depths[window_size..]).count { |a, b| a < b }
end

input_file = 'input.txt'

depths = File.readlines(input_file).map(&:to_i)
puts "Part 1 (single points): #{count_increases(depths, 1)}"
puts "Part 2 (sliding window): #{count_increases(depths, 3)}"
