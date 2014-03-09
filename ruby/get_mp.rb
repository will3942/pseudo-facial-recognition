require './app'

mp = MPFacialRecognition.new
mp = mp.get_mp(ARGV[0])
p mp
