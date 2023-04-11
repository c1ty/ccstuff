-- buttons API by c1tycraft3r
 
buttons = {}
 
local DEFAULT_OFF = colors.red
local DEFAULT_ON = colors.lime
local FLASH_DURATION = 0.2
 
local function draw_box(x,y,width,height,color)
    for i=y, y+height-1 do
        paintutils.drawLine(x, i, x+width-1, i, color)
    end
end
 
local function draw_button(button, color)
    local x = button["x"]
    local y = button["y"]
    local width = button["width"]
    local height = button["height"]
 
    local msg_len = string.len(button["msg"])
    local text_y = y + height / 2
    local text_x = (x + width / 2) - (msg_len / 2)
 
    
    term.setBackgroundColor(color)
    term.setTextColor(button["fg"])
    draw_box(x, y, width, height, color)
    term.setCursorPos(text_x,text_y)
    write(button["msg"])
    term.setBackgroundColor(colors.black)
end
 
function add_toggle_button(id,x,y,width,height,msg,color_active,color_inactive, color_fg)
    local button = {}
 
    button["x"] = x
    button["y"] = y
    button["state"] = true
    button["width"] = width
    button["height"] = height
    button["msg"] = msg
    button["color"] = color_active
    button["color_i"] = color_inactive
    button["type"] = "TOGGLE"
    button["fg"] = color_fg
    buttons[id] = button
 
end
 
function add_action_button(id,x,y,width,height,msg,action,color, color_flash, color_fg)
    local button = {}
 
    button["x"] = x
    button["y"] = y
    button["action"] = action
    button["width"] = width
    button["height"] = height
    button["msg"] = msg
    button["color"] = color
    button["color_flash"] = color_flash
    button["type"] = "ACTION"
    button["fg"] = color_fg
    buttons[id] = button
end
 
local function press_action_button(button)
    button["action"]()
    draw_button(button, button["color_flash"])
    sleep(FLASH_DURATION)
    draw_button(button, button["color"])
end
 
local function toggle_button(button)
    local tmp = button["color_i"]
    button["color_i"] = button["color"]
    button["color"] = tmp
    draw_button(button,button["color"])
    if button["state"] then
        button["state"] = false
    else
        button["state"] = true
    end
end
 
function draw_all()
    for k,v in pairs(buttons) do
        draw_button(v, v["color"])
    end
end
 
function check_click()
    local event, button, x, y = os.pullEvent("mouse_click")
    for k,v in pairs(buttons) do
        if v["x"] <= x and x <= v["x"] + v["width"] then
            if v["y"] <= y and y <= v["y"] + v["height"] then
                if v["type"] == "TOGGLE" then
                    toggle_button(v)
                else
                    press_action_button(v)
                end
                return k
            end
        end
    end
end
