---
title: MQTT as my home automation API
---

Seeing as it's all the fad right now to post about building offline smart homes, I figured I'd throw my cat into the ring as well and talk a bit about how I use [MQTT](https://mqtt.org/) as an API interface for my home automations. Specifically, how MQTT lets me create a rich experience across Z-Wave, Zigbee, Shelly, Sonos, NanoLeaf, HomeKit and other systems while giving me access to powerful automations. The big difference for me though, is how I do with without using HomeAssistant which seems to be an under-represented approach.

<!--more-->

#### some history

The story starts back in late 2016 or so, when [robacarp](https://robacarp.io/) convinced me to get a Z-Wave hub, specifically the  Vera (Now Ezlo) VeraPlus (now disconntinued). I picked up some Z-Wave plug-in outlets and a lamp controller to go with it. I did end up buying more plug-in outlet switches, as well as a lightswitch, door contact sensor and a little remote control. The remote control ended up being unreliable, it used capacitive-touch rather than physical buttons and gets triggered by just staring at it so it just lives in a box in the basement these days but everything else I'm still actively using.

This little hub worked well, but ultimately it felt more like a remotely controllable version of a mechanical timer rather than a helpful tool given the state of the mobile app at the time.

But that all changed when the HomeKit people attacked.

I dipped my toes into Apple's HomeKit system with an EcoBee thermostate a few months later and it was fantastic. The UI and integration with Siri is perfect for my needs. Finding that the Vera didn't integrate with HomeKit (at least at the time, that might have changed by now?) I started looking for other solutions that would allow me to keep my existing devices while making them available in HomeKit. This led to purchasing a little USB Z-Wave dongle (an [Aeotec Z-Stick Gen 5](https://aeotec.com/products/aeotec-z-stick-gen5/)) and the discovery of [HomeBridge](https://homebridge.io/) which allowed me to use a plugin to expose the Z-Wave devices to HomeKit using the dongle.

I could have used Home Assistant with the Vera hub directly and skipped a lot of this, but that's no fun. But really, Home Assistant just didn't jive with me and what I was looking for at the time, for what ever reason. And so I don't use it.

Eventually I wanted to add some more sensors into the mix so that I could start adding real smarts to the setup. Stuff like "turn off the HVAC if any of the windows are open" or "turn off the lights if no ones in the room for a bit." Somewhat unfortunately, however, Z-Wave sensors are a little pricey compared to other systems. A big part of this, I gather, is from the certification and licensing for the Z-Wave tech. The benifit is a solid system that works well and generally "just works" but at the expense of your wallet. Even today, a Z-Wave contact sensor runs around $30 while, for example, Zigbee ones tend to be $15 or less!

I didn't want to pay double the price just to put some sensors around my house, so this kicked off a whole new area of exploration into Zigbee devices. Once again I found a small USB dongle (a [ConBee II](https://phoscon.de/en/conbee2)) but didn't find a plugin for HomeBridge that I agreed with. This, coupled with some experiments into using [Node-Red](https://nodered.org/) for these smarter automations that HomeKit couldn't manage well, lead me to the discovery of the [Zigbee2Mqtt](https://www.zigbee2mqtt.io/) project.

#### the bus life

Zigbee2Mqtt does what it says on the tin. It reads data from the Zigbee network and dumps it onto an MQTT bus, and it'll read data from the MQTT bus and push it out to the Zigbee network, allowing you to read sensor data and control devices hooked up to your Zigbee network, all through MQTT and all in a real easy to work with fashion.

The discovery of this also led me to find [ZWave2Mqtt](https://github.com/OpenZWave/Zwave2Mqtt) as well as [Sonos2Mqtt](https://sonos2mqtt.svrooij.io/) which further brought more devices onto my MQTT bus, giving me a single backbone for my phsyical devices, regardless of what system they used or what they did.

The last bit of magic in this system was to get MQTT devices into HomeKit, but thankfully there is a really great plugin for HomeBridge, [HomeBridge MQTT-Thing](https://github.com/arachnetech/homebridge-mqttthing), which exposes a nice config driven way to hook MQTT topics to devices that'll show up in HomeKit. This comes with another beneifit as well, being able to make "virtual devices" that report data into or pull it out of HomeKit which can be helpful for devices that I can't get onto my MQTT bus easily.

With this in place, any automations that I wanted just have to be conncerned with communicating to and from the MQTT bus rather than needing to support a mess of protocols, drivers or third-party APIs. Indeed, with the exception of my NanoLeafs, Node-Red does the following for every automation: Read off of MQTT, do some processing on the value, and publish back to MQTT.

So as of today I run the following:
- A [Mosquito](https://mosquitto.org/) MQTT Broker
- [Zigbee2Mqtt](https://www.zigbee2mqtt.io/)
- [ZWave2Mqtt](https://github.com/OpenZWave/Zwave2Mqtt)
- [Sonos2Mqtt](https://sonos2mqtt.svrooij.io/)
- [HomeBridge](https://homebridge.io/) with the [HomeBridge MQTT-Thing](https://github.com/arachnetech/homebridge-mqttthing) Plugin
-  [Node-Red](https://nodered.org/)
	-  Plus some plugins like one for NanoLeaf.
