require 'bundler/setup'
Bundler.setup(:default)
require 'rmagick'
require 'json'
require 'open-uri'
require 'twfy'

class MPFacialRecognition
  def initialize
    @mps = JSON.parse(IO.read("mps.json"))
  end

  def is_mp(black, ambient)
    detection = black.to_f / ambient.to_f * 100.0
    detected = Hash.new
    @mps.each do |mp|
      image = Magick::ImageList.new
      image.from_blob(open(mp["image"]).read)
      image.resize!(40,60)
      image.quantize(2, Magick::GRAYColorspace, false)
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
        colors[pixel.to_color] = colors[pixel.to_color].to_f / 2400.0 * 100.0
      end
      if ((detection.to_f-10.0)..detection.to_f).include?(colors["black"]) or (detection.to_f..(detection.to_f + 10.0)).include?(colors["black"])
        detected[mp["name"]] = true
      end
    end
    if detected.nil?
      return false
    else
      return detected
    end
  end

  def get_mp(mp_name)
    client = Twfy::Client.new("BG75QxG2F6ApGg9NgREGKPjd")
    info = client.mps(search: mp_name)
    info = info[0]
    info = client.mp(id: info.person_id)
    info = info[0]
    url = info.image.to_s
    image = Magick::ImageList.new
    image.from_blob(open(url).read)
    image.resize!(40,60)
    image = image.quantize(2, Magick::GRAYColorspace, false)
    image.write("image/#{mp_name}.jpg")
    found = true
    return found
  end
end
