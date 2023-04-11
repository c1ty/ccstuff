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