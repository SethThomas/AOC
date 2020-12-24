# https://adventofcode.com/2020/day/23

class GameOfCups

  attr_reader :circle

  def initialize(data)
    @circle = CircleOfCups.new(data)
  end

  def play(num_moves)
    num_moves.times do
      # Step 1: pick three cups immediately clockwise of the current cup
      selected_cups = @circle.pick
      # Step 2: select a destination cup
      next_dest_cup = @circle.next_dest_cup
      # Step 3: place three cups immediately clockwise to the destination cup
      @circle.place(next_dest_cup,selected_cups)
      # Step 4: select new current cup
      @circle.next_curr_cup
    end
  end

end

# represent a circle of cups
# using a map of {cup => cup_neighbor}
class CircleOfCups

  # data is an array of integers
  def initialize(data)
    # [1,2,3] => {1=>2,2=>3}
    @cups = data.each_cons(2).to_h
    # connect tail and head
    @cups[data.last] = data.first
    @curr_cup = data.first
    @max_cup_value = data.sort.last
  end

  def pick
    cups_to_remove = next_tuple
    # update curr_cup neighbor reference
    @cups[@curr_cup] = @cups[cups_to_remove.last]
    cups_to_remove.each{|key| @cups.delete(key)}
  end

  # get next three cups
  def next_tuple
    [@cups[@curr_cup],
     @cups[@cups[@curr_cup]],
     @cups[@cups[@cups[@curr_cup]]]]
  end

  # insert cups clockwise starting from dest_cup
  def place(dest_cup,cups)
    tmp = @cups[dest_cup]
    @cups[dest_cup] = cups[0]
    @cups[cups[0]] = cups[1]
    @cups[cups[1]] = cups[2]
    @cups[cups[2]] = tmp
  end

  def next_curr_cup
    @curr_cup = @cups[@curr_cup]
  end

  def next_dest_cup
    @dest_cup = @curr_cup-1
    until @cups.has_key?(@dest_cup) do
      @dest_cup = @dest_cup <= 0 ? highest_cup : @dest_cup -= 1
    end
    @dest_cup
  end

  def highest_cup
    highest_num = @max_cup_value
    highest_num -= 1 until @cups.has_key?(highest_num)
    highest_num
  end

  # traverse(1) converts {7=>1,3=>7,1=>7} into [1,3,7]
  def traverse(head,curr=head)
    return [curr.to_s] if @cups[curr] == head
    return [curr.to_s] << traverse(head,@cups[curr])
  end

  # string of cup vales starting from given cup value
  def to_s(start_from=1)
    traverse(start_from).join(",")
  end

  def [](cup)
    @cups[cup]
  end

  def size
    @cups.length
  end

end

# Part 1
# answer at 100 rounds is 72496583
data = [3,1,5,6,7,9,8,2,4]
game = GameOfCups.new(data)
game.play(100)
puts "Part 1: #{game.circle}"

#Part 2
highest_number = data.sort.last+1
(highest_number..1_000_000).each {|num| data << num }
game = GameOfCups.new(data)
game.play(10_000_000)

puts "Part 2: #{game.circle[1] * game.circle[game.circle[1]]}"
