#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-10 Parts 1 & 2

input_file = 'input.txt'

class ParensError < StandardError
  attr_reader :value

  def initialize(msg: 'wrong closing parens', value:)
    super(msg)
    @value = value
  end
end

class Stack
  def initialize
    @state = []
  end

  def apply(parens)
    case parens
    when '(', '[', '{', '<'
      @state.push(parens)
    when ')'
      raise ParensError.new(value: 3) unless @state.pop == '('
    when ']'
      raise ParensError.new(value: 57) unless @state.pop == '['
    when '}'
      raise ParensError.new(value: 1_197) unless @state.pop == '{'
    when '>'
      raise ParensError.new(value: 25_137) unless @state.pop == '<'
    end
  end

  def value
    values = { '(' => 1, '[' => 2, '{' => 3, '<' => 4 }
    @state.reverse.inject(0) { |score, parens| score * 5 + values[parens] }
  end
end

sum_of_corrupt_lines = 0
scores_of_incomplete_lines = []

File.open(input_file).each_line do |line|
  stack = Stack.new
  begin
    line.strip.each_char do |char|
      stack.apply(char)
    end
    scores_of_incomplete_lines << stack.value if stack.value.positive?
  rescue ParensError => e
    sum_of_corrupt_lines += e.value
  end
end

# Part 1: Sum of the corrupt line scores
puts sum_of_corrupt_lines
# Part 2: Median of the incomplete line scores
puts scores_of_incomplete_lines.sort[scores_of_incomplete_lines.size / 2]
