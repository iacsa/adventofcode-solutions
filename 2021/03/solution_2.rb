#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-03 Part 2

def most_common(digits)
  (digits.sum * 1.0 / digits.size).round
end

def least_common(digits)
  1 - most_common(digits)
end

def best_fitting_number(numbers, selector)
  candidates = numbers.clone
  candidates[0].each_index do |index|
    target_digit = selector.call(candidates.transpose[index])
    candidates.select! { |candidate| candidate[index] == target_digit }
    return candidates[0].join.to_i(2) if candidates.size == 1
  end
end

input_file = 'input.txt'

numbers = File.readlines(input_file).map { |line| line.strip.chars.map(&:to_i) }

oxygen_generator_rating = best_fitting_number(numbers, method(:most_common))
co2_scrubber_rating = best_fitting_number(numbers, method(:least_common))

life_support_rating = oxygen_generator_rating * co2_scrubber_rating
puts life_support_rating # => 1032597
