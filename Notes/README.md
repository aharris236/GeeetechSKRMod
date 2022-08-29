# Adaptation Notes on Geeetech A10

This is intended to outline the items that I tried or discovered during my attempts to modify a Geeetech A10 (Ender 3 clone) 3D printer.

Details listed below are believed to be correct but some of this is from some time ago - all details should be checked if attempting any of this.

## Modifications

I made the following changes to this printer

  - Replaced main board with a Big Tree Tech SKR 1.4 Turbo. This enabled the majority of the other modifications.
  - Replaced the control board with a Big Tree Tech TFT35 controller. This was principally due to the different connections and availability bundled with the main board. I primarily used this in the emulated 128x64 controller mode.
  - Replaced the motor drivers with TMC2209 drivers. This massively reduced the noise and improved the print quality.
  - Added a Raspberry Pi running Octoprint to control the printer. This massively changed the 3d printing experience for me.
  - Mounted the control board and Raspberry Pi in printed boxes at the back instead of the front.
  - Changed orientation of the Y Axis motor - the connector is awkwardly placed for fitting boxes at the rear.
  - Added a 3D touch sensor. Despite issues with setting up the bed levelling configuration options, this simplified life far further than I thought it would.
  - Added a glass bed. Primarily preference, but I found this much nicer than the original print surface.
  - Replaced the part cooling fan with a 5015 fan, as the original barely seemed to make a difference when running.
  - Connected the Raspberry Pi via the UART pins to the TFT connnection, getting rid of the external USB cable requirement. This cut down on issues with cables being disconnected accidentally.
  - Replaced the part cooling airguide after the original broke.
  - Removed Y and Z limit switches and switched to sensorless homing on X and Y axes. This reduced cabling and potential error sources, but I'm not sure if this has changed the accuracy.
  - Added a crossbar to the front to ensure that the Y axis V Slot is perpendicular to the frame.
  - Replaced the 3D touch mount. This brought the probe closer to the nozzle, but more importantly reduced issues with screws working loose.
  - Changed the extruder to a dual gear model. This has it's own set of intricacies, but overall I found it to be an improvement

I'm still planning on attempting the following changes:

 - Replacing the main board with an SKR 3. Primarily down to issues with flashing the SKR1.4, possibly due to me breaking the card slot, but this has prevented me attempting the other changes.
 - Adding and configuring a limit switch for Z Max, and considering testing these for the Y and X axes.
 - Replacing the TFT35 with a Mini12864. I never got around to properly mounting the TFT35 and cracked the screen.
 - Replacing the control panel with a full graphical LCD screen. Currenlty facing issues with use of SPI LCD connections on the SKR 3 board.
 - Attempting to make a portrait interface with the graphical LCD screen for personal preference on physical construction.
 - Using the Rotary encoder arrow buttons through a serial shift IC (similar to RepRapWorld keypad v1.0 unit).

## Mistakes/Errors

There were several things that I could have done better throughout this, with varying degrees of annoyance. Notably, I suspect that I damaged the control board MicroSD card slot during this, preventing me updating the firmware again on the SKR 1.4 board.

  - Not planning ahead far enough. The changes that I made during this work left me with some interesting issues with excess cabling. It's always worth having a little bit of slack to make life easier for assembly, but too much cable creates additional issues.
  - Attempting to design and 3D print a part cooler. While an interesting learning experience, I had several of these melt during subsequent use. This was highly annoying.
  - Not designing enough test pieces. It's much better to find an error after a 10 minute print than after a several hour print.
  - Not cleaning the Z screw. Not doing this led to z axis motion issues, which produced lines on print and incorrect heights of parts.
  - Not double or triple checking measurements. This massively slowed down the rate that I was able to work at when finding that one piece didn't quite fit.
  - Not accounting for tolerances throughout. The printer will never produce a piece that's an exact match to the design. Give some leeway for errors and life is a lot easier. I was mostly okay giving about 0.2mm either side of holes.

## Tools / Materials

Tools and materials that I found useful/necessary during this:

  - Crimping tool. The connectors in use are generally crimped on to cables.
  - Hex screwdrivers. Allen keys work, but a screwdriver is much easier. Mostly H3 or H4 heads.
  - Calipers. Almost essential for designing parts and verifying printer outputs. I used a digital set, but make sure that you look for repeatability as well as accuracy if purchasing some.
  - Four core cable. Most of this is fairly low power, but the motors can carry a couple of amps. I generally used four way ribbon cable and tore off one wire for three pin usages.
  - Additional screws / T nuts were a bonus.

## Fittings/connectors

