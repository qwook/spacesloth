
PhysBox = require("entities.physbox")

Text = class("Text", PhysBox)

function Text:initialize(x, y, w, h)
    self.width = w
    self.height = h
    PhysBox.initialize(self)
end

function Text:initPhysics()
end

function Text:setPosition(x, y)
    self.x = x
    self.y = y
    -- PhysBox.setPosition(self, x + self.width/2 + 16, y + self.height/2 + 16)
end

function Text:getPosition()
    return self.x, self.y
end

function Text:getAngle()
    return 0
end

function Text:update(dt)
end

function Text:draw()
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)

    local font = love.graphics.getFont()
    local width, lines = font:getWrap(self.string, self.width - 20)

    local height = lines*(font:getHeight())

    love.graphics.setColor(0, 0, 0, 100)
    love.graphics.rectangle('fill', 0, 0, self.width, height + 20)
    love.graphics.rectangle('line', 0, 0, self.width, height + 20)

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf(self.string, 10, 10, self.width - 20)

    love.graphics.pop()
end

return Text
