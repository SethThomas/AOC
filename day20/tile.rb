require 'set'
class Tile

  attr_reader :data, :id

  NUM_EDGES = 4
  DIRS = {:N=>0,:E=>1,:S=>2,:W=>3}.freeze
  STATES = [%i(a b c d e d g b),
            %i(h a f c d c b a),
            %i(g h e f c f a h),
            %i(b g d e f e h g)].freeze

  def initialize(args)
    @id = args[:id]
    @data = args[:data].map{ |a| a.split("") }
    @edge_hash = %i(a b c d e f g h).zip(all_edges).to_h
    # these variables track the state of the 2D data array
    @flipped, @num_rotations = false, 0
    # these variables track the current tile orientation
    @flip_offset,@rotation_offset = false,0
  end

  # returns array of edges
  def edges
    STATES[@rotation].map{|sym| @edge_hash[sym] }
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
    @num_rotations = (@num_rotations+1) % NUM_EDGES
    @rotation_offset = (@rotation_offset+1) % NUM_EDGES
  end

  # flip edges on the Y axis
  def flip!
    @flipped = !@flipped
    @flip_offset = !@flip_offset
  end

  # returns the edge at the specified direction (N S E W)
  def edge_at(dir)
    dir_index = @flip_offset ? DIRS[dir] + NUM_EDGES : DIRS[dir]
    @edge_hash[STATES[@rotation_offset][dir_index]]
  end

  # returns true of self is a neighbor of tile, false otherwise
  def neighbor_of?(tile)
    self != tile && !shared_edges(tile).empty?
  end

  # returns shared edges between two tiles
  def shared_edges(tile)
    (all_edges & tile.all_edges)
  end

  # orient self with edge[direction] == edge
  # returns true if orientation is possible, false otherwise
  def fits?(dir,edge)
    return all_edges.include?(edge)
  end

  def arrange!(dir,edge)
    return false unless fits?(dir,edge)
    8.times do |i|
      return true if edge_at(dir) == edge
      i == NUM_EDGES-1 ? flip! : rotate!
    end
  end

  # return a copy of tile data with borders removed
  def strip
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
    @num_rotations.times { @data = @data.transpose.map(&:reverse) }
    @data.map{|d| d.reverse! } if @flipped
    @num_rotations,@flipped = 0, false
  end

  def to_s
    refresh!
    @data.map{|row| row.join }.join("\n")
  end
end
