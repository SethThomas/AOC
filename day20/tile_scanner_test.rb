require './tile_scanner.rb'
require './tile.rb'

RSpec.describe TileScanner do
  before do
    @image = ["##",
             ".#"]
    tile_data = ["......",
                 ".##...",
                 "..#...",
                 "..#....",
                 "......",
                 "##...#"]
    @tile = Tile.new(:id=>1,:data=> tile_data )
    @scaner = TileScanner.new(:tile=>@tile)
  end

  describe "#img_coords" do
    it "returns (x,y) coordinates for an image" do
      expect(@scaner.img_coords(@image)).to eql([[0,0],[0,1],[1,1]])
    end
  end

  describe "#scan" do
    it "returns the number of images in a tiles current orientation" do
      expect(@scaner.scan(@image)).to eql(1)
    end
  end

  describe "#num_images" do
    it "returns the number of images in all 8 tile orientations" do
      expect(@scaner.num_images(@image)).to eql(1)
    end
  end

end
