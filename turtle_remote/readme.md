# Turtle Remote

Supercharge manual turtle control with this handy remote control-program for turtles. 

## The Idea

I came up with the idea when I decided to use my turtle as a pseudo-diamond pickaxe for 
gathering obsidian. While you surely can manually enter combinations of 
`turtle.digDown()`, `turtle.forward()` and `turtle.turnLeft()` into the interactive lua-prompt,
this gets quite tedious after some time, at least for me. So I decided to 
write a small little remote-control that utilizes the portability of advanced 
wirless pocket computers.

## The Setup

Required Hardware:
* an advanced wireless pocket computer
* a wireless (mining) turtle

Currently there is no support for refueling, so you'll have to keep an eye on that. However there is 
a label for the remote (the pocket computer) that shows the fuel-level of the turtle.

Required Software:
* my [buttons API](https://github.com/c1ty/ccstuff/tree/main/buttons) installed on the control-computer
* [rx.lua](rx.lua) installed on the turtle
* [tx.lua](tx.lua) installed on the control-computer

Make sure that both the turtle and the control-computer have an activated rednet-modem, as neither 
`tx.lua` nor `rx.lua` check/open a rednet connection.

## Usage

After installing all required software, you may fuel-up your turtle (not strictly required, unless you want 
to move it). Then you can run `rx.lua` on the turtle, after obtaining it's id via `id`. If 
`rx.lua` is running, you can start `tx.lua` on the control computer. You wille be prompted to enter the receiver 
id:
<p align="center">
    <img src="https://github.com/c1ty/ccstuff/raw/main/turtle_remote/images/id_prompt.png" width=300>
</p>

After entering the desired id, you are greeted with the following screen:

<p align="center">
    <img src="https://github.com/c1ty/ccstuff/raw/main/turtle_remote/images/remote_main.png" width=300>
</p>

I apologize for the busy layout. We have four main columns of action-buttons: `dig` for diggin, 
`mov` for movement, `det` for detection and `plc` for placement.

The digging buttons are labelled `D` for down, `U` for up and `F` for forward. Movement buttons are labelled 
`W` for forward, `S` for backwards, `U` for up and `D` for down. Additionally we have `R` for turning right and 
`L` for turning left. The labelling scheme for detection and placement is identical to 
diggin. 

Pressing the `x` in the top-right corner will exit the program on both the turtle and the control computer. Below the 
detection and movement columns is the info field. At startup, you'll only see the active connection id. Pressing the 
info button will provide you with the following view:
<p align="center">
    <img src="https://github.com/c1ty/ccstuff/raw/main/turtle_remote/images/info.png" width=300>
</p>
The field `fuel` represents the current fuel-level of the turtle. The 4 by 4 grid of numbers (here zeros)
represent the slots and the number of items in them.

## Future Plans

The code quality is sub-par, especially the communication part could be handled much more elegantly.
Furthermore I want to keep a list of recent connections. An even nicer feature I want to implement is 
some sort of connection reset, where the turtle keeps in receiving mode and waits for another connection-request by 
a control computer. 

The detection feature does actually call the corresponding functions on the turtle, however the response is not 
displayed at the control. Furthermore I'd like to be able to select the slot by selecting it via a popup numpad. 
At last, I want to get more inventory information via popups.