#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-15 Parts 1 & 2

input_file = 'input.txt'

def neighbors(row, col, map)
  result = []
  result << [row + 1, col] if row + 1 < map.size * 5
  result << [row - 1, col] if row.positive?
  result << [row, col + 1] if col + 1 < map.size * 5
  result << [row, col - 1] if col.positive?
  result
end

def value(row, col, map)
  base = map[row % 100][col % 100]
  bonus = row / 100 + col / 100
  (base + bonus - 1) % 9 + 1
end

map = []
cost = Hash.new { 999_999 }

File.open(input_file).each_line do |line|
  map << line.strip.chars.map(&:to_i)
end

start = [0, 0]
goal1 = [99, 99]
goal2 = [499, 499]

cost[start] = 0
tentative = Hash.new { |hash, key| hash[key] = [] }
tentative[0] = [start]
# unseen nodes have tentative cost 'infinity' == not in hash

curr_min = 0
until cost.size == 250_000
  curr_min += 1 while tentative[curr_min].empty?
  # find lowest cost tentative
  current = tentative[curr_min].pop
  # calculate new tentative distance for neighbors
  neighbors(*current, map).each do |neighbor|
    old = cost[neighbor]
    new = cost[current] + value(*neighbor, map)
    next unless new < old

    cost[neighbor] = new
    tentative[old].delete(neighbor)
    tentative[new] << neighbor
  end
  # remove processed node from tentatives
  tentative[curr_min].delete(current)
end

p cost[goal1]
p cost[goal2]
