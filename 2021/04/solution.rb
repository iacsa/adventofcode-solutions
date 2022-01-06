#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-04 Parts 1 & 2

# A class representing a bingo board an its logic
class BingoBoard
  def sum_of_unmarked_squares
    @board.flatten.sum
  end

  def initialize(board)
    @board = board
    @size = board.size
  end

  def mark(drawn_number)
    @board.map! { |row| row.map { |x| x == drawn_number ? 0 : x } }
  end

  def won?
    won_row? || won_column?
  end

  def won_row?
    (0...@size).any? do |row|
      (0...@size).all? { |col| @board[row][col].zero? }
    end
  end

  def won_column?
    (0...@size).any? do |col|
      (0...@size).all? { |row| @board[row][col].zero? }
    end
  end
end

input_file = 'input.txt'
drawn_numbers = nil
rows = []

File.open(input_file).each_line do |line|
  # First should be the drawn bingo numbers
  if !drawn_numbers
    drawn_numbers = line.split(',').map(&:to_i)

  else
    row = line.split.map(&:to_i)
    next if row.empty? # Skip the empty lines between the boards

    rows << row
  end
end

# Construct the boards from the rows
bingo_boards = rows.each_slice(5).map { |board| BingoBoard.new(board) }
scores = []

drawn_numbers.each do |drawn_number|
  bingo_boards.reject! do |bingo_board|
    bingo_board.mark(drawn_number)
    next unless bingo_board.won?

    score = drawn_number * bingo_board.sum_of_unmarked_squares
    scores << score
    true
  end
end

# Part 1: 69579
puts "First board to win has score #{scores[0]}"
# Part 2: 14877
puts "Last board to win has score #{scores[-1]}"
