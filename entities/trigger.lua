
PhysBox = require("physbox")

Trigger = class("Trigger", PhysBox)

function Trigger:initialize(x, y, w, h)
    self.width = w
    self.height = h
    PhysBox.initialize(self)
end

function Trigger:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'static')
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setSensor(true)
    self.fixture:setUserData(self)

    self.hasPressedLastUpdate = false
    self.TriggerDelay = 0
end

function Trigger:setPosition(x, y)
    PhysBox.setPosition(self, x + self.width/2 + 16, y + self.height/2 + 16)
end

function Trigger:update(dt)
end

function Trigger:draw()
    if not DEBUG then return end
    
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)

    love.graphics.setColor(0, 255, 0, 100)
    love.graphics.rectangle('fill', -self.width/2, -self.height/2, self.width, self.height)
    love.graphics.rectangle('line', -self.width/2, -self.height/2, self.width, self.height)

    love.graphics.pop()
end

function Trigger:beginContact(other, contact, isother)
    onNextUpdate(function()
        if other.type == "PLAYER" then
            self:trigger(self.ontrigger, other)
        end
    end)
end

return Trigger
