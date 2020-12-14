# https://adventofcode.com/2020/day/14

class Computer

  def initialize()
    @memory = {}
  end

  def decodeV1(mask, address, value)
    mask_arr = mask.split("")
    val_arr = convert(value).split("")
    new_val = mask_arr.each_with_index.map do |m, i|
      (m == "X") ? val_arr[i] : m
    end.join.to_i(2)
    @memory[address] = new_val
  end

  def decodeV2(mask, address, value)
    mask_arr = mask.split("")
    address_arr = convert(address).split("")

    # Step 1, apply mask to memory address
    masked_result = mask_arr.each_with_index.map do |m, i|
      m == "0" ? address_arr[i] :  m
    end.join

    # Step 2, load each combination of masked_result into memory
    combos(masked_result).each {|addy| @memory[addy.to_i(2)] = value.to_i }
  end

  # convert decimal string to 36 bit binary string
  def convert(value)
    value.to_i.to_s(2).rjust(36,"0")
  end

  def sum
    @memory.values.reduce(:+)
  end

  # X's replaced with 1's and 0's
  # combos("X00") => ["100","000"]
  # combos("X0X") => ["100","101","001","000"]
  def combos(str)
    return str if str.index("X") == nil
    return [combos(str.sub("X","1")), combos(str.sub("X","0"))].flatten
  end

end

data = File.readlines('input.txt')

part1 = Computer.new
part2 = Computer.new
mask = nil
data.each do |line|
  if line.start_with?("mask")
    mask = line.match(/^mask = (\w+)$/i).captures.first
  elsif line.start_with?("mem")
    address,value = line.match(/^mem\[(\d+)\] = (\d+)$/i).captures
    part1.decodeV1(mask, address, value)
    part2.decodeV2(mask, address, value)
  end
end

puts "Part 1: sum of addresses is #{part1.sum}"
puts "Part 2: sum of addresses is #{part2.sum}"
