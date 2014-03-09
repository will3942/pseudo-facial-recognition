require 'bundler/setup'
Bundler.setup(:default)
require './app'
require 'serialport'

port_str = "/dev/tty.usbserial-A100FZD3"
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

@sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
@ambient = 0

def ask_question(q)
  puts q + " "
  print "Press enter when ready. "
  input = STDIN.gets.chomp
  v = 0
  while v < 10 do
    i = 0
    while i <= 10 do
      @ambient = @sp.gets.chomp
      i += 1
    end
    print (10 - v).to_s + " "
    sleep(1)
    v += 1
  end
  puts ""
end

def get_input(str)
  print str + ": "
  input = STDIN.gets.chomp
  unless input == "" or input == " "
    return input
  else
    return false
  end
end

def wait_enter
  print "Press enter to finish. "
  input = STDIN.gets.chomp
end

ask_question("Place white paper over sensor for 10 seconds.")
@ambient = @ambient.to_i
puts "Ambient light value is #{@ambient}"
vals = Array.new
s = 0
name = get_input("Please enter your name (FirstName LastName)")
puts "Please place ID on sensor."
@sp.write "0"

while true do
  while (i = @sp.gets.chomp) do
    if ((i.to_f - @ambient.to_f) / @ambient.to_f * 100.0).abs >= 20.0 and ((i.to_f - @ambient.to_f) / @ambient.to_f * 100.0) < 0.0
      puts "Continue holding."
      unless s <= 10
        mean = vals.inject{ |sum, el| sum + el }.to_f / vals.size
        mp = MPFacialRecognition.new
        mp = mp.is_mp(mean, @ambient, name)
        unless mp.empty?
          puts "Successfully authenticated as #{mp[0][0]}"
          @sp.write "1"
          wait_enter
          abort("Finished.")
        end
        vals.clear
        s = 0
      else
        vals.push(i.to_f)
        s += 1
      end
    end
  end
end

@sp.close
