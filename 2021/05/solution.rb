#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-05 Parts 1 & 2

# Data class representing a point in two dimensions
class Point
  attr_reader :x, :y

  def initialize(coordinates)
    @x, @y = coordinates.split(',').map(&:to_i)
  end
end

# Iterable over the points of a line segment
class LineSegment
  def initialize(point1, point2)
    @point1 = point1
    @point2 = point2
  end

  def each(ignore_diagonals: false, &block)
    xs = @point1.x..@point2.x
    ys = @point1.y..@point2.y

    xs = xs.step(-1) if xs.size.zero?
    ys = ys.step(-1) if ys.size.zero?

    return [].to_enum if ignore_diagonals && xs.size > 1 && ys.size > 1

    xs = xs.cycle(ys.size) if xs.size == 1
    ys = ys.cycle(xs.size) if ys.size == 1

    xs.zip(ys).each(&block)
  end
end

# A 2-dimensional plane
class Plane
  def initialize
    @points = []
  end

  def mark(line)
    line.each do |x, y|
      @points[x] ||= []
      @points[x][y] = (@points[x][y] || 0) + 1
    end
  end

  def dangerous_points
    @points.flatten.map { |v| v && v > 1 ? 1 : 0 }.sum
  end
end

input_file = 'input.txt'
plane_part1 = Plane.new
plane_part2 = Plane.new

File.open(input_file).each_line do |line|
  points = line.split('->').map { |coordinates| Point.new(coordinates) }
  line = LineSegment.new(*points)

  plane_part1.mark(line.each(ignore_diagonals: true))
  plane_part2.mark(line)
end

puts "Part 1: #{plane_part1.dangerous_points}"
puts "Part 2: #{plane_part2.dangerous_points}"
