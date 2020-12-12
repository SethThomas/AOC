# https://adventofcode.com/2020/day/12

class Ship
 COMPAS = ["N","E","S","W"].freeze

 def initialize(nav)
   @nav = nav
   @position = { x: 0, y: 0 }
   @heading = 1
 end

 # execute navigation instructions
 def navigate
   @nav.each do |instruction|
     action,num = instruction.match(/(^\w{1})(\d+)/i).captures
     if %w(N S E W).include?(action)
       move(action,num.to_i)
     elsif %w(L R).include?(action)
       turn(action,num.to_i)
     elsif action == "F"
       forward(num.to_i)
     end
   end
   self
 end

 def turn(dir, deg)
   turn_by = deg / 90
   move_by = (dir == "R") ? (@heading + turn_by) : (@heading - turn_by)
   @heading = move_by % COMPAS.length
 end

 def move(action, distance)
   @position[:y] += distance if action == "N"
   @position[:y] -= distance if action == "S"
   @position[:x] += distance if action == "E"
   @position[:x] -= distance if action == "W"
 end

 def forward(distance)
   @position[:y] += distance if COMPAS[@heading] == "N"
   @position[:y] -= distance if COMPAS[@heading] == "S"
   @position[:x] += distance if COMPAS[@heading] == "E"
   @position[:x] -= distance if COMPAS[@heading] == "W"
 end

 def distance
   @position[:x].abs + @position[:y].abs
 end
end

class ShipWithFancyNavGear < Ship

  def initialize(nav)
    super(nav)
    @waypoint = Waypoint.new(10,1)
  end

  def move(action,dist)
    @waypoint.move(action,dist)
  end

  def forward(distance)
    @position[:x] += @waypoint.x * distance
    @position[:y] += @waypoint.y * distance
  end

  def turn(dir, deg)
    @waypoint.rotate(dir,deg)
  end

end

class Waypoint
  attr_reader :x,:y

  def initialize(x,y)
    @x,@y = x,y
  end

  def rotate(dir,deg)
    (deg/90).times {@x,@y = -@y, @x } if dir == "L"
    (deg/90).times {@x,@y =  @y,-@x } if dir == "R"
  end

  def move(action,dist)
    @y += dist if action == "N"
    @y -= dist if action == "S"
    @x += dist if action == "E"
    @x -= dist if action == "W"
  end
end

data = File.readlines('input.txt')
# PART 1
puts "The ship traveled #{Ship.new(data).navigate.distance}"
# PART 2
puts "The ship traveled #{ShipWithFancyNavGear.new(data).navigate.distance}"
