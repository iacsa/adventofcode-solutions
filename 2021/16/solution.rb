#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-16 Parts 1 & 2

input_file = 'input.txt'

def parse_literal(input)
  value = 0
  batch_count = 0
  input.each_slice(5) do |batch|
    batch_count += 1
    value *= 16
    value += batch[1..].join.to_i(2)
    break if batch[0] == '0' # last batch
  end
  [value, input[5 * batch_count..], 0]
end

def parse_operator(input)
  version_sum = 0
  length_type = input[0]
  operands = []
  rest = nil
  case length_type
  when '1' # indicating number of packages
    length_in_packets = input[1...12].join.to_i(2)
    rest = input[12..]
    length_in_packets.times do
      value, rest, version_sum_part = parse_packet(rest)
      version_sum += version_sum_part
      operands << value
    end

  when '0' # indicating number of bits
    length_in_bits = input[1...16].join.to_i(2)
    rest = input[16..]
    original_length = rest.size
    until rest.size == original_length - length_in_bits
      value, rest, version_sum_part = parse_packet(rest)
      version_sum += version_sum_part
      operands << value
    end
  end

  [operands, rest, version_sum]
end

def parse_packet(input)
  version = input[...3].join.to_i(2)
  type = input[3...6].join.to_i(2)

  if type == 4 # literal number
    value, rest, _version_sum = parse_literal(input[6..])
    [value, rest, version]
  else # operator
    operands, rest, version_sum = parse_operator(input[6..])
    value = case type
            when 0
              operands.sum
            when 1
              operands.inject(1) { |a, b| a * b }
            when 2
              operands.min
            when 3
              operands.max
            when 5
              operands[0] > operands[1] ? 1 : 0
            when 6
              operands[0] < operands[1] ? 1 : 0
            when 7
              operands[0] == operands[1] ? 1 : 0
            end
    [value, rest, version_sum + version]
  end
end

input = File.read(input_file).to_i(16).to_s(2).chars

value, _, version_sum = parse_packet(input)

puts "Part 1: #{version_sum}"
puts "Part 2: #{value}"
