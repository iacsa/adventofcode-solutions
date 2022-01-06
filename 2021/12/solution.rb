#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-12 Parts 1 & 2

input_file = 'input.txt'

class Cave
  def initialize(name)
    @name = name
    @size = name.downcase == name ? :small : :large
    @links = []
  end

  def add_link(other)
    @links << other
  end

  def explore(current_path, allow_revisiting: false)
    # terminal case of recursion
    return 1 if @name == 'end'

    # it's possible to visit a small cave twice if it's specified, but only once
    if @size == :small && current_path.include?(self)
      return 0 unless allow_revisiting && @name != 'start'

      allow_revisiting = false
    end

    current_path << self
    @links.map do |link|
      link.explore(current_path.dup, allow_revisiting: allow_revisiting)
    end.sum
  end
end

caves = {
  'start' => Cave.new('start'),
  'end' => Cave.new('end')
}

File.open(input_file).each_line do |line|
  name1, name2 = line.strip.split('-')
  caves[name1] = Cave.new(name1) unless caves.key?(name1)
  caves[name2] = Cave.new(name2) unless caves.key?(name2)

  caves[name1].add_link(caves[name2])
  caves[name2].add_link(caves[name1])
end

paths = caves['start'].explore([])
puts "Part 1: #{paths}"

paths = caves['start'].explore([], allow_revisiting: true)
puts "Part 2 (revisiting one small cave): #{paths}"
