# https://adventofcode.com/2020/day/8/

class Computer

  attr_reader :acc

  # ops = [["jmp",2], ["acc", -1],...]
  def initialize(ops)
    @ops = ops
    @seen = Array.new(ops.length, false)
    @acc,@cursor,@completed= 0,0,false
  end

  def execute!
    while @cursor < (@ops.length) && !@seen[@cursor] do
      op,num = @ops[@cursor]
      @seen[@cursor] = true
      @acc+=num if op.eql? "acc"
      @cursor += (num-1) if op.eql? "jmp"
      @cursor+=1
    end
  end

  def completed?
    @cursor == @ops.length
  end

end

# operations = [["jmp",2], ["acc", -1],...]
operations = File.readlines('input1.txt').map do |op|
  oper,num = op.match(/(^\w{3})\s([+-]\d+)/i).captures
  [oper,num.to_i]
end

# part 1
c = Computer.new(operations)
c.execute!
puts "Accumulator is #{c.acc}"

#part 2
ops_list, tmp = [],[]
# build all jmp/nop permutations of the program
operations.each_with_index do |oper,i|
  op,num = oper
  if op == "nop" || op == "jmp"
    tmp = operations.clone
    ops_list<< tmp
    tmp[i] = (op == "nop") ? ["jmp",num] : ["nop",num]
    ops_list<< tmp
  end
end

# test all permutations of the program
ops_list.map do |ops|
  c = Computer.new(ops)
  c.execute!
  if c.completed?
    puts "Accumulator is #{c.acc}"
  end
end
