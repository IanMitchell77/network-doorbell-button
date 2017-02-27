--define the gpio pins
--the flash button on the dev board
buttonpin=3
--the led on the dev board
ledpin=4

--set wifi details
-- in Jules's house. 
--ssid="VM6339503"
--key="zdhzmcFCy2vr"
-- in the house
--ssid="SKYB2595"
--key="XNTRRWRQYB"
-- in the office
ssid="Mitchsoft"
key="davethecat"

--turn on the led
gpio.mode(ledpin,gpio.OUTPUT)
gpio.write(ledpin, gpio.LOW)

--tell the wifi modlule that it is a station
wifi.setmode(wifi.STATION)

--connect to wifi
wifi.sta.config(ssid,key)
wifi.sta.connect()
print("Connecting to "..ssid)

tmr.alarm(1, 1000, 1, function()
    if wifi.sta.getip() == nil then
        print("IP unavaiable, Waiting...")
    else
        tmr.stop(1)
	--turn the led off
        gpio.write(ledpin, gpio.HIGH)
        --print("ESP8266 mode is: " .. wifi.getmode())
        --print("The module MAC address is: " .. wifi.ap.getmac())
        print("Connected, my IP is "..wifi.sta.getip())
        print("Now waiting for button presses on GPIO " .. buttonpin)
	--setup the button gpio to use the internal pullup
        gpio.mode(buttonpin, gpio.INT, gpio.PULLUP) -- see https://github.com/hackhitchin/esp8266-co-uk/pull/1
	--setup and register the interrupt
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
    --flash the led
    gpio.write(ledpin, gpio.LOW)
    sendButtonPress()
    gpio.write(ledpin, gpio.HIGH)
end
