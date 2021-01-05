require './tile.rb'
require './puzzle.rb'
require './tile_scanner.rb'

tiles = File.read("input_lg.txt").split("\n\n").map do |data|
  tile = data.split("\n")
  Tile.new(:id=>tile.first.delete("^0-9"),:data=>tile[1..-1])
end
puzzle = Puzzle.new(:tiles=>tiles)

# Part 1
puts "Part 1: #{puzzle.corners.map{|tile| tile.id.to_i }.reduce(:*)}"

# Part 2
combined_image = puzzle.solution
monster = ["..................#.",
           "#....##....##....###",
           ".#..#..#..#..#..#..."]
scanner = TileScanner.new(:tile=>combined_image)
num_monsters = scanner.num_images(monster)
monster_size = monster.map{|row| row.count("#")}.sum
puts "Part 2: #{num_monsters} monsters, #{combined_image.count("#") - num_monsters*monster_size} roughness"
