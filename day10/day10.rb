# https://adventofcode.com/2020/day/10

adapters = File.readlines('input.txt').collect(&:to_i).sort

# PART 1
outlet = 0
my_device = adapters.last + 3
diff_arr = [outlet, *adapters, my_device].each_cons(2).map{ |a,b| b-a }
puts "Part 1 answer is #{diff_arr.count(1) * diff_arr.count(3)}"

# ## PART 2
# {adapter => number of paths to adapter}
num_paths_to = Hash.new(0)
# start with only one path to the outlet
num_paths_to[outlet] = 1

[outlet,*adapters].each do |adapter|
  [1,2,3].each do |hop|
    if ([*adapters,my_device].include?(adapter+hop))
      num_paths_to[adapter+hop] += num_paths_to[adapter]
    end
  end
end

puts "Part 2 answer is #{num_paths_to[my_device]}"
