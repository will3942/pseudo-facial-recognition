require 'bundler/setup'
Bundler.setup(:default)
require 'twfy'
require 'json'
require 'rmagick'
require 'open-uri'
require 'uri'
require 'miro'

client = Twfy::Client.new("BG75QxG2F6ApGg9NgREGKPjd")
#mps = Array.new
#client.mps.each do |mp|
#  info = client.mp(id: mp.person_id)
#  test = info[0]
#  name = test.full_name
#  id = mp.person_id
#  mps.push(:name => name, :image => "", :id => id)
#end

#puts mps.to_json

client.mps.each do |mp|
  info = client.mp(id: mp.person_id)
  test = info[0]
  name = test.full_name
  image_url =  test.image.to_s
  image = Magick::ImageList.new
  unless image_url == ""
    image.from_blob(open(image_url).read)
    image.resize!(8,12)
    image = image.quantize(2, Magick::GRAYColorspace, false)
    pixels = image.get_pixels(0,0,image.columns,image.rows)
    colors = Hash.new
    for pixel in pixels
      if colors[pixel.to_color].nil?
        colors[pixel.to_color] = 1
      else
        colors[pixel.to_color] = colors[pixel.to_color] + 1
      end
    end
    colors.each do |color|
      colors[color[0]] = color[1].to_f / pixels.count.to_f * 100.0
    end
    filename = File.basename(URI.parse(image_url).path)
    image.write("mp_conv/#{filename}")
    File.open("mp_conv/" + File.basename(filename, ".*")+".json", 'w') {|f| f.write("{\"black\":#{colors["black"]}, \"white\":0}") }
  end
end
