#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-14 Parts 1 & 2

def do_iterations(pairs, map, number_of_iterations)
  number_of_iterations.times.inject(pairs) do |old_pairs|
    new_pairs = Hash.new(0)
    old_pairs.each do |key, value|
      results = map[key] || [key]
      results.each { |new_pair| new_pairs[new_pair] += value }
    end
    new_pairs
  end
end

def difference_of_most_and_least_common(pairs)
  counts = Hash.new(0)
  pairs.each { |pair, count| pair.each_char { |c| counts[c] += count } }
  # we keep track of the pairs, and every char is part of two pairs
  # => divide counts by 2 to obtain real counts
  (counts.values.max - counts.values.min) / 2
end

input_file = 'input.txt'

string = nil
map = {}

File.open(input_file).each_line do |line|
  # First line is starting string
  string ||= line.strip

  next unless line.include?('->')

  where, insert = line.split('->').map(&:strip)
  results = [where.chars[0] + insert, insert + where.chars[1]]
  map[where] = results
end

pairs = Hash.new(0)
string.chars.each_cons(2) do |slice|
  pairs[slice.join] += 1
end
# because we have looked at the pairs,
# we have all chars twice except the first and last
# => add first and last to compensate
# These are not real 'pairs', but it's close enough
pairs[string.chars[0]] = 1
pairs[string.chars[-1]] = 1

# Part 1: 10 Iterations
pairs = do_iterations(pairs, map, 10)
puts difference_of_most_and_least_common(pairs)

# Part 2: 40 Iterations
# we already did 10 iterations, so we need 30 more
pairs = do_iterations(pairs, map, 30)
puts difference_of_most_and_least_common(pairs)
