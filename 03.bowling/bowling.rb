#!/usr/bin/env ruby

# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each_with_index do |frame, i|
  if i > 8
    point += frame.sum
  elsif frame[0] == 10 # strike
    point += 10 + frames[i + 1].sum
    point += frames[i + 2][0] if frames[i + 1][0] == 10
  elsif frame.sum == 10 # spare
    point += 10 + frames[i + 1][0]
  else
    point += frame.sum
  end
end
puts point