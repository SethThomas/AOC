# checks for the existence of an image (2D array of strings)
# in a Tile (also a 2D array of strings)
class ImageScanner

  # :image - 2D array containing image
  def initialize(args)
    @image = args[:image]
    @char  = args[:char] || "#"
    @max_y = img_coords.map(&:last).max
    @max_x = img_coords.map(&:first).max
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
    8.times.map do |i|
      i == 4 ? tile.flip! : tile.rotate!
      tile.refresh!
      scan(tile)
    end
  end

  # check for occurances of image in the tiles current orientation
  def scan(tile)
    num_images = 0
    for x in 0..(tile.data.length - @max_x-1) do
      for y in 0..(tile.data.length - @max_y-1) do
        num_images+=1 if img_coords.map{|x1,y1| tile.data[x+x1][y+y1] == @char }.all?
      end
    end
    num_images
  end

end
