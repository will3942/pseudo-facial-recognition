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
    p detection
    detected = Hash.new
    @mps.each do |mp|
      if File.exist?("mp_conv/" + mp["id"] + ".json")
        colors = JSON.parse(IO.read("mp_conv/" + mp["id"] + ".json"))
        if ((detection.to_f-0.4)..detection.to_f).include?(colors["black"].to_f) or (detection.to_f..(detection.to_f + 0.4)).include?(colors["black"].to_f)
          detected[mp["name"]] = colors["black"].to_f
        end
      end
    end
    if detected.nil?
      return false
    else
      detected = detected.sort_by {|v| (v[1].to_f - detection.to_f).abs}
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

  def get_id(mp_id)
    client = Twfy::Client.new("BG75QxG2F6ApGg9NgREGKPjd")
    info = client.mp(id: mp_id)
    info = info[0]
    p info.full_name
  end

  def sorter(v, lol)
    if v.to_f >= lol.to_f
      v.to_f - lol.to_f
    else
      lol.to_f - v.to_f
    end
  end
end
