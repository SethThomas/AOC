require "./tile.rb"
require "./board.rb"

tiles = []
File.read("input.txt").split("\n\n").each do |tile|
  tile_info = tile.split("\n")
  tile_id   = tile_info.first.delete("^0-9")
  tile_data = tile_info[1..-1]
  tiles << Tile.new(:id=>tile_id,:data=>tile_data)
end

board = Board.new(tiles)

# Part 1
puts "Part 1 answer: #{board.corners.map{|c| c.id.to_i }.reduce(:*)}"

# Part 2 Shenanigans
# solve the puzzle
board.solve
# remove borders of each tile
board.strip!
# create a new tile out of the combined Tiles
theAnswer = Tile.new(:id => "The Answer", :data=> board.combine)
monster = ["..................#.",
           "#....##....##....###",
           ".#..#..#..#..#..#..."]

num_monsters = theAnswer.scan(monster)
1.upto(9) do |i|
  break if num_monsters > 0
  theAnswer.rotate!
  theAnswer.flip! if i % 4 == 0
  num_monsters = theAnswer.scan(monster)
end

puts "There are #{num_monsters} monsters"
puts "Water roughness is #{theAnswer.count("#") - num_monsters*15}"
