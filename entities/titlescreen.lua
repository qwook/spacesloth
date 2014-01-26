
PhysBox = require("physbox")

TitleScreen = class("TitleScreen", PhysBox)

function TitleScreen:initialize()
    PhysBox.initialize(self)
    singleCamera = true
    self.isCamera = true

    self.image = love.graphics.newImage("assets/sprites/bako.png")
end

function TitleScreen:initPhysics()
end

function TitleScreen:setPosition(x, y)
    self.x = x
    self.y = y
end

function TitleScreen:getPosition()
    return self.x, self.y
end

function TitleScreen:isTouchingPlayer()
end

function TitleScreen:update(dt)
end

function TitleScreen:draw()
    local x, y = self:getPosition()
    love.graphics.draw(self.image, x-self.image:getWidth()/2, y-self.image:getHeight()/2)
    -- love.graphics.draw(self.image, -self.image:getWidth()/2, -self.image:getHeight()/2)
end

return TitleScreen
