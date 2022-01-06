#!/usr/bin/env ruby

# frozen_string_literal: true

# Target ruby version: 2.7.4

# Advent of Code challenge for 2021-12-17 Parts 1 & 2

# This is an interesting problem. The first step to the solution
# is noticing that the movement in x and y direction is independent.
# Of course x and y must be in the target ranges after the same
# number of steps. But changing y-velocity does not affect x-movement
# and vice-versa.

target_x = 244..303
target_y = -91..-54

# First, let's calculate some conservative bounds for the starting vx
# target_x is positive, so we definitely need to shoot forward
vx_min = 1
# We also know that we immediately overshoot dx for vx > dx
vx_max = target_x.max

# Now we calculate the possible x starting velocities
# can be at the correct x position
vx_possible = (vx_min..vx_max).select do |vx|
  x = 0
  while x <= target_x.max && vx.positive?
    x += vx
    vx -= 1
    break true if target_x.include?(x)
  end
end

# Next, do the same for the y-axis
# Let's do some very conservative bounds estimation for vy:
# We know that if vy_0 is positive, then after t = 2 * vy_0 we will reach y = 0
# again with vy_t = -vy_0. We will then overshoot target_y for vy_t > target_y
vy_max = -target_y.min
vy_min = target_y.min

vy_possible = (vy_max..vy_min).step(-1).select do |vy|
  y = 0
  time = 0
  while y >= target_y.min
    y += vy
    vy -= 1
    time += 1
    break true if target_y.include?(y)
  end
end

# We have calculated all possible vx_0 and vy_0 separately.
# This has reduced the search space enough, so that we can brute force the rest.
vxy_possible = vx_possible.product(vy_possible).select do |vx, vy|
  x = 0
  y = 0

  while x <= target_x.max && y >= target_y.min
    x += vx
    y += vy

    vx = [vx - 1, 0].max
    vy -= 1

    break true if target_x.include?(x) && target_y.include?(y)
  end
end

# With the maximum vy_0, we can calculate y_max
vy_max = vxy_possible.map { |_vx, vy| vy }.max
y_max = vy_max * (vy_max + 1) / 2

puts "Maximum y reached is #{y_max}"

puts "There are #{vxy_possible.count} possible trajectories"
