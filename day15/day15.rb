class MemoryGame

  def initialize(input)
    @input = input.clone
    @last_spoken = @input.pop
    # map of [last spoken number] => round when spoken
    @last_seen_at = @input.each_with_index.map {|num,i| [num,i+1] }.to_h
  end

  def num_spoken_at(num)
    for round in @input.length+1..num-1
      if seen_before? @last_spoken
        spoken = round - last_spoken_at(@last_spoken)
      else
        spoken = 0
      end
      @last_seen_at[@last_spoken] = round
      @last_spoken = spoken
    end
    @last_spoken
  end

  def seen_before?(num)
    @last_seen_at.has_key?(num)
  end

  def last_spoken_at(num)
    @last_seen_at[num]
  end

end

input = File.read('input.txt').chop.split(",").collect!(&:to_i)

mg1 = MemoryGame.new(input)
puts "Part 1 answer is #{mg1.num_spoken_at(2020)}"

mg2 = MemoryGame.new(input)
puts "Part 2 answer is #{mg2.num_spoken_at(30000000)}"
