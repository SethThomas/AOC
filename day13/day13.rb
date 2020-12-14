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

# def isMyTime(time, data)
#   data.map {|bus,position| runsAt(bus,position + time) }.all? true
# end
#
# def runsAt(bus, time)
#   (time % bus) == 0
# end

input = File.readlines('input_lg.txt')
data = {}
input.last.chop.split(",").each_with_index do |bus, index|
  data[bus.to_i]=index unless bus == "x"
end

data.map {|k,v| puts "(x + #{v}) mod #{k} = 0,"}
