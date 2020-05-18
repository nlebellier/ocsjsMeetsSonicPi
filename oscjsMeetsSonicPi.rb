# nlb -18-05-2020
# test ocsjs

use_osc "localhost", 4560

##| To test inside Sonic Pi

live_loop :sendingNotesToHimSelf do
  #stop # delete this stop when you want to test
  osc "/play/note", [60, 62, 65, 72].tick, 1.5, 0.25
  sleep 1
end

live_loop :sendingHello do
  ##| send to localhost on the port indicated into use_osc
  osc "/msg", "salut"
  sleep 2
end

##| **********
##| LISTENERS


live_loop :receiverNotesFromOcsjs do
  # note the 4560 value
  data = sync "/osc*/play/note"
  ##| puts data
  synth :pluck, note: data[0], amp: data[1], sustain: data[2]
end

live_loop :receiverNotesFromSonicPiHimselm do
  data = sync "/osc*/play/note"
  
  synth :piano, note: data[0], amp: data[1], sustain: data[2]
end


live_loop :receiverMsg do
  
  d = sync "/osc*/msg"
  ##| puts data
  puts "---------------"
  puts d[0]
  puts "---------------"
end