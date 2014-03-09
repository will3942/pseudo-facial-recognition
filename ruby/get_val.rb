require 'json'

if File.exist?("mp_conv/" + ARGV[0] + ".json")
  colors = JSON.parse(IO.read("mp_conv/" + ARGV[0] + ".json"))
  p colors["black"]
end
