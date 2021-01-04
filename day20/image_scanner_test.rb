require './image_scanner.rb'
require './tile.rb'

RSpec.describe ImageScanner do
  before do
    image = ["##",
             ".#"]
    @scaner = ImageScanner.new(:image=> image)
    tile_data = ["......",
                 ".##...",
                 "..#...",
                 "......",
                 "#...##",
                 "##...#"]
    @tile = Tile.new(:id=>1,:data=> tile_data )
  end

  describe "#img_coords" do
    it "returns (x,y) coordinates for an image" do
      expect(@scaner.img_coords).to eql([[0,0],[0,1],[1,1]])
    end
  end

  describe "#scan" do
    it "returns the number of images in a tiles current orientation" do
      expect(@scaner.scan(@tile)).to eql(2)
    end
  end

  describe "#num_images" do
    it "returns the number of images in all 8 tile orientations" do
      results = @scaner.num_images(@tile)
      # results of all 8 orientations
      expect(results.count(2)).to be(2)
      expect(results.count(1)).to be(2)
      expect(results.count(0)).to be(4)
    end
  end

end
