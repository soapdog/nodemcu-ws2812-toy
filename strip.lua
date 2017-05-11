--[[
  WS2812 Toy
  Author: Andre Alves Garzia <andre@andregarzia.com>
  Date: 2017-05-11

  This is just a demo of WS2812, shining some LEDs with Lua. It plays three animations and stop.
  The code is quite naive, focused on creating very explicit and readable code even though it is
  spaghetti-ish.

  * Animation Strip Runner *
  The first animation, fills the strip with blue LEDs which run accross the strip and fade.

  * Animation Police *
  Blinks half the LED in Red and half in Blue, alternating, like a police lights.

  * Animation Rainbow *
  Randomize the colors of all LEDs and then animating them moving circularly in the strip.

  - All animations run for a number of iterations and then switch.
  - The animation is controlled using the timer module.
  - There are two functions for each animation:
    - one that starts it and schedule the timer.
    - one that animates it and is called by the timer on each iteration.

  REMEMBER TO READ THE MANUAL:
  URL: https://nodemcu.readthedocs.io/en/master/en/modules/ws2812/

  THE WS2812 MODULE:
  Has the pin D4 (NodeMCU) / 2 (ESP8266) hardcoded as where the strip is attached to. Use it.

  Be aware that even though WS2812 LEDs are called RGB LEDs, the order of the colors is not actually RGB, 
  it usually is GRB, don't ask me why.

]]

-- green, red, blue colors
local red = string.char(0,255,0)
local blue = string.char(0,0,255)
local black = string.char(0,0,0)

-- customize this to your own strip. (check NodeMCU WS2812 manual)
local numberOfLeds = 8
local bytesPerLed = 3


-- off(): Switch all LEDs off.
function off()
  local buffer = ws2812.newBuffer(numberOfLeds, bytesPerLed)
  buffer:fill(0,0,0)
  ws2812.write(buffer)
end

-- in case you need to cancel timers by hand
function cancelTimer() 
  timer:unregister()
  off()
  iterations = 0
end


function startAnimationPolice() 
  timer:unregister()
  off()
  iterations = 0
  timer = tmr.create()
  timer:alarm(500, tmr.ALARM_AUTO, animationPolice)
end


function startAnimationRainbow() 
  timer:unregister()
  off()
  iterations = 0

  for i = 1, 8 do
    math.randomseed(i)
    local r = math.random(1,20)
    local g = math.random(1,20)
    local b = math.random(1,20)

    buffer:set(i, g, r, b)
  end
  ws2812.write(buffer)

  timer = tmr.create()
  timer:alarm(200, tmr.ALARM_AUTO, animationRainbow)
end

function animationPolice()
  if i == 0 then
    i = 1
  end

  i = i * -1
  iterations = iterations + 1
  buffer:fill(0,0,0)

  if i < 0 then
    buffer:set(1, red)
    buffer:set(2, red)
    buffer:set(3, red)
    buffer:set(4, red)
    print("red")
  else
    buffer:set(5, blue)
    buffer:set(6, blue)
    buffer:set(7, blue)
    buffer:set(8, blue)
    print("blue")
  end

  ws2812.write(buffer)
  if iterations >= 10 then
    startAnimationRainbow()
  end
end

function animationStripRunner()
  i = i + 1
  iterations = iterations + 1
  buffer:fade(2)
  buffer:set(i % buffer:size() + 1, 0, 0, 255)
  ws2812.write(buffer)
  if iterations >= 50 then
    startAnimationPolice()
  end
end


function animationRainbow()
  iterations = iterations + 1
  buffer:shift(1, ws2812.SHIFT_CIRCULAR)
  ws2812.write(buffer)
  if iterations >= 50 then
    cancelTimer()
  end
end

function startAnimationStripRunner()
  timer = tmr.create()
  timer:alarm(50, tmr.ALARM_AUTO, animationStripRunner)
end

-- startAnimationStripRunner the program by initializing the ws2812 module and playing the first animation.

ws2812.init()
local timer
local i, buffer = 0, ws2812.newBuffer(numberOfLeds, bytesPerLed)
local iterations = 0

off()
startAnimationStripRunner()