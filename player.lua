
Physical = require("physical")
SpriteSheet = require("spritesheet")

Player = class('Player', Physical)

function Player:initialize()
    self.name = "Stewart"
    self.type = "PLAYER"

    self.spritesheet = SpriteSheet:new("data/players.png", 32, 32)

    self:initPhysics()
end

function Player:setController(input)
    self.controller = input
end

function Player:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'dynamic')
    self.shape = love.physics.newRectangleShape(32, 28)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setUserData(self)
    self.fixture:setFriction(10)
    self.body:setMass(10)
    self.body:setFixedRotation(true)
    self.body:setAngularDamping(math.huge)

    self.floors = {}
    self.floorangle = 0
    self.floornx = 0
    self.floorny = 0

    self.nextJump = 0

    self.facing = 'right'
    self.moving = false
end

function Player:isOnFloor()
    local x, y = self:getPosition()
    local bboxcheck = false
    world:queryBoundingBox(x - 16, y + 10, x + 16, y + 16, function(fixture)
        local hit = fixture:getUserData()
        if hit ~= self then
            bboxcheck = true
        end
        return true
    end)

    return #self.floors > 0 and bboxcheck
end

function Player:update(dt)

    -- handle animation --

    if self.controller:wasKeyPressed("left") then
        self.facing = 'left'
    elseif self.controller:wasKeyPressed("right")  then
        self.facing = 'right'
    end

    -- handle physics --

    local velx, vely = self.body:getLinearVelocity()

    if math.length(velx, vely) > 0.1 then
        self.moving = true
    else
        self.moving = false
    end

    -- true = up, false = down, nil = going straight
    local goingUpOrDown = nil

    print(self.floorangle)

    if self:isOnFloor() then

        if self.controller:isKeyDown("left") then
            self.body:setLinearVelocity(-200, vely)

            -- this is for climbing stairs
            if self.floorangle > -math.pi and self.floorangle < -math.pi/2 then
                goingUpOrDown = false
            end
            if self.floorangle < 0 and self.floorangle > -math.pi/2 then
                goingUpOrDown = true
            end
        end

        if self.controller:isKeyDown("right") then
            self.body:setLinearVelocity(200, vely)

            -- this is for climbing stairs
            if self.floorangle > -math.pi and self.floorangle < -math.pi/2 then
                goingUpOrDown = true
            end
            if self.floorangle < 0 and self.floorangle > -math.pi/2 then
                goingUpOrDown = false
            end
        end

        -- so for climbing stairs, we actually push the player up a bit
        -- when they're going up stairs, and push them down when they're going
        -- down stairs.
            -- up
            if goingUpOrDown == true then
                self.body:applyLinearImpulse(0, -100)
            -- down
            elseif goingUpOrDown == false then
                self.body:applyLinearImpulse(0, 100)
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

    if self.nextJump > 0 then
        self.nextJump = self.nextJump - dt
    end

    if self.controller:isKeyDown("jump") and self:isOnFloor() and self.nextJump <= 0 then
        self.body:applyLinearImpulse(0, -500)
        self.nextJump = 0.1
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
    self.spritesheet:draw(0, 0, -16, -18)
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
    local normx, normy = contact:getNormal()

    if isother == false then
        normx = -normx
        normy = -normy
    end

    local dot = math.dotproduct(normx, normy, 0, 0, 1, 0)

    -- detect a floor
    if (math.acos(dot) <= math.pi / 4 + 0.1) or (math.acos(dot) >= math.pi * (3 / 4) - 0.1) then        
        self.floorangle = math.atan2(normy, normx)
        self.floornx = normx
        self.floorny = normy

        self.body:applyLinearImpulse(normx*25, normy*25)

        -- count how many potential floors we are touching
        if not table.hasvalue(self.floors, other) then
            table.insert(self.floors, other)
        end
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

    if table.hasvalue(self.floors, other) then
        table.removevalue(self.floors, other)
    end
end

Cindy = class("Cindy", Player)

function Cindy:initialize()
    Player.initialize(self)
    
    self.name = "Cindy"
end

function Cindy:drawPlayer()
    local anim = 0
    if self.moving then
        anim = math.floor(love.timer.getTime()*10) % 4
    end

    self.spritesheet:draw(anim, 3, -16, -18)
    self.spritesheet:draw(0, 2, -16, -18)
end


return Player
