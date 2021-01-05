require './tile.rb'
require './puzzle.rb'
require './image_scanner.rb'

tiles = File.read("input_lg.txt").split("\n\n").map do |data|
  tile = data.split("\n")
  Tile.new(:id=>tile.first.delete("^0-9"),:data=>tile[1..-1])
end
puzzle = Puzzle.new(:tiles=>tiles)

# Part 1
puts "Part 1: #{puzzle.corners.map{|tile| tile.id.to_i }.reduce(:*)}"

# Part 2
puzzle.solve
board = puzzle.as_tile
monster = ["..................#.",
           "#....##....##....###",
           ".#..#..#..#..#..#..."]

scanner = ImageScanner.new(:image=>monster)
num_monsters = scanner.num_images(board)
puts "Part 2: #{num_monsters} monsters, #{board.count("#") - num_monsters*15} roughness"
