#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-08 Parts 1 & 2

def conversion_map(training)
  result = {}

  # Let's count in how many digits each segment is used:
  # a => 8, b => 6, c => 8, d => 7, e => 4, f => 9, g => 7
  # b, e and f have unique counts, which makes them easily identified
  # The other segments need a closer inspection
  ('a'..'g').each do |c|
    result[c] = case training.join.count(c)
                when 4 # e
                  'e'
                when 6 # b
                  'b'
                when 7 # d or g
                  # d is present in the digit 4 (4 segments), g is not
                  four = training.find { |d| d.size == 4 }
                  four.include?(c) ? 'd' : 'g'
                when 8 # a or c
                  # c is present in the digit 1 (2 segments), a is not
                  one = training.find { |d| d.size == 2 }
                  one.include?(c) ? 'c' : 'a'
                when 9 # f
                  'f'
                end
  end
  result
end

def convert(arrs, map)
  arrs.map do |arr|
    arr.map do |v|
      map[v]
    end
  end
end

def to_digits(arrs)
  map = {
    %w[a b c e f g] => 0,
    %w[c f] => 1,
    %w[a c d e g] => 2,
    %w[a c d f g] => 3,
    %w[b c d f] => 4,
    %w[a b d f g] => 5,
    %w[a b d e f g] => 6,
    %w[a c f] => 7,
    %w[a b c d e f g] => 8,
    %w[a b c d f g] => 9
  }
  arrs.map { |arr| map[arr.sort] }
end

input_file = 'input.txt'
counts = Array.new(10, 0)
sum = 0

File.open(input_file).each_line do |line|
  training, test = line.split('|').map { |set| set.split.map(&:chars) }

  map = conversion_map(training)
  corrected = convert(test, map)
  digits = to_digits(corrected)
  digits.each { |i| counts[i] += 1 }
  sum += digits.join.to_i
end

puts "Number of 1, 4, 7, 8: #{counts[1] + counts[4] + counts[7] + counts[8]}"
puts "Total Sum: #{sum}"
