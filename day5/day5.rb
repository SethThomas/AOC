# https://adventofcode.com/2020/day/5

class BoardingPass
  def initialize(pass, decodeStrategy)
    @boardingPass = decodeStrategy.decode(pass)
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

    # BFFFBBFRRR => 1000110111
    def self.decode(code)
      code.tr("FL","0").tr("BR","1")
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

seats = File.readlines('input1.txt').map { |pass|
  BoardingPass.new(pass, SeatingStrategies::BinarySpace).seat
}.sort!

missingSeat = seats.each_cons(2) do |seat1, seat2|
  break seat2 - 1 if ( seat2 - seat1 == 2 )
end

puts "Part 1: max seat ID is #{seats.last}"
puts "Part 2: your seat number is #{missingSeat}"