The following details are generic. More specific details are below.

  - Screws are generally M3 or M2.5, with varying lengths. Where I added additional components I aimed to using matching screws and nuts where needed.
  - Majority of connections on boards are JST XH (2.5mm pitch) connectors, mostly 3 pin for sensors and 4 pin for motors. Some have additional pins
  - The connections for the motors are JST PH (2.0mm pitch) 6 pin connectors. Pins 2 and 5 are not connected. The two middle pins generally need to be swapped over. If the connectors are upside down, this just inverts the motor direction and can be corrected in the configuration.

### Printer fittings (original cabling)

#### Power supply
The power connector is an XT60 DC connector with a plug coming from the power supply, providing 24V DC. The power supply has an IEC 60320 C14 plug, to take a C13 connector, commonly known as a kettle lead. Voltage input is either 230 or 115V AC. 

#### Motors
The motors are all directly wired to the main control board, including the X axis motor, which moves with the Z axis.

The Y axis motor has the connector pointed downwards. This does not cause an issue with the original configuration, but blocks adding a box under this. The motor can be re-oriented to point this connector towards the front (or up or back) which will prevent this being an issue. It is held on by four bolts around the belt gear.

#### Limit switches
These are connected via JST XH 3 pin connectors and have +5V, Switch and Gnd pins. They include an LED to illuminate when triggered, and switch is connected to +5V when open (NC).

#### Fans
These are JST XH 2 pin connectors.

#### Heated bed

The heated bed uses a 2x3 Molex Micro fit socket (socket/plug looks reversed due to shroud on both ends) to attach it. This connector includes two positive (RED, pins 3&6) and negative (BLACK, pins 1&4) lines for the heater, and two wires (BLUE/GREEN, pins 2&5 (middle)) for the bed thermistor. The thermistor appears to be a standard 100k unit (type 1 in Marlin config).

#### Extruder/Hotend/Touch sensor/Filament sensor

