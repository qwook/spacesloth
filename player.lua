
Physical = require("Physical")

Player = class('Player', Physical)

function Player:initialize()
    self.name = "Stewart"
    self.type = "PLAYER"

    self:initPhysics()
end

function Player:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'dynamic')
    self.shape = love.physics.newRectangleShape(30, 50)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setUserData(self)
    self.fixture:setFriction(10)
    self.body:setMass(10)
    self.body:setFixedRotation(true)
    self.body:setAngularDamping(math.huge)

    self.floors = {}
    self.floorangle = 0;

    self.nextJump = 0;
end

function Player:isOnFloor()
    return #self.floors > 0
end

function Player:update(dt)
    local velx, vely = self.body:getLinearVelocity()

    -- true = up, false = down, nil = going straight
    local goingUpOrDown = nil

    if self:isOnFloor() then

        if input:isKeyDown("left") then
            self.body:setLinearVelocity(-200, vely)

            if self.floorangle > math.pi/2 and self.floorangle < math.pi then
                goingUpOrDown = false
            end
        end

        if input:isKeyDown("right") then
            self.body:setLinearVelocity(200, vely)

            if self.floorangle > math.pi/2 and self.floorangle < math.pi then
                goingUpOrDown = true
            end
        end

        -- up
        if goingUpOrDown == true then
            self.body:applyLinearImpulse(0, -100)
        -- down
        elseif goingUpOrDown == false then
            self.body:applyLinearImpulse(0, 200)
        end

    -- not on floor, we're in the air
    else
        if input:isKeyDown("left") then
            self.body:setLinearVelocity(velx - 300*dt, vely)
        end

        if input:isKeyDown("right") then
            self.body:setLinearVelocity(velx + 300*dt, vely)
        end
    end

    if self.nextJump > 0 then
        self.nextJump = self.nextJump - dt
    end

    -- if input:wasKeyPressed("jump") and #self.floors > 0 then
    if input:isKeyDown("jump") and self:isOnFloor() and self.nextJump <= 0 then
        self.body:applyLinearImpulse(0, -750)
        self.nextJump = 0.05
    end
end

function Player:draw()
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)

    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('fill', -15, -25, 30, 50)

    love.graphics.pop()
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

    print(self.name)

    if isother ~= false then
        normx = -normx
        normy = -normy
    end

    local dot = math.dotproduct(normx, normy, 0, 0, 1, 0)

    -- detect a floor
    if (math.acos(dot) <= math.pi / 4 + 0.1) or (math.acos(dot) >= math.pi * (3 / 4) - 0.1) then        
        self.floorangle = math.acos(dot)
        self.floornx = normx
        self.floorny = normy

        -- count how many potential floors we are touching
        if not table.hasvalue(self.floors, other) then
            table.insert(self.floors, other)
        end
    else
        -- if it isn't a floor, set the friction to 0
        -- we want to slide down walls, not cling onto them
        contact:setFriction(0)
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

function Cindy:draw()
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)

    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle('fill', -15, -25, 30, 50)

    love.graphics.pop()
end


return Player
