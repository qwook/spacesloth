
Physical = require("physical")
SpriteSheet = require("spritesheet")

Player = class('Player', Physical)

function Player:initialize()
    self.name = "Stewart"
    self.type = "PLAYER"
    self.collisiongroup = "blue"

    self.spritesheet = SpriteSheet:new("data/players.png", 32, 32)
    self.expression = 0
    
    self:initPhysics()
end

function Player:setController(input)
    self.controller = input
end

function Player:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'dynamic')
    -- self.shape = love.physics.newRectangleShape(32, 28)
    self.shape = love.physics.newCircleShape(16)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setUserData(self)
    self.fixture:setFriction(5)
    self.body:setMass(20)
    self.body:setFixedRotation(true)

    self.contacts = {}

    self.floorangle = 0
    self.floornx = 0
    self.floorny = 0

    self.nextJump = 0

    self.facing = 'right'
    self.moving = false
end

function Player:isOnFloor()
    local x, y = self:getPosition()
    y = y + 10

    for k, contact in pairs(self.contacts) do
        local x1, y1, x2, y2 = contact:getPositions()
        if (y1 > y and (y2 or y+1) > y) then
            self.floornx, self.floorny = contact:getNormal()
            return true
        end
    end

    return false
end

function Player:update(dt)

    -- handle animation --

    if self.controller:wasKeyPressed("left") then
        self.facing = 'left'
    elseif self.controller:wasKeyPressed("right")  then
        self.facing = 'right'
    end


    self.expression = 0
    if (self.controller:isKeyDown("L")) then self.expression = self.expression + 1 end
    if (self.controller:isKeyDown("R")) then self.expression = self.expression + 2 end

    -- handle physics --

    local velx, vely = self.body:getLinearVelocity()

    if math.length(velx, vely) > 0.1 then
        self.moving = true
    else
        self.moving = false
    end

    -- true = up, false = down, nil = going straight
    local goingUpOrDown = nil
    local ypoop = self.floornx

    if self:isOnFloor() then

        if self.controller:isKeyDown("left") then
            self.body:setLinearVelocity(-200, vely)

            -- this is for climbing stairs
            if self.floorangle > -math.pi*(4/5) and self.floorangle < -math.pi/2-0.15  then
                goingUpOrDown = false
            end
            if self.floorangle < math.pi*(4/5) and self.floorangle > -math.pi/2+0.15 then
                goingUpOrDown = true
                ypoop = -ypoop
            end
        end

        if self.controller:isKeyDown("right") then
            self.body:setLinearVelocity(200, vely)

            -- this is for climbing stairs
            if self.floorangle > -math.pi*(4/5) and self.floorangle < -math.pi/2-0.15  then
                goingUpOrDown = true
            end
            if self.floorangle < math.pi*(4/5) and self.floorangle > -math.pi/2+0.15 then
                goingUpOrDown = false
                ypoop = -ypoop
            end
        end

        if self.nextJump > 0 then
            self.nextJump = self.nextJump - dt
        end

        if self.controller:isKeyDown("jump") and self.nextJump <= 0 then
            self.body:setLinearVelocity(velx/2, vely/2)
            self.body:applyLinearImpulse(0, -500)
            self.nextJump = 0.1
            goingUpOrDown = nil
        end

        -- so for climbing stairs, we actually push the player up a bit
        -- when they're going up stairs, and push them down when they're going
        -- down stairs.
        if self.nextJump <= 0 then
            local velx, vely = self.body:getLinearVelocity()
            -- up
            if goingUpOrDown == true then
                -- self.body:applyLinearImpulse(0, -50)
                self.body:setLinearVelocity(velx, 200 * ypoop)
            -- down
            elseif goingUpOrDown == false then
                -- self.body:applyLinearImpulse(0, 10)
                self.body:setLinearVelocity(velx, 200 * -ypoop)
            end
        end

    -- not on floor, we're in the air
    else
        if self.controller:isKeyDown("left") then
            self.body:setLinearVelocity(velx - 300*dt, vely)
        end

        if self.controller:isKeyDown("right") then
            self.body:setLinearVelocity(velx + 300*dt, vely)
        end
    end

    if self.controller:isKeyDown("start") and self.controller:isKeyDown("select") then
        reset() -- this is just a global function that will reset the entire level
    end

end

function Player:draw()
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)

    -- love.graphics.setColor(0, 255, 0)
    -- love.graphics.rectangle('fill', -16, -16, 32, 32)

    if self.facing == 'right' then
        love.graphics.scale(1, 1)
    else
        love.graphics.scale(-1, 1)
    end

    love.graphics.setColor(255, 255, 255)

    self:drawPlayer()

    love.graphics.pop()
end

function Player:drawPlayer()
    local anim = 0
    if self.moving then
        anim = math.floor(love.timer.getTime()*10) % 4
    end

    self.spritesheet:draw(anim, 1, -16, -18)
    self.spritesheet:draw(self.expression, 0, -16, -18)
end

function Player:getPosition()
    return self.body:getPosition()
end

function Player:setPosition(x, y)
    self.body:setPosition(x, y)
end

function Player:getAngle()
    return self.body:getAngle()
end

function Player:setAngle(r)
    self.body:setAngle(r)
end

-- the player hit something
function Player:beginContact(other, contact, isother)
    local x, y = self:getPosition()
    local normx, normy = contact:getNormal()

    if isother == false then
        normx = -normx
        normy = -normy
    end

    table.insert(self.contacts, contact)

    -- detect a floor
    local x1, y1, x2, y2 = contact:getPositions()

    local id, id2 = contact:getChildren()
    if isother then id = id2 end -- `isother` means we are the second object

    if (y1 > y and (y2 or y+1) > y) then -- and ((math.acos(dot) <= math.pi / 4 + 0.1) or (math.acos(dot) >= math.pi * (3 / 4) - 0.1)) then        
        self.floorangle = math.atan2(normy, normx)
        self.floornx = normx
        self.floorny = normy
    else
        -- if it isn't a floor, set the friction to 0
        -- we want to slide down walls, not cling onto them
        contact:setFriction(0)
    end

    if other.type == "PLAYER" then
        contact:setFriction(1)
    end

end

function Player:endContact(other, contact, isother)
    local normx, normy = contact:getNormal()
    local cx, cy, cz = math.crossproduct(normx, normy, 0, 0, 1, 0)

    table.removevalue(self.contacts, contact)

    local x, y = self:getPosition()
    local x1, y1, x2, y2 = contact:getPositions()

    local id, id2 = contact:getChildren()
    if isother then id = id2 end -- `isother` means we are the second object

end

function Player:preSolve()
end


-- Cindy is player 2.
Cindy = class("Cindy", Player)

function Cindy:initialize()
    Player.initialize(self)

    self.collisiongroup = "green"
    self.name = "Cindy"
end

function Cindy:drawPlayer()
    local anim = 0
    if self.moving then
        anim = math.floor(love.timer.getTime()*10) % 4
    end

    self.spritesheet:draw(anim, 3, -16, -18)
    self.spritesheet:draw(self.expression, 2, -16, -18)
end


return Player
