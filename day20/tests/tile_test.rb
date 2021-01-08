require '../tile.rb'

RSpec.describe Tile do
  before do
    data = ["12",
            "45"]
    @tile = Tile.new(:id=>1,:data=> data )
  end

  describe "#edge_at", :focus=>true do
    it "returns the edge at a given position" do
      expect(@tile.edge_at(:N)).to eql ("12")
      expect(@tile.edge_at(:E)).to eql ("25")
      expect(@tile.edge_at(:S)).to eql ("45")
      expect(@tile.edge_at(:W)).to eql ("14")
    end
    it "works with flip!" do
      expect {@tile.flip!}.to change {@tile.edge_at(:N)}.from("12").to("21")
    end
    it "works with rotate!" do
      expect {@tile.rotate!}.to change {@tile.edge_at(:N)}.from("12").to("41")
    end
  end

  describe "#rotate!" do
    it "rotates edges positions" do
      expect {@tile.rotate!}.to change {@tile.edge_at(:N)}.from("12").to("41")
    end
    it "rotates edges positions" do
      expect {3.times{ @tile.rotate!}}.
      to change {@tile.edge_at(:W)}.from("14").to("21")
    end
  end

  describe "#flip!" do
    # 12    21
    # 45 => 54
    it "flips the tile on it's y axis" do
      @tile.flip!
      expect(@tile.edge_at(:N)).to eql ("21")
      expect(@tile.edge_at(:E)).to eql ("14")
      expect(@tile.edge_at(:S)).to eql ("54")
      expect(@tile.edge_at(:W)).to eql ("25")
    end
    it "two flips don't modify the tile" do
      expect { 2.times {@tile.flip!} }.to_not change { @tile.edge_at(:N) }
    end
  end

  describe "#to_s" do
    it "returns a formatted string with heading" do
      result = ["12","45"].join("\n")
      expect(@tile.to_s).to eql(result)
    end
    it "optionally prints a header with the tile id" do
      result = ["12","45"].join("\n")
      expect(@tile.to_s).to eql(result)
    end
    it "handles rotate!" do
      @tile.rotate!
      result = ["41","52"].join("\n")
      expect(@tile.to_s).to eql(result)
    end
    it "handles flip!" do
      @tile.flip!
      result = ["21","54"].join("\n")
      expect(@tile.to_s).to eql(result)
    end
  end

  describe "#neighbor_of" do
    before do
      @neighbor = Tile.new(:id=>2,:data=>["12","88"])
    end
    it "returns true if tiles share a side" do
      expect(@tile.neighbor_of?(@neighbor)).to eql(true)
    end
    it "returns true if the tile is fliped share a side" do
      @neighbor.flip!
      expect(@tile.neighbor_of?(@neighbor)).to eql(true)
    end
    it "returns false if tiles don't share a side" do
      neighbor = Tile.new(:id=>2,:data=>["88","88"])
      expect(@tile.neighbor_of?(neighbor)).to eql(false)
    end
    it "returns false if a tile is compared to itself" do
      expect(@tile.neighbor_of?(@tile)).to eql(false)
    end
  end

  describe "#shared_edges" do
    it "returns an array of all orientations of shared edges" do
      neighbor = Tile.new(:id=>2,:data=>["12","88"])
      expect(@tile.shared_edges(neighbor).to_a).to eql(["12", "21"])
    end
    it "returns an empty array if there are no shared edges" do
      neighbor = Tile.new(:id=>2,:data=>["88","88"])
      expect(@tile.shared_edges(neighbor).to_a).to eql([])
    end
  end

  describe "#has_edge?" do
    it "returns true if the requested orientation is possible" do
      expect(@tile.has_edge?("25")).to be(true)
    end
    it "returns false if the requested orientation is not" do
      expect(@tile.has_edge?("XX")).to be(false)
    end
  end

  describe "#arrange" do
    it "it rotates tile into the requested orientation" do
      expect {@tile.arrange!(:W,"25") }.to change {@tile.edge_at(:W)}.from("14").to("25")
    end
    it "it flips tile into the requested orientation" do
      expect {@tile.arrange!(:W,"52") }.to change {@tile.edge_at(:W)}.from("14").to("52")
    end
    it "returns false if the tile cannot be arranged as requested" do
      expect(@tile.arrange!(:W,"XX")).to be(false)
    end
  end

  describe "#remove_borders" do
    before do
      data = ["****",
              "*..*",
              "*..*",
              "****"]
      @tile = Tile.new(:id=>1,:data=> data )
    end
    it "returns a borderless tile", :focus=>true do
      expect(@tile.remove_borders).to eql(["..",".."])
    end
  end

end
