require '../image.rb'
require '../tile.rb'

RSpec.describe Image do

  before do
    @tiles = File.read("../input.txt").split("\n\n").map do |data|
      tile = data.split("\n")
      Tile.new(:id=>tile.first.delete("^0-9"),:data=>tile[1..-1])
    end
    @image = Image.new(:tiles=>@tiles)
    @t2311 = @tiles.first
  end

  describe "#corners" do
    it "returns all corner pieces" do
      expect(@image.corners.map{|t|t.id}).to eql(["1951", "1171", "2971", "3079"])
    end
  end

  describe "#neighbors" do
    it "builds an adjacency list of tiles" do
      expect(@image.neighbors[@t2311].map{|t|t.id}).to eql(["1951", "1427", "3079"])
    end
  end

  describe "#neighbors_of" do
    it "returns an array of neighboring tiles" do
      expect(@image.neighbors_of(@t2311).map{|t|t.id}).to eql(["1951", "1427", "3079"])
    end
  end

  describe "#reassemble" do
    it "reassembles the tiles into a single image" do
      @image.reassemble!
      board_ids = @image.assembled_image.map{|row| row.map{|tile| tile.id }}
      expect(board_ids).to eql([["1951", "2311", "3079"],
                                ["2729", "1427", "2473"],
                                ["2971", "1489", "1171"]])
    end
  end


end
