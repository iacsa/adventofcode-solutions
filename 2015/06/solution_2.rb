#!/usr/bin/env ruby

# frozen_string_literal: true

# Target Version: 2.7.4

lights = Array.new(1000) { |_| Array.new(1000, 0) }

def toggle(light)
  light + 2
end

def turn_on(light)
  light + 1
end

def turn_off(light)
  [light - 1, 0].max
end

File.open('input.txt').each_line do |line|
  instructions = line.split
  action = nil
  offset = nil

  if instructions[0] == 'toggle'
    action = :toggle
    offset = 1
  elsif instructions[1] == 'on'
    action = :turn_on
    offset = 2
  elsif instructions[1] == 'off'
    action = :turn_off
    offset = 2
  else
    puts "invalid instructions: #{instructions}"
    exit 1
  end
  first = instructions[offset].split(',').map(&:to_i)
  last = instructions[offset + 2].split(',').map(&:to_i)

  (first[0]..last[0]).each do |x|
    (first[1]..last[1]).each do |y|
      lights[x][y] = method(action).call(lights[x][y])
    end
  end
end

puts lights.flatten.sum # => 17836115
