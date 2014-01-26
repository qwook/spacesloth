
PhysBox = require("physbox")

TitleScreen = class("TitleScreen", PhysBox)

function TitleScreen:initialize()
    PhysBox.initialize(self)
    singleCamera = true
    self.isCamera = true
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
end

return TitleScreen
