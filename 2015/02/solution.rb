#!/usr/bin/env ruby

# frozen_string_literal: true

# Target Version: 2.7.4
#
# Advent of Code challenge for 2015-12-02 Parts 1 & 2

input_file = 'input.txt'

total_paper = 0
total_ribbon = 0

File.open(input_file).each_line do |line|
  length, width, height = line.split('x').map(&:to_i)
  side_areas = [length * width, width * height, height * length]

  total_paper += 2 * side_areas.sum + side_areas.min

  perimeters = [2 * (length + width),
                2 * (width + height),
                2 * (height + length)]
  volume = length * width * height
  total_ribbon += perimeters.min + volume
end

puts "Paper used: #{total_paper}" # => 1586300
puts "Ribbon used: #{total_ribbon}" # => 3737498
