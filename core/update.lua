
local updateList = {}
function onNextUpdate(cb)
    table.insert(updateList, cb)
end

function love.update(dt)

    -- update joystick axes detection
    -- its stupid we can do better
    joystickUpdate(dt)

    input:update(dt)
    input2:update(dt)

    cameraLife = cameraLife - dt

    if input:wasKeyPressed("select") or input2:wasKeyPressed("select") then
        pausing = not pausing
    end

    if (input:isKeyDown("start") and input:wasKeyPressed("select")) or
        (input:wasKeyPressed("start") and input:isKeyDown("select")) or
        (input2:isKeyDown("start") and input2:wasKeyPressed("select")) or
        (input2:wasKeyPressed("start") and input2:isKeyDown("select"))
    then
        reset() -- this is just a global function that will reset the entire level
        pausing = false
    end

    if pausing then return end

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

function updateJoystickDetection()
end
