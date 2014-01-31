
PhysBox = require("entities.physbox")

LayerObject = class("LayerObject", PhysBox)

function LayerObject:initialize()
    PhysBox.initialize(self)
end

function LayerObject:initPhysics()
end

function LayerObject:setPosition(x, y)
    self.x = x
    self.y = y
end

function LayerObject:getPosition()
    return self.x, self.y
end

function LayerObject:isTouchingPlayer()
end

function LayerObject:update(dt)
end

function LayerObject:draw()
end

return LayerObject
