
class = require("middleclass")
Player = require("player")
Map = require("map")
Tile = require("tile")
Input = require("input")

----------------------------------------------------

-- replace with tiled later
local tempmap = {
    {0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0};
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0};
    {0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0};
    {0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0};
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0};
}

function love.load()

    world = love.physics.newWorld()
    world:setGravity(0, 300)

    player = Player:new()
    map = Map:new()
    input = Input:new()

    input:bind( "a", "left" )
    input:bind( "d", "right" )
    input:bind( "w", "jump" )
    input:bind( " ", "jump" )
    input:bind( "s", "crouch" )

    -- todo: stop using temp map and use tiled
    for y, row in pairs(tempmap) do
        for x, tile in pairs(row) do
            if tile == 1 then
                map:set(x, y, Tile:new())
            end
        end
    end

    player:setPosition(150, -10)

end

function love.keypressed(key, isrepeat)
    if not isrepeat then
        input:eventKeyPressed(key)
    end
end

function love.keyreleased(key)
    input:eventKeyReleased(key)
end

function love.update(dt)
    input:update(dt)
    player:update(dt)
    world:update(dt)
end

function love.draw()

    map:draw()
    player:draw()

end
