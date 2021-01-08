require '../tile_scanner.rb'
require '../tile.rb'

RSpec.describe TileScanner do
  before do
    image_data = ["##",
                  ".#"]
    tile_data = ["......",
                 ".##...",
                 "..#...",
                 "..#....",
                 "......",
                 "##...#"]
    @tile = Tile.new(id: 1,data: tile_data )
    @image = Tile.new(id: 2,data: image_data )
    @scaner = TileScanner.new(tile: @tile, char: "#")
  end

  describe "#img_coordinates" do
    it "returns (x,y) coordinates for an image" do
      expect(@scaner.coordinates(@image.data)).to eql([[0,0],[0,1],[1,1]])
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
