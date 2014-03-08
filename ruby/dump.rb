require 'bundler/setup'
Bundler.setup(:default)
require 'twfy'
require 'json'

client = Twfy::Client.new("BG75QxG2F6ApGg9NgREGKPjd")
mps = Array.new
client.mps.each do |mp|
  info = client.mp(id: mp.person_id)
  test = info[0]
  name = test.full_name
  image =  test.image.to_s
  unless image == ""
    mps.push({:name => name, :image => image})
  end
end

puts mps.to_json
