#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-18 Parts 1 & 2

input_file = 'input.txt'

class Term
  def self.parse(string)
    # Early returns for Literals
    return Literal.new(string.to_i) unless string.start_with?('[')

    # Handling of Pairs

    # Ignore start and end brackets
    string = string[1..-2]

    # Find the comma that splits this pair
    open_brackets = 0
    _, comma = string.chars.each_with_index.find do |c, _|
      open_brackets += 1 if c == '['
      open_brackets -= 1 if c == ']'
      c == ',' && open_brackets.zero?
    end

    left = Term.parse(string[...comma])
    right = Term.parse(string[comma + 1..])
    Pair.new(left, right)
  end

  def self.reduce(term)
    # The reduction process is:
    # 1. Look for a term to EXPLODE
    # 2. Look for a term to SPLIT
    # If we find anything, start from the beginning again
    term.recurse_explode or term.recurse_split and reduce(term)
  end

  def self.add(term1, term2)
    result = Pair.new(term1, term2)
    reduce(result)
    result
  end
end

class Literal
  def initialize(value)
    @value = value
  end

  def copy
    Literal.new(@value)
  end

  def magnitude
    @value
  end

  def can_split?
    @value >= 10
  end

  def recurse_split
    false
  end

  def split
    left = Literal.new(@value / 2)
    right = Literal.new((@value / 2.0).ceil)
    Pair.new(left, right)
  end

  def can_explode?(_depth = 0)
    false
  end

  def recurse_explode(_depth = 0)
    false
  end

  def add_left(value)
    @value += value
  end

  def add_right(value)
    @value += value
  end
end

class Pair
  def initialize(left, right)
    @left = left
    @right = right
  end

  def copy
    Pair.new(@left.copy, @right.copy)
  end

  def magnitude
    3 * @left.magnitude + 2 * @right.magnitude
  end

  def can_split?
    false
  end

  def recurse_split
    if @left.can_split?
      @left = @left.split
      return true
    end

    return true if @left.recurse_split

    if @right.can_split?
      @right = @right.split
      return true
    end

    return true if @right.recurse_split

    false
  end

  def can_explode?(depth = 0)
    depth >= 4
  end

  def explode
    [@left.magnitude, @right.magnitude]
  end

  def recurse_explode(depth = 0)
    if @left.can_explode?(depth + 1)
      l, r = @left.explode
      @left = Literal.new(0)
      @right.add_left(r) if r.positive?
      return l.positive? ? [l, 0] : true
    end

    left_rec = @left.recurse_explode(depth + 1)
    return true if left_rec == true

    if left_rec
      l, r = left_rec
      @right.add_left(r) if r.positive?
      return l.positive? ? [l, 0] : true
    end

    if @right.can_explode?(depth + 1)
      l, r = @right.explode
      @right = Literal.new(0)
      @left.add_right(l) if l.positive?
      return r.positive? ? [0, r] : true
    end

    right_rec = @right.recurse_explode(depth + 1)
    return true if right_rec == true

    if right_rec
      l, r = right_rec
      @left.add_right(l) if l.positive?
      return r.positive? ? [0, r] : true
    end

    false
  end

  def add_left(value)
    @left.add_left(value)
  end

  def add_right(value)
    @right.add_right(value)
  end
end

terms = File.readlines(input_file).map { |line| Term.parse(line.strip) }

term = terms.inject(nil) do |term1, term2|
  term2 = term2.copy
  term1 ? Term.add(term1, term2) : term2
end
puts term.magnitude

# Terms are commutative in terms of magnitude,
# i.e. magnitude(a + b) = magnitude(b + a)
# So we only have to examine the unique combinations
magnitudes = terms.combination(2).map do |term1, term2|
  term1 = term1.copy
  term2 = term2.copy
  sum = Term.add(term1, term2)
  sum.magnitude
end
puts magnitudes.max
