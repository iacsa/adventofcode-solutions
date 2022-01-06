#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-13 Parts 1 & 2

input_file = 'input.txt'

MAX_X = 1311
MAX_Y = 895

class Map
  def initialize
    @map = Array.new(MAX_Y) { Array.new(MAX_X, false) }
  end

  def mark(row, column)
    @map[row][column] = true
  end

  def print_map
    @map.each do |row|
      row.each do |v|
        if v
          print '#'
        else
          print '.'
        end
      end
      puts
    end
  end

  def fold_up(row)
    (0...row).each do |r|
      @map[r] = @map[r].zip(@map[-r - 1]).map { |a, b| a || b }
    end
    @map = @map[0...row]
  end

  def fold_left(column)
    @map.map! do |row|
      (0...column).each { |col| row[col] ||= row[-col - 1] }
      row[0...column]
    end
  end

  def marked_cells
    @map.flatten.count(true)
  end
end

folded = false
map = Map.new
File.open(input_file).each_line do |line|
  if line.include?(',')
    column, row = line.split(',').map(&:to_i)
    map.mark(row, column)
  elsif line.include?('=')
    instruction, location = line.split('=')
    location = location.to_i
    if instruction == 'fold along x'
      map.fold_left(location)
    else
      map.fold_up(location)
    end
    unless folded
      puts map.marked_cells
      folded = true
    end
  end
end

map.print_map # => AHGCPGAU
