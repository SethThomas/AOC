require 'set'

class Puzzle

  attr_reader :board

  def initialize(args)
    @tiles = Set.new(args[:tiles])
    @dimension = Math.sqrt(@tiles.length)
    @board = Array.new(@dimension){Array.new(@dimension)}
  end

  def solve
    # Step 1: pick any corner
    corner = corners.first
    # Step 2: rotate corner into position
    se1,se2 = neighbors[corner].map{|n|corner.shared_edges(n)}
    8.times do |i|
      break if se1.include?(corner.edge_at(:E)) && se2.include?(corner.edge_at(:S))
      i == 3 ? corner.flip! : corner.rotate!
    end
    # Step 3: place the corner piece and mark it as processed
    @board[0][0] = corner
    @seen = Set.new([corner])
    # Step 4: solve the rest of the puzzle
    solver({row:0, col:0,tile: corner})
  end

  # recursively place East and South neighbors
  # args - contains :row, :col and :tile arguments
  def solver(args)
    parent,row,col = args[:tile],args[:row],args[:col]

    return if row >= @dimension || col >= @dimension
    neighbors[parent].each do |t|
      unless @seen.include?(t)
        if t.has_edge?(parent.edge_at(:E))
          t.arrange!(:W, parent.edge_at(:E))
          @seen.add(t)
          @board[row][col+1] = t
          solver({row:row,col:col+1,tile: t})
        elsif t.has_edge?(parent.edge_at(:S))
          t.arrange!(:N, parent.edge_at(:S))
          @seen.add(t)
          @board[row+1][col] = t
          solver({row: row+1, col: col, tile: t})
        end
      end
    end
  end

  # return a hash of tiles to their neighbors (an adjacency list)
  def neighbors
    @neighbors ||= Hash[@tiles.collect{|tile| [tile, neighbors_of(tile)]}]
  end

  # return an array of neighbors for a given tile
  def neighbors_of(tile)
    @tiles.filter_map { |t| t if tile.neighbor_of?(t) }
  end

  # returns an array of corner tiles
  def corners
    neighbors.filter_map{|tile,neighbors| tile if neighbors.length == 2 }
  end

  # combine a board of tiles into a single Tile
  def as_tile
    data = @board.map do |row_of_tiles|
      # strip the borders from each tile in the row
      row_of_tiles.map{ |tile| tile.remove_borders }
    end.map{|d| d.transpose }.flatten(1).map{|d| d.join}
    Tile.new(:id=>1234,:data=>data)
  end

  # print 2D board of tile ID's
  def to_s
    @board.map do |row|
      row.map{|tile| tile.nil? ? "  X " :tile.id}.join(",")
    end.join("\n")
  end

end
