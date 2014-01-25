
require("libs.mathext") -- this extends the math library
require("libs.tableext") -- this extends the table library
require("libs.print2") -- this adds "print2"
class = require("libs.middleclass")

Player = require("player")
Map = require("map")
Tile = require("tile")
Input = require("input")

require("update")
require("draw")

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

    physical1:beginContact(physical2, contact, false)
    physical2:beginContact(physical1, contact, true)
end

function endContact(fixture1, fixture2, contact)
    local physical1 = fixture1:getUserData()
    local physical2 = fixture2:getUserData()

    physical1:endContact(physical2, contact, false)
    physical2:endContact(physical1, contact, true)
end

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setBackgroundColor(134, 200, 255)

    world = love.physics.newWorld()
    world:setCallbacks(beginContact, endContact)
    world:setGravity(0, 1000)

    input = Input:new()
    input2 = Input:new()

    map = Map:new("data/nazifirehazard")

    --[[ for k,v in pairs(arg) do
        print(k, v)
    end ]]

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

    -- I honestly grabbed these button names by printing them
    -- in the eventJoyPressed function in the Input class
    -- we can make prettier names for them later
    input:bind( "joy_1_3", "jump" )
    input:bind( "joy_1_2", "jump" )
    input:bind( "joy_1_2", "crouch" )
    input:bind( "joy_1_6", "L")
    input:bind( "joy_1_8", "R")
    input:bind( "joy_1_axisdown_1", "left" )
    input:bind( "joy_1_axisup_1", "right" )

    input2:bind( "joy_2_3", "jump" )
    input2:bind( "joy_2_2", "jump" )
    input2:bind( "joy_2_2", "crouch" )
    input2:bind( "joy_2_6", "L")
    input2:bind( "joy_2_8", "R")
    input2:bind( "joy_2_axisdown_1", "left" )
    input2:bind( "joy_2_axisup_1", "right" )

    -- todo: stop using temp map and use tiled
    -- for y, row in pairs(tempmap) do
    --     for x, tile in pairs(row) do
    --         if tile == 1 then
    --             map:set(x, y, Tile:new(32, 32))
    --         end
    --     end
    -- end

end

function love.keypressed(key, isrepeat)
    if not isrepeat then
        input:eventKeyPressed(key)
        input2:eventKeyPressed(key)
    end
end

function love.keyreleased(key)
    input:eventKeyReleased(key)
    input2:eventKeyReleased(key)
end

function love.joystickpressed( joystick, button )
    input:eventJoyPressed(joystick:getID() .. "_" .. button)
    input2:eventJoyPressed(joystick:getID() .. "_" .. button)
end

function love.joystickreleased( joystick, button )
    input:eventJoyReleased(joystick:getID() .. "_" .. button)
    input2:eventJoyReleased(joystick:getID() .. "_" .. button)
end
