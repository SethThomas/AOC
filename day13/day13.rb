# https://adventofcode.com/2020/day/13

## Part 1
def part1(input)
  time = input.first.to_i
  busses = input.last.split(",").reject{ |bus| bus == "x" }.map(&:to_i)

  diffs= busses.map{|bus| (((time / bus) * bus) + bus) - time}

  tmp = diffs.each_with_index.min
  time,next_bus = tmp.first,busses[tmp.last]

  puts "#{time} * #{next_bus} = #{time * next_bus}"
end


## Part 2

input = File.readlines('input.txt')
data = {}
input.last.chop.split(",").each_with_index do |bus, index|
  data[bus.to_i]=index unless bus == "x"
end

# Part 2 - Attempt 1, BRUTE FORCE.
# Works on sample inputs, but too slow for problem solution
# def isMyTime(time, data)
#   data.map {|bus,position| runsAt(bus,position + time) }.all? true
# end
#
def runsAt(bus, time)
  puts "does #{bus} run at #{time}?"
  (time % bus) == 0
end
#
# index = 0
# while true
#   break if isMyTime(index,data)
#   index +=1
# end
# puts "Index #{index}"

# Part 2 - Smarter
busses = data.keys
curr_bus = busses.first
jump_by = curr_bus
curr_time = curr_bus

for i in (1..busses.length-1) do
  # do a thing
end

# Part 2 - Rip Cord solution!
# print out the series of equations we need to solve (wolfram alpha input)
# data.map {|k,v| puts "(x + #{v}) mod #{k} = 0,"}
