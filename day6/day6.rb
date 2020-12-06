# https://adventofcode.com/2020/day/6
data = File.read("input.txt").split("\n\n")

# "ab\nac" => "abac" => ["a","b","a","c"].uniq => ["a","b","c"].length = 3
sum = data.reduce(0) {|sum,g| sum + g.gsub(/\n/, "").split(//).uniq.length }
puts "Part 1 solution: #{sum}"

yesCount = 0
# break the file input into groups of answers
data.each do |group|
  # Step 1: "ab\nac" => [["a","b"],["a","c"]]
  answers = group.split("\n").map{|g| g.split("")}
  # Step 2: ["a","b"] & ["a","c"]  => ["a"]
  union = answers.reduce(answers.first,:&)
  # Step 3: ["a"]
  yesCount += union.length
end

puts "Part 2 solution: #{yesCount}"
