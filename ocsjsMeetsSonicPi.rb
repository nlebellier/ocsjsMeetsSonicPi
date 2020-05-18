# nlb -18-05-2020
# test ocsjs

use_osc "localhost", 51240

##| To test inside Sonic Pi

live_loop :sendingNotesToHimSelf do
  #stop # delete this stop when you want to test
  ##| osc_send "127.0.0.1", 51240, "/play/note", [60, 62, 65, 72].tick, 1.5, 0.25
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


live_loop :receiverNotes do
  data = sync "/osc:127.0.0.1:51240/play/note"
  ##| puts data
  synth :prophet, note: data[0], amp: data[1], sustain: data[2]
end

live_loop :receiverMsg do
  
  d = sync "/osc:127.0.0.1:51240/msg"
  ##| puts data
  puts "---------------"
  puts d[0]
  puts "---------------"
end