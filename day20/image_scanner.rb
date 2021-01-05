# checks for the existence of an image (2D array of strings)
# in a Tile (also a 2D array of strings)
class ImageScanner

  # :image - 2D array containing image
  def initialize(args)
    @image = args[:image]
    @char  = args[:char] || "#"
    @max_y = @image.first.length
    @max_x = @image.length
  end

  # returns array of x,y coordinates
  def img_coords
    @image_coordinates ||= begin
      @image.each_with_index.map do |row,x|
        (0...row.length).find_all{|i| row[i] == @char }.map{|y| [x,y] }
      end.flatten(1)
    end
  end

  # returns an array containing number of images in all 8 tile orientations
  def num_images(tile)
    num_images = 0
    8.times.map do |i|
      num_images = scan(tile)
      break if num_images != 0
      i == 3 ? tile.flip! : tile.rotate!
    end
    num_images
  end

  # scans through the tile looking for images
  # images are matched one character at a time.
  # an attempted match is abandoned upon the first failed comparison
  def scan(tile)
    num_images = 0
    data = tile.data
    for x in 0..(data.length - @max_x-1) do
      for y in 0..(data.length - @max_y-1) do
        match = img_coords.map do |x1,y1|
          break [false] if data[x+x1][y+y1] != @char
          true
        end
        num_images+=1 if match.all?
      end
    end
    num_images
  end

end
