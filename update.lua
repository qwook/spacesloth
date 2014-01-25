
last_axes = {}

function love.update(dt)
    local joysticks = love.joystick.getJoysticks()

    -- ipairs is like pairs but for arrays
    for _, joystick in ipairs(joysticks) do
        for i = 1, joystick:getAxisCount() do
            local axis = joystick:getAxis(i)
            local last_axis = last_axes[joystick:getName() .. "_" .. i] or 0
            if (axis > 0) and (last_axis <= 0) then
                input:eventJoyPressed(joystick:getName() .. "_axisup_" .. i)
                input:eventJoyReleased(joystick:getName() .. "_axisdown_" .. i)
            elseif (axis < 0) and (last_axis >= 0) then
                input:eventJoyPressed(joystick:getName() .. "_axisdown_" .. i)
                input:eventJoyReleased(joystick:getName() .. "_axisup_" .. i)
            elseif (axis == 0) and (last_axis ~= 0) then
                input:eventJoyReleased(joystick:getName() .. "_axisdown_" .. i)
                input:eventJoyReleased(joystick:getName() .. "_axisup_" .. i)
            end
            last_axes[joystick:getName() .. "_" .. i] = axis
        end
    end

    input:update(dt)
    player:update(dt)
    world:update(dt)
end
