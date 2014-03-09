require './app'

mp = MPFacialRecognition.new
mp = mp.get_id(ARGV[0])
p mp
