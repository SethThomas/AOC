require 'set'

class Tile

  attr_reader :data, :id

  NUM_EDGES = 4
  SIDES = {:N=>0,:E=>1,:S=>2,:W=>3}.freeze
  EDGE_LABELS =  %i(a b c d e f g h).freeze
  EDGE_STATES = [%i(a b c d e d g b),
                 %i(h a f c d c b a),
                 %i(g h e f c f a h),
                 %i(b g d e f e h g)].freeze

  def initialize(args)
    @id = args[:id]
    @data = args[:data].map{ |a| a.split("") }
    @edge_hash = EDGE_LABELS.zip(all_edges).to_h
    @tile_flipped,@tile_rotations = false,0
    @edge_flipped,@edge_rotations = false,0
  end

  # returns Set of all possible edge orientations
  def all_edges
    @all_edges ||= begin
      edges = [ @data.first.join,@data.map{ |r| r.last  }.join,
                @data.last.join, @data.map{ |r| r.first }.join]
      Set.new(edges+edges.map{|e|e.reverse})
    end
  end

  # rotate edges 90 degrees clockwise
  def rotate!
    @tile_rotations = (@tile_rotations+1) % NUM_EDGES
    @edge_rotations = (@edge_rotations+1) % NUM_EDGES
  end

  # flip edges on the Y axis
  def flip!
    @tile_flipped = !@tile_flipped
    @edge_flipped = !@edge_flipped
  end

  # returns the edge at the specified direction (N S E W)
  def edge_at(dir)
    side_offset = @edge_flipped ? SIDES[dir] + NUM_EDGES : SIDES[dir]
    @edge_hash[EDGE_STATES[@edge_rotations][side_offset]]
  end

  # returns true of self is a neighbor of tile, false otherwise
  def neighbor_of?(tile)
    self != tile && !shared_edges(tile).empty?
  end

  # returns shared edges between two tiles
  def shared_edges(tile)
    all_edges & tile.all_edges
  end

  # returns true if this tile has the given edge
  def has_edge?(edge)
    return all_edges.include?(edge)
  end

  # orient self with edge[direction] == edge
  def arrange!(dir,edge)
    return false unless has_edge?(edge)
    8.times do |i|
      return true if edge_at(dir) == edge
      i == NUM_EDGES-1 ? flip! : rotate!
    end
  end

  # return a copy of tile data with borders removed
  def remove_borders
    refresh!
    data = @data.clone
    # remove the first and last rows
    data.shift ; data.pop
    # remove the first and last characters of each row
    data.each{|row| row.pop;row.shift }
    # join array of characters into strings
    data.map{|row| row.join }
  end

  # return frequency of char in tile data
  def count(char)
    @data.map{|row| row.count(char) }.reduce(:+)
  end

  # keeps 2D data grid consistent with edge rotations and flips
  def refresh!
    @tile_rotations.times { @data = @data.transpose.map(&:reverse) }
    @data.map{|d| d.reverse! } if @tile_flipped
    @tile_rotations,@tile_flipped = 0, false
  end

  def to_s
    refresh!
    @data.map{|row| row.join }.join("\n")
  end
end
