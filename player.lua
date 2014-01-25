
Physical = require("Physical")

Player = class('Player', Physical)
Player.static.type = "PLAYER"

function Player:initialize()
    self:initPhysics()
end

function Player:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'dynamic')
    self.shape = love.physics.newRectangleShape(50, 50)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setUserData(self)
    self.fixture:setFriction(10)
    self.body:setMass(10)
    self.body:setFixedRotation(true)
    self.body:setAngularDamping(math.huge)

    self.floors = {}
end

function Player:isOnFloor()
    return #self.floors > 0
end

function Player:update(dt)
    local velx, vely = self.body:getLinearVelocity()

    if input:isKeyDown("left") then
        self.body:setLinearVelocity(-100, vely)
    end

    if input:isKeyDown("right") then
        self.body:setLinearVelocity(100, vely)
    end

    -- if input:wasKeyPressed("jump") and #self.floors > 0 then
    if input:isKeyDown("jump") and #self.floors > 0 then
        self.body:applyLinearImpulse(0, -500)
    end
end

function Player:draw()
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x + 25, y + 25)
    love.graphics.rotate(r)

    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle('fill', -25, -25, 50, 50)

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
function Player:beginContact(other, contact)
    local normx, normy = contact:getNormal()
    local dot = math.dotproduct(normx, normy, 0, 0, 1, 0)

    -- detect a floor
    if math.acos(dot) < math.pi / 4 then
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

function Player:endContact(other, contact)
    local normx, normy = contact:getNormal()
    local cx, cy, cz = math.crossproduct(normx, normy, 0, 0, 1, 0)


    if table.hasvalue(self.floors, other) then
        table.removevalue(self.floors, other)
    end
end

return Player
