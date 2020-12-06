# https://adventofcode.com/2020/day/6

# ["abc", "a\nb\nc", "ab\nac", "a\na\na\na", "b\n"]
data = File.read("input.txt").split("\n\n")

sum = data.map {|g| g.gsub(/\n/, "").split("").uniq.length }.reduce(:+)
puts "Part 1 solution: #{sum}"

yesCount = 0
data.each do |group|
  yesCount += group.split("\n").map{|g| g.split("")}.reduce(:&).length
end

puts "Part 2 solution: #{yesCount}"
