# https://adventofcode.com/2020/day/11

class WaitingArea

  attr_reader :seats, :history, :num_rows, :num_cols, :stabilized

  def initialize(seats)
    @seats = seats
    @history = [seats]
    @num_rows = seats.length - 1
    @num_cols = seats.first.length - 1
    @stabilized = false
  end

  def to_s
    seats.map{|r| r.to_s}
  end

  def neighborCoordinates
    [[1 , 0],[1 ,1],[1, -1], # row above
    [0, -1],        [0,  1], # nextdoor
    [-1, 0],[-1,1] ,[-1,-1]] # row below
  end

  def neighborsOf(row,col)
    seating = latestSeating
    neighborCoordinates.map do |cordX,cordY|
      x,y = row-cordX,col-cordY
      seating[x][y] if (0..num_rows).cover?(x) && (0..num_cols).cover?(y)
    end.compact
  end

  def numOccupiedSeats
    latestSeating.map {|r| r.count("#")}.reduce(:+)
  end

  def latestSeating
    history.last
  end


  def shuffle
    lastSeating = latestSeating
    newSeating = []
    for row in 0..num_rows
      newRow = lastSeating[row].clone
      for col in 0..num_cols
        numOcc = neighborsOf(row,col).count("#")
        if newRow[col] == "L" && numOcc == 0
          newRow[col]= "#"
        elsif newRow[col] == "#" && numOcc >= 5
          newRow[col]= "L"
        end
      end
      newSeating[row]= newRow
    end
    @stabilized = true if (newSeating - lastSeating).eql? []
    history<< newSeating
  end

  def shuffle2
    lastSeating = latestSeating
    newSeating = []
    for row in 0..num_rows
      newRow = lastSeating[row].clone
      for col in 0..num_cols
        numOcc = occupiedSeatsAt(lastSeating,row,col)
        if newRow[col] == "L" && numOcc == 0
          newRow[col]= "#"
        elsif newRow[col] == "#" && numOcc >= 5
          newRow[col]= "L"
        end
      end
      newSeating[row]= newRow
    end
    @stabilized = true if (newSeating - lastSeating).eql? []
    history<< newSeating
  end

  def occupiedSeatsAt(arr,row,col)
    [ firstSeenRight(arr,row,col),
      firstSeenLeft(arr,row,col),
      firstSeenUp(arr,row,col),
      firstSeenDown(arr,row,col),
      firstSeenULdiag(arr,row,col),
      firstSeenURdiag(arr,row,col),
      firstSeenDRdiag(arr,row,col),
      firstSeenDLdiag(arr,row,col) ].count("#")
  end

  def firstSeenDown(arr,row,col)
    return if row+1 == arr.length
    return arr[row+1][col] if arr[row+1][col] != "."
    firstSeenDown(arr,row+1,col)
  end

  def firstSeenUp(arr,row,col)
    return if row-1 < 0
    return arr[row-1][col] if arr[row-1][col] != "."
    firstSeenUp(arr,row-1,col)
  end

  def firstSeenLeft(arr,row,col)
    return if col-1 < 0
    return arr[row][col-1] if arr[row][col-1] != "."
    firstSeenLeft(arr,row,col-1)
  end

  def firstSeenRight(arr,row,col)
    return if col+1 > arr[row].length
    return arr[row][col+1] if arr[row][col+1] != "."
    firstSeenRight(arr,row,col+1)
  end

  def firstSeenULdiag(arr,row,col)
    return if row-1 < 0 || col-1 < 0
    return arr[row-1][col-1] if arr[row-1][col-1] != "."
    firstSeenULdiag(arr,row-1,col-1)
  end

  def firstSeenURdiag(arr,row,col)
    return if row-1 < 0 || col+1 > arr[row].length
    return arr[row-1][col+1] if arr[row-1][col+1] != "."
    firstSeenURdiag(arr,row-1,col+1)
  end

  def firstSeenDRdiag(arr,row,col)
    return if row+1 >= arr.length || col > arr[row].length
    return arr[row+1][col+1] if arr[row+1][col+1] != "."
    firstSeenDRdiag(arr,row+1,col+1)
  end

  def firstSeenDLdiag(arr,row,col)
    return if row >= arr.length - 1 || col <= 0
    return arr[row+1][col-1] if arr[row+1][col-1] != "."
    firstSeenDLdiag(arr,row+1,col-1)
  end

end


#Part 1
waitingArea= File.readlines('input.txt').each { |line| line.chomp!.split("")}
area = WaitingArea.new(waitingArea)
while area.stabilized == false
  area.shuffle
end
puts "You have #{area.numOccupiedSeats} occupied seats"

## PART 2
area = WaitingArea.new(waitingArea)

i = 1
while area.stabilized == false
  area.shuffle2
end

puts "You have #{area.numOccupiedSeats} occupied seats"
