
PhysBox = require("entities.physbox")

Text = class("Text", PhysBox)

function Text:initialize(x, y, w, h)
    PhysBox.initialize(self)
    self.string = ""
    self.width = w
    self.height = h
    self.typing = false
    self.typeprogr = 0
    self.nexttype = 0
end

function Text:event_type()
    self:event_setvisible("true")

    self.typing = true
    self.typeprogr = 0
    self.nexttype = 0.05
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
    if self.typing and self.typeprogr <= self.string:len() then
        self.nexttype = self.nexttype - dt
        if (self.nexttype <= 0) then
            self.nexttype = 0.05
            self.typeprogr = self.typeprogr + 1
        end
    end
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
    love.graphics.printf(self.string:sub(0, self.typeprogr), 10, 10, self.width - 20)

    love.graphics.pop()
end

return Text
