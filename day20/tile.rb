class Tile

  attr_reader :id, :data

  def initialize(args)
    @id = args[:id]
    @data = args[:data].map{|a| a.split("")}
  end

  def edge_at(direction)
    @edge_at ||= {
      :N => -> {@data.first.join},
      :S => -> {@data.last.join},
      :E => -> {@data.map{ |r| r.last }.join},
      :W => -> {@data.map{ |r| r.first }.join},
    }
    @edge_at[direction].call
  end

  def edges
    [:N,:E,:S,:W].map{|dir| edge_at(dir) }
  end

  def all_edges
    @all_edges ||= (edges + edges.map{|e|e.reverse}).uniq
  end

  # returns true if tiles share a side in any orientation
  def neighbor_of?(tile)
    self != tile && !shared_edge(tile).nil?
  end

  # returns the shared edge
  def shared_edge(tile)
    (tile.edges & all_edges).first
  end

  # rotate tile right 90 degrees
  def rotate!
    @data = @data.transpose.map(&:reverse)
    self
  end

  # flip tile on the Y axis  [1,2,3] => [3,2,1]
  def flip!
    @data.map{|a| a.reverse! }
    self
  end

  # flip/rotate tile until edge is facing the desired directions
  # returns true if orientation was possible, false otherwise
  def orient!(args)
    1.upto(9) do |i|
      break if args.keys.map{ |direction| edge_at(direction) == args[direction] }.all?
      rotate!
      flip! if i % 4 == 0
    end
    args.keys.map{ |direction| edge_at(direction) == args[direction] }.all?
  end

  def strip!
    # remove the first row
    @data.shift
    #remove the last row
    @data.pop
    # remove the outer edges
    @data.each{|d| d.pop;d.shift}
  end

  def scan(image)
    coords = image_coordinates(image)
    height = coords.map(&:last).max
    width  = coords.map(&:first).max
    num = 0

    for x in 0..(@data.length - width-1) do
      for y in 0..(@data.length - height-1) do
        num+=1 if coords.map{|x1,y1| @data[x+x1][y+y1] == "#"}.reduce(:&)
      end
    end
    num
  end

  def image_coordinates(img)
    img.each_with_index.map do |row,x|
      (0...row.length).find_all{|i| row[i] == '#'}.map{|y| [x,y] }
    end.flatten(1)
  end

  def to_s
    ["---#{@id}---",
     @data.map{|row| row.join }].join("\n")
  end

  def count(char)
    @data.map{|row| row.count(char) }.reduce(:+)
  end

end
