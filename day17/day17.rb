# https://adventofcode.com/2020/day/17
require "set"

class PocketDimension

  def initialize(initial_state, dimensions=3)
    @dimensions = dimensions
    @actives = Set.new
    initial_state.each_with_index do |row, x_index|
      row.split("").each_with_index do |cube, y_index|
        coordinates = [x_index,y_index] + Array.new(dimensions-2){0}
        @actives.add(coordinates) if cube =="#"
      end
    end
  end

  def cycle!
    new_state = Set.new
    neighbors = @actives.map { |active_cube| neighbors_of(active_cube) }
    neighbors.flatten(1).uniq.each do |neighbor|
      num_active = num_active_neighbors(neighbor)
      if isActive?(neighbor)
        if num_active.between?(2,3)
          new_state.add(neighbor)
        end
      elsif num_active == 3
          new_state.add(neighbor)
      end
    end
    @actives = new_state
  end

  def num_active_neighbors(cube)
    Set.new(neighbors_of(cube)).intersection(@actives).count
  end

  def isActive?(cube)
    @actives.include?(cube)
  end

  def neighbors_of(cube)
    neighbor_coordinates.map { |coord| coord.zip(cube).map{|a,b| a + b} }
  end

  def neighbor_coordinates
    @neighbor_coords ||= begin
      [-1,0,1].repeated_permutation(@dimensions).to_a - [Array.new(@dimensions){0}]
    end
  end

  def num_active_cubes
    @actives.size
  end
end

data = File.read("input.txt").split("\n")
#Part 1
pd = PocketDimension.new(data)
6.times { |i| pd.cycle! }
puts "Part 1 answer: #{pd.num_active_cubes}"

pd = PocketDimension.new(data,4)
6.times { |i| pd.cycle! }
puts "Part 2 answer: #{pd.num_active_cubes}"
