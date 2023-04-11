-- interactive turtle control program by c1tycrafter
 
local opcodes = {}
opcodes["DIG_DOWN"] = turtle.digDown
opcodes["DIG_UP"] = turtle.digUp
opcodes["DIG"] = turtle.dig
opcodes["M_FORWARD"] = turtle.forward
opcodes["M_BACK"] = turtle.back
opcodes["M_UP"] = turtle.up
opcodes["M_DOWN"] = turtle.down
opcodes["DET_UP"] = turtle.detectUp
opcodes["DET"] = turtle.detect
opcodes["DET_DOWN"] = turtle.detectDown
opcodes["T_RIGHT"] = turtle.turnRight
opcodes["T_LEFT"] = turtle.turnLeft
opcodes["PLC"] = turtle.place
opcodes["PLC_UP"] = turtle.placeUp
opcodes["PLC_DOWN"] = turtle.placeDown
 
local function get_info()
    local inv = {}
    for i=1,16 do
        inv[i] = turtle.getItemCount(i)
    end
    local rdata = {}
    rdata["fuel"] = turtle.getFuelLevel()
    rdata["inv"] = inv
    return rdata
end
 
opcodes["INFO"] = get_info
 
 
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
 
local function process_code(opcode)
    if opcode == nil then
        return nil
    end
 
    for k,v in pairs(opcodes) do
        if k == opcode then
            return v
        end
    end
    return nil
end
 
local function select_from_string(opcode)
    local slot = parse_number(string.sub(opcode, 7))
    local response = {}
    if slot >= 1 and slot <= 16 then
        response["code"] = 200
        response["message"] = "SELECTED " .. slot
        turtle.select(slot)
    else
        response["code"] = 404
        response["message"] = "INVALID SLOT " .. slot
    end
    return response
end
 
term.clear()
term.setCursorPos(1,1)
local response = {}
response["code"] = 0
response["message"] = ""
 
local server_id, request = rednet.receive()
print("got request from " .. server_id)
request = textutils.unserialise(request)
 
if request["code"] == 100 and request["message"] == "CONFIRM_ID" then
    response["code"] = 200
    response["message"] = "ID_CORRECT"
    rednet.send(server_id, textutils.serialise(response))
end
 
 
-- „connection established“
print("entering interactive mode")
while request["message"] ~= "EXIT" do
    server_id, request = rednet.receive()
    request = textutils.unserialise(request)
    if string.sub(request["message"],1,6) == "SELECT" then
        response = select_from_string(request["message"])
    else
        local rval = false
        local code = 404
        local operation = process_code(request["message"])
        if operation ~= false and operation ~= nil then
            rval = operation()
            code = 200
            response["message"] = "OK"
            response["value"] = rval
        else
            response["message"] = "INVALID_OPCODE"
        end
        response["code"] = code
        if request["message"] == "EXIT" then
            response["code"] = 200
            response["message"] = "EXITING"
        end
    end
    rednet.send(server_id, textutils.serialise(response))
end