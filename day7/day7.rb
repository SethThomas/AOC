# https://adventofcode.com/2020/day/7
require 'rgl/adjacency'
require 'rgl/path'

vertices = []
weights = Hash.new({})
edge_weights = {}

# File parsing madness.  Awful...
File.readlines('input_lg.txt').each do |line|
  bag,bag_contents = line.match(/(^\w+ \w+)\sbags\scontain\s(.*)/i).captures
  vertices << bag
  bag_contents.split(",").map do |contents|
    contents = contents.gsub(/bag[s]*[.]*/,"").strip
    unless contents.eql? "no other"
      freq,bag2 = contents.match(/(^\d+) (.*)/i).captures
      edge_weights[[bag2,bag]] = freq.to_i
      weights[bag] = weights[bag].merge(bag2 => freq.to_i)
    end
  end
end

# part 1. using RGL graph library for fun
def numPaths(start_from, vertices,edge_weights)
  graph = RGL::DirectedAdjacencyGraph.new
  graph.add_vertices vertices
  edge_weights.each { |(bag1, bag2), w| graph.add_edge(bag1, bag2) }

  num_paths = 0
  vertices.map do |vert|
    unless vert.eql?(start_from)
      num_paths+=1 if graph.path?(start_from,vert)
    end
  end
  num_paths
end

# part 2.
def bagCount(start,weights)
  return 0 unless weights.has_key? start
  weights[start].map {|k,v| v + (v * bagCount(k,weights))}.reduce(:+)
end

start_from ="shiny gold"
puts "Part 1: #{numPaths(start_from, vertices, edge_weights)}"
puts "Part 2: #{bagCount(start_from, weights)}"
