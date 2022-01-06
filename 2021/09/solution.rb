#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-09 Parts 1 & 2

input_file = 'input.txt'

map = []

File.open(input_file).each_line do |line|
  map << line.strip.chars.map(&:to_i)
end

low_risk = 0
basin_sizes = []

def neighbors(map, row, col)
  result = []
  result << [row + 1, col] if row + 1 < map.size
  result << [row - 1, col] if row.positive?
  result << [row, col + 1] if col + 1 < map[row].size
  result << [row, col - 1] if col.positive?
  result
end

map.each_index do |i|
  map[i].each_index do |j|
    # only process Low Points
    next unless neighbors(map, i, j).all? { |x, y| map[x][y] > map[i][j] }

    # Part 1: Sum the risks of low points
    low_risk += map[i][j] + 1

    # Part 2: Calculate the basins
    in_basin = [[i, j]]
    todo = [[i, j]]

    while (x, y = todo.pop)
      neighbors(map, x, y).each do |v, w|
        next if in_basin.include?([v, w]) || map[v][w] == 9

        in_basin << [v, w]
        todo << [v, w]
      end
    end

    basin_sizes << in_basin.size
  end
end

puts low_risk # => 512
p basin_sizes.sort[-3..].inject(1, :*) # => 1600104
