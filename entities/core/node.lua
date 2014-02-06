
-- This is an empty entity. It's created when the map editor
-- Doesn't supply

BaseEntity = require("entities.core.baseentity")

Node = class("Node", BaseEntity)

function Node:initialize()
    BaseEntity.initialize(self)
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
