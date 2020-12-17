# https://adventofcode.com/2020/day/17
require "matrix"

class PocketDimension

  attr_reader :space, :neighbor_coords

  def initialize(initial_state, dimensions=3)
    @space = Hash.new { |h, k| h[k] = "." }
    initial_state.each_with_index do |row, x_index|
      row.split("").each_with_index do |cube, y_index|
        coordinates = Vector.elements([x_index,y_index] + Array.new(dimensions-2){0})
        @space[coordinates] = cube
      end
    end
    @neighbor_coords = neighbor_coordinates(dimensions)
  end

  def cycle!
    new_state = {}
    cubes_to_inspect = @space.keys.map{|cube| neighbor_points_of(cube)}.flatten.uniq
    cubes_to_inspect.each do |cube|
      num_active_neighbors = neighbors_of(cube).count("#")
      if @space[cube] == "#" && !num_active_neighbors.between?(2,3)
        new_state[cube] = "."
      elsif @space[cube] == "." && num_active_neighbors == 3
        new_state[cube] = "#"
      end
    end
    @space.merge! new_state
  end

  def neighbors_of(cube)
    @neighbor_coords.map do |coord|
      @space[coord + cube]
    end
  end

  def neighbor_points_of(cube)
    @neighbor_coords.map do |coord|
      coord + cube
    end
  end

  def neighbor_coordinates(dimensions)
    # get all neighbor coordinates
    neighbor_coords = [-1,0,1].repeated_permutation(dimensions).to_a
    center_coord = [Array.new(dimensions){0}]
    permutations = (neighbor_coords - center_coord).map{|point| Vector.elements(point)}
  end

  def num_active_cubes
    @space.values.count("#")
  end
end


data = File.read("input.txt").split("\n")
#Part 1
pd = PocketDimension.new(data)
6.times { |i| pd.cycle! }
puts "Part 1 answer: #{pd.num_active_cubes}"

# Part 2
pd = PocketDimension.new(data,4)
6.times { |i| pd.cycle! }
puts "Part 2 answer: #{pd.num_active_cubes}"
