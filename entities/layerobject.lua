
BaseEntity = require("entities.core.baseentity")

LayerObject = class("LayerObject", BaseEntity)

function LayerObject:initialize()
    PhysBox.initialize(self)
end

function LayerObject:fixSpawnPosition()
end

function LayerObject:postSpawn()
    -- print(self.collision)
    -- print(self.display)
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
