#!/usr/bin/env ruby

# frozen_string_literal: true

# Target Version: 2.7.4

# Advent of Code challenge for 2015-12-04 Parts 1 & 2

require 'digest'

secret = 'ckczppom'

# For part 1, use desired_zeroes = 5 => result = 117946
# For part 2, use desired_zeroes = 6 => result = 3938038
def solution(secret, desired_zeroes)
  md5 = Digest::MD5.new

  # Brute force hashes until the condition is met
  (1...).find do |i|
    md5.reset
    md5 << secret
    md5 << i.to_s
    hash = md5.hexdigest

    starting_zeroes = hash.chars.index { |c| c != '0' }
    starting_zeroes >= desired_zeroes
  end
end

puts "Part 1: #{solution(secret, 5)}"
puts "Part 2: #{solution(secret, 6)}"
