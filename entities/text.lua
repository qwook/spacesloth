
PhysBox = require("physbox")

Text = class("Text", PhysBox)

function Text:initialize(x, y, w, h)
    self.width = w
    self.height = h
    self.touching = {}
    PhysBox.initialize(self)
end

function Text:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'static')
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setSensor(true)
    self.fixture:setUserData(self)

    self.hasPressedLastUpdate = false
    self.TextDelay = 0
end

function Text:setPosition(x, y)
    PhysBox.setPosition(self, x + self.width/2 + 16, y + self.height/2 + 16)
end

function Text:update(dt)
end

function Text:draw()
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

return Text
