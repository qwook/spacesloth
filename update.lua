
last_axes = {}

local updateList = {}
function onNextUpdate(cb)
    table.insert(updateList, cb)
end

function love.update(dt)
    local joysticks = love.joystick.getJoysticks()

    -- ipairs is like pairs but for arrays
    for _, joystick in ipairs(joysticks) do
        for i = 1, joystick:getAxisCount() do
            local axis = joystick:getAxis(i)
            local last_axis = last_axes[joystick:getID() .. "_" .. i] or 0
            if (axis > 0) and (last_axis <= 0) then
                input:eventJoyPressed(joystick:getID() .. "_axisup_" .. i)
                input:eventJoyReleased(joystick:getID() .. "_axisdown_" .. i)
                input2:eventJoyPressed(joystick:getID() .. "_axisup_" .. i)
                input2:eventJoyReleased(joystick:getID() .. "_axisdown_" .. i)
            elseif (axis < 0) and (last_axis >= 0) then
                input:eventJoyPressed(joystick:getID() .. "_axisdown_" .. i)
                input:eventJoyReleased(joystick:getID() .. "_axisup_" .. i)
                input2:eventJoyPressed(joystick:getID() .. "_axisdown_" .. i)
                input2:eventJoyReleased(joystick:getID() .. "_axisup_" .. i)
            elseif (axis == 0) and (last_axis ~= 0) then
                input:eventJoyReleased(joystick:getID() .. "_axisdown_" .. i)
                input:eventJoyReleased(joystick:getID() .. "_axisup_" .. i)
                input2:eventJoyReleased(joystick:getID() .. "_axisdown_" .. i)
                input2:eventJoyReleased(joystick:getID() .. "_axisup_" .. i)
            end
            last_axes[joystick:getID() .. "_" .. i] = axis
        end
    end

    input:update(dt)
    input2:update(dt)
    player:update(dt)
    player2:update(dt)
    world:update(dt)

    if changeMapTime > 0 then
        changeMapTime = changeMapTime - dt
    elseif changeMapQueue ~= nil then
        changeMapTimeOut = 1
        changeMap(changeMapQueue)
        changeMapQueue = nil
    end

    if changeMapTimeOut > 0 then
        changeMapTimeOut = changeMapTimeOut - dt
    end

    for i, object in pairs(map.objects) do
        object:update(dt)
    end

    while (#updateList > 0) do
        updateList[1]()
        table.remove(updateList, 1)
    end
end
