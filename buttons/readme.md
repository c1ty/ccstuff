# Buttons API

A very crude and rudimentary buttons API. Since I like to implement graphical interfaces with 
clickable buttons very much, I wanted to write a simple, yet effective API for creating buttons and 
having them perform actions when clicked. 

## How it works

The API provides a global `buttons` table that may only be indirectly be accessed via API calls, namely 
`add_toggle_button()` and `add_action_button()`. More on these functions later. After you 
added some buttons, you need to call the `draw_all()` function which iterates over `buttons` and 
draws them in order to the current screen. If you want to want to register a button press, call the
`check_click()` function, which waits for a `mouse_click` os-event. If one fires, the 
click-coordinates are checked against all registered buttons in `buttons`. If one is found, the 
corresponding action is performed. Toggle buttons are toggled and action-buttons flash shortly and their 
respective actions is called.

## How to use it

The two main functions you need are `add_action_button()` and `add_toggle_button()`. Adding buttons requires some 
common elements, like:
* position
* size
* text
* colors

Additionally, you need to specify a key to identify the button. **Keep in mind, that the API does not 
prevent you from adding duplicate ids**. You can use the ID of a button, i.e. a toggle-button, to read it's state via 
`buttons.buttons[id]["state"]`. The two functions have the following signatures (in pseudo-code):

```
add_action_button(id, x, y, width, height, msg, action, color, color_flash, fg)
add_toggle_button(id, x, y, width, height, msg, color_active, color_inactive, fg)
```

| Paramater      | Type     | Description                | Button Type |
|----------------|----------|----------------------------|-------------|
| id             | string   | id for later referencing   | both        |
| x              | int      | top-left x-coordinate      | both        |
| y              | int      | top-left y-coordinate      | both        |
| width          | int      | button width               | both        |
| height         | int      | button height              | both        |
| msg            | string   | text to display on button  | both        |
| action         | function | gets called on click       | action      |
| color          | int      | normal display color       | action      |
| color_flash    | int      | color flashes when pressed | action      |
| fg             | int      | foreground color           | both        |
| color_active   | int      | draw-color for state=true  | toggle      |
| color_inactive | int      | draw-color for state=false | toggle      |

### Simple Usage example
```lua
os.loadAPI("buttons")

local rcond = true

local function hi()
    term.setCursorPos(1,1)
    write("Hello World")
end

local function exit()
    rcond = false
end

screenx, screeny = term.getSize()
buttons.add_action_button("hw", 2, 2, 5, 3, "Hi", hi, colors.lime, colors.green, colors.black)
buttons.add_action_button("exit", screenx, 1, 1, 1, "x", exit, colors.red, colors.red, colors.white)
buttons.add_action_button("clear", 8, 2, 5, 3, "clear", term.clear, colors.purple, colors.magenta, colors.white)
buttons.add_toggle_button("toggle", 2, 6, 7, 3, "toggle", colors.lightBlue, colors.blue, colors.white)

term.clear()
while rcond do
    buttons.draw_all()
    term.setCursorPos(2,9)
    write(tostring(buttons.buttons["toggle"]["state"]) .. "  ")
    buttons.check_click()
end
```
Below is the view in a pocket-computer when you start the program.
<p align="center">
    <img src="https://github.com/c1ty/ccstuff/raw/main/buttons/images/example_startup.png" width="300">
</p>

If you toggle `toggle` by clicking on it:
<p align="center">
    <img src="https://github.com/c1ty/ccstuff/raw/main/buttons/images/toggle_inactive.png" width=300>
</p>

Pressing `Hi` prints a friendly message at the top of the screen:
<p align="center">
    <img src="https://github.com/c1ty/ccstuff/raw/main/buttons/images/hello_world.png" width=300>
</p>

## Future Plans

Since this is quite old code of mine, I am very not satisfied with the code-quality and general structure. 
While having a global buttons array is, in my opinion the way to go, how buttons are added is very rudimentary and 
feels cumbersome. Therefore I plan to utilize serialization to read some simple json files that specify buttons.
This however is more likely to become a greater UI API in itself that resembles a markup structure based on JSON 
(very far future).

The `check_click()` function is also not the very best, since it blocks all the program. A future version should 
move to a version that simply gets passed the click-coordinates. This should allow easier parallelization.