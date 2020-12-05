# https://adventofcode.com/2020/day/5

class BoardingPass
  def initialize(boardingPass, decodeStrategy)
    @boardingPass = decodeStrategy.decode(boardingPass)
    @decode = decodeStrategy
  end

  def row
    @row ||= @decode.row(@boardingPass)
  end

  def col
    @col ||= @decode.col(@boardingPass)
  end

  def seat
    @seat ||= @decode.seat(row,col)
  end
end

module SeatingStrategies

  # part 1 algorithm
  class BinarySpace
    @@conversions = {'B' => '1', 'F' => '0', 'R' => '1', 'L' => '0'}

    # BFFFBBFRRR => 1000110111
    def self.decode(code)
      code.gsub(Regexp.union(@@conversions.keys), @@conversions)
    end

    def self.row(code)
      code[0,7].to_i(2)
    end

    def self.col(code)
      code[7,10].to_i(2)
    end

    def self.seat(row,col)
      row * 8 + col
    end

  end
end

seatIds = File.readlines('input1.txt').map do |bpCode|
  BoardingPass.new(bpCode, SeatingStrategies::BinarySpace).seat
end

seatIds.sort!
puts "Part 1: max seat ID is #{seatIds.last}"

missingSeat = seatIds.each_cons(2) do |seat1, seat2|
  break seat2 - 1 if ( seat2 - seat1 == 2 )
end
puts "Part 2: your seat number is #{missingSeat}"
