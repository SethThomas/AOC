# https://adventofcode.com/2020/day/9

class Scanner

  attr_reader :data, :window_size, :curr_index

  def initialize(data, window_size)
    @data, @window_size, @curr_index = data, window_size, 0
  end

  def scan(group_size)
    while curr_index + window_size < data.length
      slice = data[curr_index,window_size]
      sum_to = data[curr_index + window_size]
      break if !group_sums_to?(slice, sum_to, group_size)
      @curr_index = curr_index + 1
    end
    return data[curr_index + window_size]
  end

  # returns sub array of @data that sums to `target`
  def scan2(target)
    group_size = 2
    while group_size < data.length + 1
      while @curr_index + group_size < data.length
        slice = data[@curr_index,group_size]
        slice_sum = slice.reduce(:+)
        return slice if slice_sum == target
        @curr_index = @curr_index + 1
      end
      @curr_index = 0
      group_size = group_size + 1
    end
  end

  # sum each combination of size `groups_size`, break if `target` value is found
  def group_sums_to?(arr, target, group_size=1)
    arr.combination(group_size).each { |sub_arr| return true if sums_to?(sub_arr,target) }
    return false
  end

  # sum array elements break if sum becomes > target at any time
  def sums_to?(arr, target)
    arr.inject { |s, v| break s if s + v > target ; s+v} == target
  end

end

data = File.readlines('input1.txt').collect! &:to_i

# Part 1
window_size, group_by_size = 25, 2
s = Scanner.new(data,window_size)
part1_result = s.scan(group_by_size)
puts "Part 1: #{part1_result}"

# Part 2
s = Scanner.new(data, data.length)
result_arr = s.scan2(part1_result)
if result_arr.nil?
  puts "Part 2: No sub array sums to #{part1_result}"
else
  result_arr.sort!
  puts "Part 2: #{result_arr.first + result_arr.last}"
end
