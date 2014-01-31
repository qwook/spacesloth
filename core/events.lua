
Events = class("Events")

changeMapTime = 0
changeMapTimeOut = 0
changeMapQueue = nil

function Events:swapCollision()
    collisionSwapped = not collisionSwapped

    local categories, mask, group = player.fixture:getFilterData()

    player.fixture:setFilterData(1, 0, 0)
    player.fixture:setFilterData(2, 0, 0)
    player.fixture:setFilterData(categories, mask, group)


    local categories, mask, group = player2.fixture:getFilterData()

    player2.fixture:setFilterData(1, 0, 0)
    player2.fixture:setFilterData(2, 0, 0)
    player2.fixture:setFilterData(categories, mask, group)
end

function Events:changeMap(mapname)

    if changeMapQueue then return end

    changeMapQueue = mapname
    changeMapTime = 1

end

function Events:playSound(name, volume)
    playSound(name, tonumber(volume or 1) or 1)
end

function Events:playMusic(name, volume)
    playMusic(name, tonumber(volume))
end

return Events