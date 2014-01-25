
Physical = require("physical")

PhysBox = class("PhysBox", Physical)

function PhysBox:initialize()
    self:initPhysics()

    table.insert(map.objects, self)
end

function PhysBox:destroy()
    table.removevalue(map.objects, self)
end

function PhysBox:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'dynamic')
    self.shape = love.physics.newRectangleShape(32, 32)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setUserData(self)
    self.fixture:setFriction(0.5)
end

function PhysBox:setPosition(x, y)
    self.body:setPosition(x, y)
end

function PhysBox:getPosition()
    return self.body:getPosition()
end

function PhysBox:getAngle(r)
    self.body:getAngle(r)
end

function PhysBox:getAngle()
    return self.body:getAngle()
end

function PhysBox:update(dt)
end

function PhysBox:draw()
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)

    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('fill', -16, -16, 32, 32)

    love.graphics.pop()
end

function PhysBox:beginContact(other, contact)
    if other.type == "PLAYER" then
        -- you can make it so it's a button and it activates on touch
        -- idk
    end
end

function PhysBox:endContact(other, contact)
end

return PhysBox
