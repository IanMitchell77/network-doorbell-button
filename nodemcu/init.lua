wifi.setmode(wifi.STATION)
-- in the house
--wifi.sta.config("SKYB2595","XNTRRWRQYB")

-- in the office
wifi.sta.config("Mitchsoft","davethecat")

wifi.sta.connect()
tmr.alarm(1, 1000, 1, function()
    if wifi.sta.getip() == nil then
        print("IP unavaiable, Waiting...")
    else
        tmr.stop(1)
        print("ESP8266 mode is: " .. wifi.getmode())
        print("The module MAC address is: " .. wifi.ap.getmac())
        print("Config done, IP is "..wifi.sta.getip())

        print("The gpio is: " ..gpio.read(2))
        

        sendButtonPress()
        
    end
end)

function sendButtonPress()
  print("Sending a button press!")
  local socket =  net.createUDPSocket() 
  socket:send( 4950, "192.168.0.255", "doorbell-button-press")
end
