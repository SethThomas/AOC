# checks for the existence of an image (2D array of strings)
# in a Tile (also a 2D array of strings)
class TileScanner

  # :image - 2D array containing image
  def initialize(args)
    @tile = args[:tile]
    @char = args[:char] || "#"
  end

  # returns array of x,y coordinates of characters in the 2D image array
  def img_coords(image)
    image.each_with_index.map do |row,x|
      (0...row.length).find_all{|i| row[i] == @char }.map{|y| [x,y] }
    end.flatten(1)
  end

  # returns number of images in tile. stops once a non-zero answer is found
  def num_images(image)
    num_images = 0
    8.times.map do |i|
      num_images = scan(image)
      break if num_images != 0
      i == 3 ? @tile.flip! : @tile.rotate!
    end
    num_images
  end

  # scans through the tile looking for images
  # images are matched one character at a time.
  # each match attempt is abandoned upon the first failed comparison
  def scan(image)
    img_height = image.first.length
    img_width = image.length
    num_images = 0
    data = @tile.data
    coords = img_coords(image)
    for x in 0..(data.length - img_width-1) do
      for y in 0..(data.length - img_height-1) do
        match = coords.map do |x1,y1|
          break [false] if data[x+x1][y+y1] != @char
          true
        end
        num_images+=1 if match.all?
      end
    end
    num_images
  end

end
