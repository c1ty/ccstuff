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


Below is a very simple example:
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

## Future Plans

Since this is quite old code of mine, I am very not satisfied with the code-quality and general structure. 
While having a global buttons array is, in my opinion the way to go, how buttons are added is very rudimentary and 
feels cumbersome. Therefore I plan to utilize serialization to read some simple json files that specify buttons.
This however is more likely to become a greater UI API in itself that resembles a markup structure based on JSON 
(very far future).

The `check_click()` function is also not the very best, since it blocks all the program. A future version should 
move to a version that simply gets passed the click-coordinates. This should allow easier parallelization.