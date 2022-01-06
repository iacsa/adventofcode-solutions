#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-07 Parts 1 & 2

def min_moves(crabs, &block)
  crabs.each_index.map do |i|
    crabs.each_with_index.map { |n, j| n * block.call((i - j).abs) }.sum
  end.min
end

input_file = 'input.txt'

positions = File.read(input_file).split(',').map(&:to_i)
crabs = Array.new(positions.max + 1, 0)
positions.each { |i| crabs[i] += 1 }

# Part 1
# Move cost is constant: 1 + 1 + 1 ... + 1 = d
puts min_moves(crabs) { |d| d } # => 335330

# Part 2
# Move cost is linear: 1 + 2 + 3 + ... + n = (d + 1) * d / 2 (Gauss)
puts min_moves(crabs) { |d| (d + 1) * d / 2 } # => 92439766
