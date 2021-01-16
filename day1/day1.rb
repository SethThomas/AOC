# https://adventofcode.com/2020/day/1
def pairSumTo(arr1, num)
  arr2 = arr1.map {|i| num - i}
  arr1 & arr2
end

def sumTo(arr, num, n)
  arr.combination(n).each {|a| return a if a.sum == num }
end

data = File.readlines('input1.txt').collect! &:to_i

# part 1
answer = sumTo(data,2020,2)
puts "#{answer[0]} + #{answer[1]} = #{answer.sum}"
puts "#{answer[0]} * #{answer[1]} = #{answer.reduce(&:*)}"

# part 2
answer = sumTo(data,2020,3)
puts "#{answer[0]} + #{answer[1]} = #{answer.sum}"
puts "#{answer[0]} * #{answer[1]} = #{answer.reduce(&:*)}"
