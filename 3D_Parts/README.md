# Geeetech A10 3D Printed Modifications

This folder contains OpenSCAD models for modifcations to a Geeetech A10 (Ender 3 clone) 3D printer.

Each of these files contains multiple models for differing components as well as some test prints. The configuraion panel will allow changing of the part selected and options for these.

Some of the models within these are test components, and some elements of the options will not work with some of the models. Much of this is where I changed my intent as I changed pieces of this, and further work on this became irrelevant for me. There may also be variation in where tolerances were hard coded or measured and the overhang angle limits are mainly controlled for generation of some holes.

The files also place variation between the preview and the rendered object. This differences are primarily related to display of components to fit with this and detail level. Some may also rotate the part to a more optimal print orientation.

## Source material

The design for the box underneath the printer is a modification of the box designed by Michael Laws (Teaching Tech). A video regarding this is [here](https://www.youtube.com/watch?v=k83M5H796U8) and the design can be found on Thingiverse [here](https://www.thingiverse.com/thing:3688967).

## Files

**My attempts to create an alternate part cooler fan solution faced issues as discussed in the modification notes.**

  - Main_Casing
    - Left Box - This fits with the right box below the heat bed at the back of the printer to the left as viewed from the rear, holding a Raspberry Pi for control and a DC-DC buck converter.
    - Right Box - This also fits below the heat bed at the back, and holds the SKR control board with the option to connect a cable chain.
    - Left Lid - Likely severely outdated, as I opted not to use a 3d printed option for this.
    - Right Lid - Again, likely severly outdated.
    - Holder Lid - A cover to fit over a DC-DC buck converter used to power the Raspberry Pi within the "left" box.
    - DispFront - A casing to fit a control display I have been working on, but not completed.
    - DispMount - A casing to mount the control display. Very much a work in progress.
    - TestPow - A test print to check the fit of the XT60 DC power connector.
    - TestPi - A test panel to check the holes for access to the Raspberry Pi interfaces.
    - TestDcDC - A test print for mounting the buck converter.
    - TestChain - Originally used to test the connection for the chain links. Very much broken at the moment.
  - Supporting_Components
    - Endcap - A replacement endcap for the v slot rails
    - Crosspiece - Used to mitigate XY skew with this printer
    - Ruler - Used to measure distances from the V slot
    - RailTest - A test piece to check tolerance on the design of the V slot rail
    - ZChainLower - A mounting to link the bottom fo a cable chain for the Z Axis screw
    - BedChainAdapter - Old, previously used to provide an adapter between a 3D printed cable chain and a pre-made chain.
  - Upper_Components
    - Holder - An alternate mounting for a 3D touch sensor
    - Y max - A holder to mount a Y max switch above the Y axis belt
    - Z chain - A fitting to hold the upper end of a cable chain on the Z Axis
    - Z max - A fitting to hold a Z Max limit switch alongisde the filament runout sensor mounting
    - swcover - Top of a cover to match a limit switch
    - swbase - Bottom of a cover to match a limit switch
  - PartCooler
    - Integrated - An attempt to provide a single piece part cooler with a 5015 fan instead of the original 4010 fan.
    - Adapter - Conversion from a 4010 fan to a 5015 fan for the part cooler, aiming to use the same connection as the original.
    - Airguide - An attempt to produce an alternate guide for the part cooler.

# Licencing


Shield: [![CC BY 4.0][cc-by-shield]][cc-by]

This work is licensed under a
[Creative Commons Attribution 4.0 International License][cc-by].

[![CC BY 4.0][cc-by-image]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg