# https://adventofcode.com/2020/day/6

# [["abc"], ["a", "b", "c"], ["ab", "ac"], ["a", "a", "a", "a"], ["b"]]
data = File.read("input1.txt").split("\n\n")

# "ab\nac" => ["abac"] => ["a","b","a","c"].uniq => ["a","b","c"].length = 3
sum = data.map {|g| g.gsub(/\n/, "").split("").uniq.length }.reduce(:+)
puts "Part 1 solution: #{sum}"

yesCount = 0
# break the file input into groups of answers
data.each do |group|
  # "ab\nac" => ["ab","ac"] => [["a","b"],["a","c"]] => ["a","b"] & ["a","c"] => ["a"].length
  yesCount += group.split("\n").map{|g| g.split("")}.reduce(:&).length
end

puts "Part 2 solution: #{yesCount}"
