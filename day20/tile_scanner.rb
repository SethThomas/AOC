# checks for the existence of an image (2D array of strings)
# in a Tile (also a 2D array of strings)
class TileScanner

  def initialize(tile:, char:)
    @char = char
    @data = tile.data
    @size = @data.size
  end

  # returns array of x,y coordinates of characters in the 2D image array
  def coordinates(image)
    image.each_with_index.flat_map do |row,x|
      (0...row.length).find_all{|i| row[i] == @char }.map{|y| [x,y] }
    end
  end

  def num_images(img)
    data = img.data
    num_images = 0
    8.times.map do |i|
      num_images = scan(img)
      break if num_images > 0
      i == 3 ? img.flip! : img.rotate!
    end
    num_images
  end

  # scans through the tile looking for images
  # images are matched one character at a time.
  # each match attempt is abandoned upon the first failed comparison
  def scan(img)
    num_images = 0
    img_height,img_width = img.length,img.width
    coords = coordinates(img.data)

    for x in 0..(@size - img_width-1) do
      for y in 0..(@size - img_height-1) do
        match = coords.map do |x1,y1|
          break [false] if @data[x+x1][y+y1] != @char
          true
        end
        num_images+=1 if match.all?
      end
    end
    num_images
  end

end
