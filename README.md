# nodemcu-ws2812-toy
A little toy script using Lua for the NodeMCU to play with a WS2812 LED Strip

~~~
WS2812 Toy
Author: Andre Alves Garzia
Date: 2017-05-11
~~~

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

# REMEMBER TO READ THE MANUAL
URL: https://nodemcu.readthedocs.io/en/master/en/modules/ws2812/

# THE WS2812 MODULE
Has the pin D4 (NodeMCU) / 2 (ESP8266) hardcoded as where the strip is attached to. Use it.

Be aware that even though WS2812 LEDs are called RGB LEDs, the order of the colors is not actually RGB, 
it usually is GRB, don't ask me why.