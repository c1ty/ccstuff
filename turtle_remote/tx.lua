-- interactive turtle control program by c1tycrafter
os.loadAPI("buttons")
 
term.clear()
term.setCursorPos(1,1)
 
 
local SESSION_ID = 0
local VERIFICATION_TRIES = 5
local rcond = true
local fuel_stat = 0
 
local function parse_number(input)
    if input == nil then
        return false
    end
 
    local data = tonumber(input)
 
    if data == nil then
        return false
    else
        return data
    end
end
 
local function get_number_input(msg)
    if msg ~= nil then
        write(msg .. ": ")
    end
    local txt_input = io.read()
    return parse_number(txt_input)
end
 
local function test_id(id)
    if id == nil then
        return false
    end
    local request = {}
    request["message"] = "CONFIRM_ID"
    request["code"] = 100
 
    for i = 1,VERIFICATION_TRIES do
        print("trying entered id, " .. i .. "/" .. VERIFICATION_TRIES)
        rednet.send(id, textutils.serialize(request))
        local rid, response = rednet.receive(5)
        if response ~= nil then
 
            response = textutils.unserialise(response)
            print("got response from " .. rid)
            if response["code"] == 200 and response["message"] == "ID_CORRECT" then
                SESSION_ID = id
                print("ID " .. id .. " verified!")
                break
            end
        end
    end
end
 
 
local function send_operation(opcode)
    local request = {}
    request["code"] = 100
    request["message"] = opcode
    rednet.send(SESSION_ID, textutils.serialise(request))
   
end
 
local function send_INFO()
    send_operation("INFO")
    local sender_id, request = rednet.receive()
    request = textutils.unserialise(request)
    fuel_stat = request["value"]["fuel"]
    inv   = request["value"]["inv"]
    term.setCursorPos(10,13)
    write("               ")
    term.setCursorPos(10,13)
    write("fuel: " .. fuel_stat)
    term.setCursorPos(10,14)
    
    for i=0,3 do
        for j=0,3 do
            term.setCursorPos(10+3*i, 13+2*j + 1)
            write(inv[i*4+j+1])
        end
    end
end
 
local function send_DIG_DOWN()
    send_operation("DIG_DOWN")
end
 
local function send_DIG_UP()
    send_operation("DIG_UP")
end
 
local function send_DIG()
    send_operation("DIG")
end
 
local function send_M_FORWARD()
    send_operation("M_FORWARD")
end
 
local function send_M_UP()
    send_operation("M_UP")
end
 
local function send_M_BACK()
    send_operation("M_BACK")
end
 
local function send_M_DOWN()
    send_operation("M_DOWN")
end
 
local function send_DET_UP()
    send_operation("DET_UP")
end
 
local function send_DET()
    send_operation("DET")
end
 
local function send_DET_DOWN()
    send_operation("DET_DOWN")
end
 
local function send_T_RIGHT()
    send_operation("T_RIGHT")
end
 
local function send_T_LEFT()
    send_operation("T_LEFT")
end
 
local function send_PLC()
    send_operation("PLC")
end
 
local function send_PLC_UP()
    send_operation("PLC_UP")
end
 
local function send_PLC_DOWN()
    send_operation("PLC_DOWN")
end
 
local function send_EXIT()
    local request = {}
    request["code"] = 100
    request["message"] = "EXIT"
    rednet.send(SESSION_ID, textutils.serialise(request))
    rcond = false
end
 
test_id(get_number_input("enter rx id"))
term.clear()
term.setCursorPos(2,1)
write("dig")
term.setCursorPos(6,1)
write("mov")
term.setCursorPos(10,1)
write("det")
term.setCursorPos(14,1)
write("plc")
term.setCursorPos(10,12)
write("connection: " .. SESSION_ID)
 
buttons.add_action_button("DIG_DOWN" ,2 ,2 ,2,2,"D"   , send_DIG_DOWN , colors.lime     , colors.red, colors.white)
buttons.add_action_button("DIG_UP"   ,2 ,5 ,2,2,"U"   , send_DIG_UP   , colors.lime     , colors.red, colors.white)
buttons.add_action_button("DIG"      ,2 ,8 ,2,2,"F"   , send_DIG      , colors.lime     , colors.red, colors.white)
buttons.add_action_button("M_FORWARD",6 ,2 ,2,2,"W"   , send_M_FORWARD, colors.blue     , colors.red, colors.white)
buttons.add_action_button("M_BACK"   ,6 ,5 ,2,2,"S"   , send_M_BACK   , colors.blue     , colors.red, colors.white)
buttons.add_action_button("M_UP"     ,6 ,8 ,2,2,"U"   , send_M_UP     , colors.blue     , colors.red, colors.white)
buttons.add_action_button("M_DOWN"   ,6 ,11,2,2,"D"   , send_M_DOWN   , colors.blue     , colors.red, colors.white)
buttons.add_action_button("T_RIGHT"  ,6 ,14,2,2,"R"   , send_T_RIGHT  , colors.lightBlue, colors.red, colors.white)
buttons.add_action_button("T_LEFT"   ,6 ,17,2,2,"L"   , send_T_LEFT   , colors.lightBlue, colors.red, colors.white)
buttons.add_action_button("DET_UP"   ,10,2 ,2,2,"U"   , send_DET_UP   , colors.purple   , colors.red, colors.white)
buttons.add_action_button("DET"      ,10,5 ,2,2,"F"   , send_DET      , colors.purple   , colors.red, colors.white)
buttons.add_action_button("DET_DOWN" ,10,8 ,2,2,"D"   , send_DET_DOWN , colors.purple   , colors.red, colors.white)
buttons.add_action_button("PLC"      ,14,2 ,2,2,"F"   , send_PLC      , colors.orange   , colors.red, colors.white)
buttons.add_action_button("PLC_UP"   ,14,5 ,2,2,"U"   , send_PLC_UP   , colors.orange   , colors.red, colors.white)
buttons.add_action_button("PLC_DOWN" ,14,8 ,2,2,"D"   , send_PLC_DOWN , colors.orange   , colors.red, colors.white)
buttons.add_action_button("EXIT"     ,26,1 ,1,1,"X"   , send_EXIT     , colors.red      , colors.red, colors.white)
buttons.add_action_button("INFO"     ,17,2 ,5,2,"info", send_INFO     , colors.lime     , colors.red, colors.white)
 
while rcond do
    buttons.draw_all()
    term.setCursorPos(10, 14)
    buttons.check_click()
end
 
term.clear()
term.setCursorPos(1,1)