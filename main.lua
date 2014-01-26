
require("libs.mathext") -- this extends the math library
require("libs.tableext") -- this extends the table library
require("libs.print2") -- this adds "print2"
class = require("libs.middleclass")

Player = require("player")
Map = require("map")
Tile = require("tile")
Input = require("input")
Events = require("events")

PhysBox = require("physbox")
Fonz = require("entities.fonz")
Button = require("entities.button")
Bull = require("entities.bull")
BlueBall = require("entities.blueball")

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

function preSolve(fixture1, fixture2, contact)
    local physical1 = fixture1:getUserData()
    local physical2 = fixture2:getUserData()

    physical1:preSolve(physical2, contact, false)
    physical2:preSolve(physical1, contact, true)
end

function postSolve(fixture1, fixture2, contact, normal, tangent)
    local physical1 = fixture1:getUserData()
    local physical2 = fixture2:getUserData()

    physical1:postSolve(physical2, contact, normal, tangent, false)
    physical2:postSolve(physical1, contact, normal, tangent, true)
end

function contactFilter(fixture1, fixture2)
    local physical1 = fixture1:getUserData()
    local physical2 = fixture2:getUserData()

    physical1.collisiongroup = physical1.collisiongroup or "shared"
    physical2.collisiongroup = physical2.collisiongroup or "shared"

    if physical1.type == "PLAYER" and physical2.type == "PLAYER" then
        return true
    end

    if physical1.collisiongroup == "shared" or physical2.collisiongroup == "shared" then
        return true
    end

    if physical1.collisiongroup ~= physical2.collisiongroup then
        return false
    end

    return true
end

function reset()

    world = love.physics.newWorld()
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    world:setContactFilter(contactFilter)
    world:setGravity(0, 1000)
    if arg[2] then 
        map = Map:new(arg[2])
    else
        map = Map:new("data/introMap")
    end
    
    map:spawnObjects()

end

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setBackgroundColor(134, 200, 255)

    input = Input:new()
    input2 = Input:new()

    events = Events:new()

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
    input:bind( "joy_1_5", "select")
    input:bind( "joy_1_7", "start")
    input:bind( "joy_1_axisdown_1", "left" )
    input:bind( "joy_1_axisup_1", "right" )

    input2:bind( "joy_2_3", "jump" )
    input2:bind( "joy_2_2", "jump" )
    input2:bind( "joy_2_2", "crouch" )
    input2:bind( "joy_2_6", "L")
    input2:bind( "joy_2_8", "R")
    input2:bind( "joy_2_5", "select")
    input2:bind( "joy_2_7", "start")
    input2:bind( "joy_2_axisdown_1", "left" )
    input2:bind( "joy_2_axisup_1", "right" )

    input2:bind( "up", "jump" )
    input2:bind( "down", "crouch" )
    input2:bind( "rshift", "L")
    input2:bind( "/", "R")
    input2:bind( "r", "select")
    input2:bind( "t", "start")
    input2:bind( "left", "left" )
    input2:bind( "right", "right" )

    reset()

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
