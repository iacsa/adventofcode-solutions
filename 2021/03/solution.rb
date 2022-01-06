#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-03 Part 1

input_file = 'input.txt'

numbers = File.readlines(input_file).map { |line| line.strip.chars.map(&:to_i) }
most_common_bits = numbers.transpose.map do |digits|
  (digits.sum * 1.0 / numbers.size).round
end

gamma_rate = most_common_bits.join.to_i(2)

# Least common bits are just the complement of the most common bits
# We can compute the resulting number directly
number_of_digits = most_common_bits.size
epsilon_rate = 2**number_of_digits - 1 - gamma_rate

puts gamma_rate * epsilon_rate # => 1997414
