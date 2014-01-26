
Events = class("Events")

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

    world = love.physics.newWorld()
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    world:setContactFilter(contactFilter)
    world:setGravity(0, 1000)

    map = Map:new("assets/maps/" .. mapname)

    
    map:spawnObjects()

    collisionSwapped = false

end

return Events
