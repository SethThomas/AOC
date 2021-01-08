require 'set'

class Image

  attr_reader :assembled_image

  def initialize(tiles:)
    @tiles = Set.new(tiles)
    @dimension = Math.sqrt(tiles.size)
    @assembled_image = Array.new(@dimension){Array.new(@dimension)}
  end

  def reassemble!
    # Step 1: pick any corner
    corner = corners.first
    # Step 2: rotate corner into position
    se1,se2 = neighbors[corner].map{|n|corner.shared_edges(n)}
    8.times do |i|
      break if se1.include?(corner.edge_at(:E)) && se2.include?(corner.edge_at(:S))
      i == 3 ? corner.flip! : corner.rotate!
    end
    # Step 3: place the corner piece and mark it as processed
    place_tile(tile:corner,row:0,col:0)
    # Step 4: solve the rest of the puzzle
    orient!(tile: corner, row:0, col:0)
    export_image
  end

  # recursively place tiles
  def orient!(tile:,row:,col:)
    return if row >= @dimension || col >= @dimension
    neighbors[tile].each do |t|
      unless @seen.include?(t)
        if t.has_edge?(tile.edge_at(:E))
          t.arrange!(:W, tile.edge_at(:E))
          place_tile(tile: t, row: row, col: col+1)
          orient!(tile: t,row: row, col: col+1)
        elsif t.has_edge?(tile.edge_at(:S))
          t.arrange!(:N, tile.edge_at(:S))
          place_tile(tile: t, row: row+1, col: col)
          orient!(tile: t,row: row+1, col: col)
        end
      end
    end
  end

  def place_tile(tile:,row:,col:)
    @seen ||= Set.new()
    @assembled_image[row][col]=tile
    @seen.add(tile)
  end

  # return a hash of tiles to their neighbors (an adjacency list)
  def neighbors
    @neighbors ||= @tiles.map{|tile| [tile, neighbors_of(tile)]}.to_h
  end

  def neighbors_of(tile)
    @tiles.filter_map { |t| t if tile.neighbor_of?(t) }
  end

  def corners
    neighbors.select{|tile,neighbors| neighbors.length == 2 }.keys
  end

  # combine a board of tiles into a single Tile
  def export_image
    @assembled_image.map{|row|row.map(&:remove_borders)}.flat_map(&:transpose).map(&:join)
  end

  # print 2D array of tile ID's
  def to_s
    @assembled_image.map {|row| row.map(&:id).join(",")}.join("\n")
  end

end
