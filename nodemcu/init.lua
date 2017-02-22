buttonpin=3
ledpin=4

gpio.mode(ledpin,gpio.OUTPUT)
gpio.write(ledpin, gpio.LOW)

wifi.setmode(wifi.STATION)

-- in the house
--wifi.sta.config("SKYB2595","XNTRRWRQYB")

-- in the office
--wifi.sta.config("Mitchsoft","davethecat")

-- in Jules's house.    
wifi.sta.config("VM6339503","zdhzmcFCy2vr")

wifi.sta.connect()

print("Connecting to Wifi...")

tmr.alarm(1, 1000, 1, function()
    if wifi.sta.getip() == nil then
        print("IP unavaiable, Waiting...")
    else
        tmr.stop(1)
        gpio.write(ledpin, gpio.HIGH)
        --print("ESP8266 mode is: " .. wifi.getmode())
        --print("The module MAC address is: " .. wifi.ap.getmac())
        print("Connected, my IP is "..wifi.sta.getip())
        
        print("Now waiting for button presses on GPIO " .. buttonpin)
        gpio.mode(buttonpin, gpio.INT, gpio.PULLUP) -- see https://github.com/hackhitchin/esp8266-co-uk/pull/1
        gpio.trig(buttonpin, 'down', debounce(onChange))
    end
end)

function sendButtonPress()
  print("Sending a button press!")
  local socket =  net.createUDPSocket() 
  socket:send( 4950, "192.168.0.255", "doorbell-button-press")
end

function debounce (func)
    local last = 0
    local delay = 1500000

    return function (...)
        local now = tmr.now()
        local delta = now - last
        if delta < 0 then delta = delta + 2147483647 end; -- proposed because of delta rolling over, https://github.com/hackhitchin/esp8266-co-uk/issues/2
        if delta < delay then return end;

        last = now
        return func(...)
    end
end

function onChange ()
    --print('The pin value has changed')
    gpio.write(ledpin, gpio.LOW)
    sendButtonPress()
    gpio.write(ledpin, gpio.HIGH)
end
