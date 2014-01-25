
Player = class('Player')

function Player:initialize()
    self:initPhysics()
end

function Player:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'dynamic')
    self.shape = love.physics.newRectangleShape(50, 50)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.body:setMass(10)
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

function Player:update(dt)
    local velx, vely = self.body:getLinearVelocity()

    if input:isKeyDown("left") then
        self.body:setLinearVelocity(-250, vely)
    end

    if input:isKeyDown("right") then
        self.body:setLinearVelocity(250, vely)
    end

    if input:wasKeyPressed("jump") then
        self.body:applyLinearImpulse(0, -1000)
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

return Player
