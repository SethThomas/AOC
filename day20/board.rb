require 'set'

class Board

  attr_reader :tiles,:answer

  def initialize(tiles)
    @tiles = Set.new(tiles)
    @dimension = Math.sqrt(tiles.length)
    @answer = Array.new(@dimension){Array.new(@dimension)}
    @seen = Set.new
  end

  # builds an adjacency list mapping tiles to their neighbors
  # tile1 => [neighbor1,neighbor2,...], tile2=>[neighbor1,...]
  def neighbors
    @neighbors ||= Hash[@tiles.collect{|tile| [tile, neighbors_of(tile)]}]
  end

  # returns an array of neighboring tiles
  def neighbors_of(tile)
    @tiles.filter_map {|t| t if t.neighbor_of?(tile) }
  end

  # return array of corner tiles
  def corners
    @corners ||= neighbors.filter_map { |k,v| k if v.length == 2 }
  end

  def solve
    # Step 1: grab a corner
    corner = corners.first
    n1, n2 = neighbors[corner]
    se1,se2 = corner.shared_edge(n1),corner.shared_edge(n2)

    # rotate the corner until it is in the correct orientation for (0,0)
    # (hackity hack)
    corner.orient!({:E=>se1,:S=>se2}) ||
    corner.orient!({:E=>se1.reverse,:S=>se2}) ||
    corner.orient!({:E=>se1,:S=>se2.reverse}) ||
    corner.orient!({:E=>se1.reverse,:S=>se2.reverse})

    # Step 3: place the upper left puzzle piece
    @answer[0][0] = corner
    # Step 4: add the corner to the set of processed pieces (so we don't process again)
    @seen.add(corner)
    # recursively solve the rest of the puzzle
    solver(corner,0,0)
  end

  def solver(tile,row,col)
    return if tile.nil?
    neighbors[tile].each do |n|
      unless @seen.include?(n)
        # if the neighbor fits east
        if n.orient!({:W=>tile.edge_at(:E)})
          @answer[row][col+1]=n
          @seen.add(n)
          solver(n,row,col+1)
        # if the tile fits south
        elsif n.orient!({:N=>tile.edge_at(:S)})
          @answer[row+1][col]=n
          @seen.add(n)
          solver(n,row+1,col)
        end
      end
    end
  end

  def to_s
    neighbors.map do |tile,neighbor|
      "#{tile.id}=>#{neighbor.map{|n| n.id}}"
    end.join("\n")
  end

  # prints grid of tile ID's
  def answer_to_s
    @answer.map do |row|
      row.map{|tile| tile.nil? ? "   X" :  tile.id }.join(",")
    end
  end

  def strip!
    answer.map do |row|
      row.map do |tile|
        tile.strip!
      end
    end
  end

  # stitch together 2D array of Tiles into a single 2D array of strings (sigh)
  def combine
    data_arr = @answer.map {|row| row.map { |t| t.data.map{|d| d.join("")}}}
    data_arr.map {|d| d.transpose }.flatten(1).map{|d| d.join}
  end

end
