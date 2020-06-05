# Fancy Lights

## Raspberry Pi IKEA Dioder Light Controller

A lockdown project.

### Features ( Current and TODO)
 - [x] Can control light colour
 - [x] Simple Web Interface
 - [ ] Light transitions / animations
 - [x] Real time control
 - [ ] Alexa Integration

---

### Usage 

Once installed on a Raspberry Pi, the control panel can be accessed at the IP of the Pi or, more conviniently, `http://nerves.local`

---
Uses the Elixir Nerves framework to create a firmware for the Raspberry Pi, and uses Pigpio to
generate PWM signals to control the LED Lights.

Pi connected to the DIODER controller using [these modifications](https://github.com/ffraenz/redoid). Soldering required.

Uses a Pheonix web interface to control the lights currently. Will implement using Liveview later, the current interface is the bare minimum to be controlable as doesn't work completely.

### Install
A Nerves 'poncho' project. **Requires** Elixir and Erlang to be installed.

Firmware for the Raspberry Pi Zero can be downloaded [here](https://github.com/th0mas/Fancy-Lights/releases)

To generate your own firmware:
```
git clone https://github.com/th0mas/Fancy-Lights
cd Fancy-Lights/fancy_lights_firmware
export MIX_TARGET=<Your Decvice Tag> # View supported devices
mix deps.get
mix firmware
mix firmware.burn # burn firmware to inserted SD Card
```

#### Suported Devices
Tested on a Raspberry Pi 0, should run on any Nerves supported raspberry pi.

More details here: https://hexdocs.pm/nerves/0.4.8/targets.html#supported-targets-and-systems

### Notes
Probaly not the most idiomatic Elixir code, this is my first Elixir project, it does, however, work. Works on my Raspberry Pi Zero W.

