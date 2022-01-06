#!/usr/bin/env ruby

# frozen_string_literal: true

# Target Version: 2.7.4

# Advent of Code challenge for 2015-12-06 Parts 1 & 2

lights1 = Array.new(1000) { |_| Array.new(1000, false) }
lights2 = Array.new(1000) { |_| Array.new(1000, 0) }

def toggle(light)
  !light
end

def turn_on(_light)
  true
end

def turn_off(_light)
  false
end

File.open('input.txt').each_line do |line|
  instructions = line.split

  action1, action2, offset = if instructions[0] == 'toggle'
                               [->(x) { !x }, ->(x) { x + 2 }, 1]
                             elsif instructions[1] == 'on'
                               [->(_) { true }, ->(x) { x + 1 }, 2]
                             elsif instructions[1] == 'off'
                               [->(_) { false }, ->(x) { [x - 1, 0].max }, 2]
                             end
  first = instructions[offset].split(',').map(&:to_i)
  last = instructions[offset + 2].split(',').map(&:to_i)

  (first[0]..last[0]).each do |x|
    (first[1]..last[1]).each do |y|
      lights1[x][y] = action1.call(lights1[x][y])
      lights2[x][y] = action2.call(lights2[x][y])
    end
  end
end

puts "Part 1: #{lights1.flatten.count(true)}" # => 569999
puts "Part 2: #{lights2.flatten.sum}" # => 17836115