The extruder and hotend are both connected via a cable loom. The filament runout and BLtouch connections are on JST XH connectors, with the remainder combined into a Molex Micro fit 2x6 header. This separates out to the extruder motor and filament runout sensor mounted by the Z Axis, and then continues to another Molex Micro fit 2x6 on the print head, where they are broken out to separate connectors. These consist of JST XH and JST PH 2 pin connectors, a 2.54mm pitch 5 pin header for the BL Touch and a 2 pole plug (possibly Camdenboss) for the heater. A pinout for these matches that given in [this post](https://www.geeetech.com/forum/viewtopic.php?t=61907). The BLTouch and filament runout connectors are JST PH, one 2 pin and one 3 pin for the BLTouch, and a 2 pin connector for the filament sensor.

The BLTouch pin header has three pins on the left (as viewed from rear) for the servo style control and then two pins for the sensor element. Unsure if sensor has polarity, but assuming black is negative. Pin order (from left as viewed from rear):

1. Gnd
2. 5V
3. Control(servo)
4. Sensor (-ve?)
5. Sensor (+ve?)

## Control boards

### Original mainboard / control panel

The original board (GT2560) is built for up to three extruders, with a common connector (Molex microfit 2x6) for each. Only having the A10 rather than A10M or A10T, I am unsure how this functions with heaters/thermistors for these. A pinout is available at [this post](https://www.geeetech.com/forum/viewtopic.php?t=61907).

Power is connected via an ATX 4 pin connector (pins 1&3). A cable is present in the original build to convert from the XT60 connector to the ATX connector.

The original control panel is connected via a 2x10 IDC connector. I have not investigated the connection to this, but I suspect that it would be similar to the EXP1/EXP2 connectors found in other printers, just amalagamated into one connection rather than two.

### BTT SKR 1.4 Turbo / 3

These boards appear to be physically similar form factors, but I still need to confirm if the USB and MicroSD card slots are exact matches. These boards support up to two extruders. Limit switch connections are present, but only appear to support one per axis. There may be a possibility to combine min/max limit switches onto a single connector, but this will require further investigation. Firmware updates are achieved through the MicroSD card.

**Be careful with the MicroSD card slot. I believe I damaged mine through an issue with the slot in the box either preventing the card connections or damaging the connection.**

The SKR 1.4 needs modification to the TMC2209 drivers due to extra pins being present. This is not necessary with the SKR 3, although jumpers need to be removed if using sensorless homing.

The processor on the SKR 3 board does not currently appear to be supported for LCD displays connected via SPI in Marlin 2.1.1, but it is possible that this may simply be a configuration issue.

### Differences

Severall additional capabilities are present on the SKR boards, including Neopixel support and serial control lines (incliding TFT). I am unsure if the original board crossed the wires in the motor connections or not.

Connectors for these boards are as follows:

| Role | Original | SKR 1.4 Turbo|
| --- | --- | --- |
| Power | ATX 4 pin | Screw terminals |
| Control panel | 2x10 IDC connector | Two 2x5 IDC connectors |
| Bed heater | Molex microfit 2x3 header | Screw terminals |
| Bed thermistor | Molex microfit 2x3 header | JST XH 2 pin |
| Hotend 0/1 heater | Molex microfit 2x6 header | Screw terminals |
| Hotend 0/1 thermistor | Molex microfit 2x6 header |JST XH 2 pin |
| Extruder 0/1 motor | Molex microfit 2x6 header | JST XH 4 pin |
| Motion axis motors | JST XH 4 pin | JST XH 4 pin (inc second Z axis connector) |
| motion axis closed loop system | Nil | 6 pin 2.54mm pitch header |
| Filament runout 0/1 | JST XH **2 pin** | JST XH **3 Pin** |
| Limit switches (x3) | JST XH 3 pin | JST XH 3 Pin|
| Fans | JST XH 2 pin | JST XH 2 pin |
| Neopixel | Nil | JST XH 3 pin |
| TFT Control | Nil | JST XH 5 pin |
| SPI header | Nil | 2x3 pin socket |
| I2C | Nil | 4 pin 2.54mm pitch header |

## Modification notes

### Crossbar / Skew correction

I faced issues with my printer discovering that an XY skew had developed. The front/back bar that the bed is mounted on is only held at the centre join above the left/right bar in the base. Adding a crossbar to the front (or rear if needed) attaching to both sides and the centre vslot holds this in place and keeps this component square, but this still has to be verified to ensure that the gantry is mounted perpendicular to the base to elimimate any skew.

Vertical skew (Y/Z) should be minimal due to power supply slot and Z motor holding this perpendicular to the base. While I would prefer to add a further support to this, options to do so are slightly limited with this construction.

### TMC2209 drivers

Placing TMC2209 drivers in the SKR 1.4 board has some overhead. If using the FYSETC drivers, a pin jumper needs to be placed at an angle as well as on the top of the driver. With the BTT driver, if **NOT** using sensorless homing, a pin needs to be removed or bent out of the way. This issue is resolved through the use of a DIAG jumper on the SKR 3 board.

### TFT35 control panel
The TFT35 has two modes of operation. It can emulate a 128x64 display and all control is performed through the EXP1/EXP2 2x5 IDC connectors, or it can be used as a control host through the serial link on the TFT port. In this operation it essentially replaces the control PC or OctoPrint.

I chose not to use the control host route, as I did not want a conflict between this device and the Raspberry Pi.

### Mini12864 panel

I am awaiting delivery of parts to test this, but configuration of this appears to change the Neopixel configuration to use this to control the backlight for the controller. Marlin configuration appears to offer potential for a secondary neopixel control option, but may need additional pin configurations put in place to achieve this with the Mini12864 panel in use.

### Raspberry Pi Power / UART

The SKR board can theoretically power a Raspberry Pi, and has a DCDC converter to plug in to the SKR to provide additional 5V power. To use this, connect the UART and power pins from either the TFT or I2C connectors. The TFT connector has a fifth pin to provide a reset button via this connector and can be left unplugged. This connector may have variations in orientation between SKR versions.

I chose to provide power to the Pi separately via a buck convertor connected to the XT60 power connector. In this case, only Gnd, TX and RX need to be connected between the two boards (with TX/RX swapped over).

### BLTouch / Clones

These are conencted via the PCB on the back of the print head, with the wiring loom connected to the appropriate points on the control board.

On the original printe rconstruction, a bracket is available on the left of the print head to hold this. This bracket can be adjusted up and down and is held in place with two screws. I found this to be an issue with the screws coming loose and leaving the sensor height varying after being knocked.

As a result, I designed an alternative mount to hold this at a fixed height directly against the cage around the hot end. This also had a bonus of bringing the probe offset down to 37mm, almost enough to permit sensing of the bed levelling screws (particularly the right hand side) without moving the head beyond the print area (2mm difference in offsets from right hand edge on my printer), and with the slight over reach possible on movement this should be enough to enable use of the bed tramming tool in Marlin. Due to firmeare flashing issues, this has not yet been tested.

### Casing

I fitted a new casing underneath the heatbed at the back of the printer. Although the front of the printer is also a match, there is a cutout under the centre bar for cabling that would prevent the boxes as designed in this project fitting directly.

**Note that care should be taken with the MicroSD card slot if fitting to these cases**. I have been unable to update the firmware on my board and suspect that I damaged the card reader fitting to this case, possibly due to the slot being in the casing and then screing the board down. I have expanded the slot for the MicroSD card since this, but this has not been tested.

Although I originally 3d printed lids for these cases, I have since decided to find an alternative route due to potential for heat from the boards ending up with warping of 3d printed lids.

### Part cooler

The original part cooling fan seemed fairly weak. After trying a couple of different 3d printed modifications I attempted to make my own to put a 5015 fan on this. After several issues with these melting due to proximity to the heater, I managed to get one that so far has been fairly stable, but this is something where I would probably suggest looking at an alternative.