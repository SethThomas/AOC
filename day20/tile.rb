require 'set'

class Tile

  attr_reader :id, :length, :width

  NUM_SIDES = 4
  SIDES = {:N=>0,:E=>1,:S=>2,:W=>3}
  EDGE_LABELS =  %i[a b c d e f g h]
  EDGE_STATES = [%i[a b c d e d g b], # 0°
                 %i[h a f c d c b a], # 90°
                 %i[g h e f c f a h], # 180°
                 %i[b g d e f e h g]] # 270°

  def initialize(id:,data:)
    @id = id
    @data = data.freeze
    @flipped,@num_rotations = false,0
  end

  def all_edges
    @all_edges ||= begin
      # N E S W edges
      edges = [ @data.first,@data.map{|r|r[-1]}.join,
                @data.last ,@data.map{|r|r[0]}.join ]
      Set.new(edges+edges.map(&:reverse))
    end
  end

  # rotate tile 90 degrees clockwise
  def rotate!
    @num_rotations = (@num_rotations+1) % NUM_SIDES
  end

  # flip tile on the Y axis
  def flip!
    @flipped = !@flipped
  end

  # returns the edge for the given label
  # e.g. :a maps to the North edge, :b maps to the East edge, etc
  def edge_for(label)
    @edge_hash ||= EDGE_LABELS.zip(all_edges).to_h
    @edge_hash[label]
  end

  # returns the edge at the specified direction (N S E W)
  def edge_at(direction)
    edge_index = @flipped ? SIDES[direction] + NUM_SIDES : SIDES[direction]
    edge_for(EDGE_STATES[@num_rotations][edge_index])
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
      i == NUM_SIDES-1 ? flip! : rotate!
    end
  end

  def remove_borders
    data.dup[1..-2].map{|row| row.slice!(1..-2) }
  end

  def count(char)
    @data.map{|row| row.count(char) }.reduce(:+)
  end

  def length
    data.first.length
  end

  def width
    data.length
  end

  # returns copy of tile data based on flip status and current number of rotations
  def refresh
    d = @data.dup.map{ |row| row.split("") }
    @num_rotations.times { d = d.transpose.map(&:reverse) }
    d.map(&:reverse!) if @flipped
    d.map(&:join)
  end

  def data
    @data_cache ||= Hash.new {|h,k| h[k] = refresh }
    @data_cache[[@flipped,@num_rotations]]
  end

  def to_s
    data.join("\n")
  end

end
