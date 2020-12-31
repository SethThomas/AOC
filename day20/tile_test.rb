require './tile.rb'

RSpec.describe Tile do
  before do
    data = [".*.",
            "**.",
            "*.*"]
    @tile = Tile.new(:id=>1,:data=> data )
  end

  describe "#edges" do
    it "reads edges clockwise" do
      expect(@tile.edges).to eql([".*.","..*","*.*",".**"])
    end
  end

  describe "#edge_at" do
    it "returns an edge given a direction" do
      expect(@tile.edges).to eql ([".*.","..*","*.*",".**"])
    end
  end

  describe "#rotate!" do
    before do
      data = ["111",
              "222",
              "333"]
      @tile = Tile.new(:id=>1,:data=> data )
    end
    it "rotates tiles clockwise" do
      @tile.rotate!
      expect(@tile.edges).to eql(["321", "111", "321", "333"])
    end
  end

  describe "#flip!" do
    it "flips the tile on it's axis" do
      @tile.flip!
      expect(@tile.edges).to eql([".*.", ".**", "*.*", "..*"])
    end
  end

  describe "#neighbor_of" do
    it "returns true if tiles share a side" do
      data = ["***",
              "**.",
              "***"]
      neighbor = Tile.new(:id=>2,:data=>data)
      expect(@tile.neighbor_of?(neighbor)).to eql(true)
    end
    it "returns true if flipped tile shares a side" do
      data = ["*..",
              "**.",
              "**."]
      neighbor = Tile.new(:id=>2,:data=>data)
      expect(@tile.neighbor_of?(neighbor)).to eql(true)
    end
    it "returns false if tiles don't share a side" do
      data = ["***","***","***"]
      neighbor = Tile.new(:id=>2,:data=>data)
      expect(@tile.neighbor_of?(neighbor)).to eql(false)
    end
    it "returns false if a tile is compared to itself" do
      expect(@tile.neighbor_of?(@tile)).to eql(false)
    end
  end

  describe "#orient" do
    before do
      data = ["**.",
              "**.",
              "***"]
      @tile = Tile.new(:id=>1,:data=> data )
    end
    it "rotates a tile until edge is facing the requested direction" do
      expect(@tile.orient!({:W=>"*.."})).to be(true)
      expect(@tile.edges).to eql(["***","***",".**","*.."])
    end
    it "flips a tile until edge is facing the requested direction" do
      expect(@tile.orient!({:W=>"*.."})).to be(true)
      expect(@tile.edges).to eql(["***","***",".**","*.."])
    end
    it "can orient multiple sides" do
      expect(@tile.orient!({:W=>"*..", :S=>".**"})).to be(true)
      expect(@tile.edges).to eql(["***","***",".**","*.."])
    end
  end

  describe "#shared_edge" do
    it "returns the shared edge if one exists" do
      data = ["***",
              "**.",
              "***"]
      neighbor = Tile.new(:id=>2,:data=>data)
      expect(@tile.shared_edge(neighbor)).to eql("*.*")
    end
    it "returns nil if no shared edge exists" do
      data = ["***",
              "***",
              "***"]
      neighbor = Tile.new(:id=>2,:data=>data)
      expect(@tile.shared_edge(neighbor)).to eql(nil)
    end
  end

  describe "#all_edges" do
    it "returns all combinations of edges" do
      expect(@tile.all_edges).to eql( [".*.", "..*", "*.*", ".**", "*..", "**."])
    end
  end

  describe "#to_s" do
    it "prints the tile row by row" do
      expect(@tile.to_s).to eql("---1---\n.*.\n**.\n*.*")
    end
  end

  describe "#strip" do
    before do
      data = ["*****",
              "*###*",
              "*###*",
              "*###*",
              "*****"]
      @tile = Tile.new(:id=>2,:data=>data)
    end
    it "removes outer edges of the tile" do
      @tile.strip!
      expect(@tile.data).to eql([["#","#","#"],["#","#","#"],["#","#","#"]])
      expect(@tile.edges).to eql(["###", "###", "###", "###"])
    end
  end

  describe "#image_coordinates" do
    before do
      @monster =
          ["..................#.",
           "#....##....##....###",
           ".#..#..#..#..#..#..."]
      @image = ["##",".#"]
    end
    it "returns cooridnates" do
      expect(@tile.image_coordinates(@image)).to eql([[0,0],[0,1],[1,1]])
    end
  end

  describe "#scan" do
    before do
      data = ["....",
              ".##.",
              "..#.",
              "...."]
      @image = ["##",
                ".#"]
      @tile = Tile.new(:id=>1,:data=> data )
    end
    it "counts the number of images in the tile" do
      expect(@tile.scan(@image)).to eql(1)
    end
    it "counts returns zero if no match is found" do
      expect(@tile.scan(["###","###"])).to eql(0)
    end
  end

  describe "#count" do
    it "returns the number of a specific character" do
      expect(@tile.count("*")).to eql(5)
    end
  end
end
