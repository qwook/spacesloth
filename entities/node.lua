
PhysBox = require("physbox")

Node = class("Node", PhysBox)

function Node:initialize()
    PhysBox.initialize(self)
end

function Node:initPhysics()
end

function Node:setPosition(x, y)
    self.x = x
    self.y = y
end

function Node:getPosition()
    return self.x, self.y
end

function Node:isTouchingPlayer()
end

function Node:update(dt)
end

function Node:draw()
end

return Node
