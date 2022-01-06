#!/usr/bin/env ruby

# frozen_string_literal: true

# Target Version: 2.7.4

# Advent of Code challenge for 2015-12-05 Parts 1 & 2

input_file = 'input.txt'

def nice1?(string)
  at_least_3_vowels?(string) &&
    double_letter?(string) &&
    no_naughty_substrings?(string)
end

def at_least_3_vowels?(string)
  vowels = %w[a e i o u]
  string.chars.count { |c| vowels.include?(c) } >= 3
end

def double_letter?(string)
  chars = string.chars
  (1...chars.length).any? { |i| chars[i] == chars[i - 1] }
end

def no_naughty_substrings?(string)
  naughty_substrings = %w[ab cd pq xy]
  naughty_substrings.none? { |naughty| string.include?(naughty) }
end

def nice2?(string)
  non_overlapping_double?(string) && distant_pair?(string)
end

def non_overlapping_double?(string)
  /([a-z]{2}).*\1/ =~ string
end

def distant_pair?(string)
  /([a-z]).\1/ =~ string
end

nice_string_count1 = 0
nice_string_count2 = 0

File.open(input_file).each_line do |line|
  nice_string_count1 += 1 if nice1?(line)
  nice_string_count2 += 1 if nice2?(line)
end

puts "Part 1: #{nice_string_count1}" # => 236
puts "Part 2: #{nice_string_count2}" # => 51
