require './tile.rb'
require './image.rb'
require './tile_scanner.rb'
require 'benchmark'


tiles = File.read("input_lg.txt").split("\n\n").map do |data|
  tile = data.split("\n")
  Tile.new(id: tile.first.delete("^0-9"), data: tile[1..-1])
end
image = Image.new(tiles: tiles)

# Part 1
puts "Part 1: #{image.corners.map{|tile| tile.id.to_i }.reduce(:*)}"

# Part 2
monster_data = ["..................#.",
                "#....##....##....###",
                ".#..#..#..#..#..#..."]
monster_size = monster_data.map{|row| row.count("#")}.sum

reassembled_image = image.reassemble!
img_tile = Tile.new(id: 1234,data: reassembled_image)
monster = Tile.new(id: 666,data: monster_data)

scanner  = TileScanner.new(tile: img_tile, char: "#")
num_monsters = scanner.num_images(monster)
puts "Part 2: #{num_monsters} monsters, #{img_tile.count("#") - num_monsters*monster_size} roughness"
