
require("lib.mathext") -- this extends the math library
require("lib.tableext") -- this extends the table library
class = require("lib.middleclass")

Player = require("player")
Map = require("map")
Tile = require("tile")
Input = require("input")

----------------------------------------------------

-- replace with tiled later
local tempmap = {
    {1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0};
    {1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0};
    {1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0};
    {1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0};
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0};
}

function beginContact(fixture1, fixture2, contact)
    local physical1 = fixture1:getUserData()
    local physical2 = fixture2:getUserData()

    physical1:beginContact(fixture2, contact)
    physical2:beginContact(fixture1, contact)
end

function endContact(fixture1, fixture2, contact)
    local physical1 = fixture1:getUserData()
    local physical2 = fixture2:getUserData()

    physical1:endContact(fixture2, contact)
    physical2:endContact(fixture1, contact)
end

function love.load()

    world = love.physics.newWorld()
    world:setCallbacks(beginContact, endContact)
    world:setGravity(0, 500)

    player = Player:new()
    map = Map:new()
    input = Input:new()

    for k,v in pairs(arg) do
        print(k, v)
    end

    -- run love . dvorak for dvorak bindings
    if arg[2] == "dvorak" then
        input:bind( "a", "left" )
        input:bind( "e", "right" )
        input:bind( ",", "jump" )
        input:bind( " ", "jump" )
        input:bind( "o", "crouch" )
    else
        input:bind( "a", "left" )
        input:bind( "d", "right" )
        input:bind( "w", "jump" )
        input:bind( " ", "jump" )
        input:bind( "s", "crouch" )
    end

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
