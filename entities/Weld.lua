
-- This is an empty entity. It's created when the map editor
-- Doesn't supply

PhysBox = require("entities.physbox")

Weld = class("Weld", PhysBox)

function Weld:initialize()
    PhysBox.initialize(self)
end

function Weld:fixSpawnPosition()
end

function Weld:postSpawn()
    local objs1 = map:findObjectsByName(self:getProperty("object1"))
    local obj1 = objs1[1]

    if not obj1 then return end
    if not obj1.body then return end

    local objs2 = map:findObjectsByName(self:getProperty("object2"))
    local obj2 = objs2[1]

    if not obj2 then return end
    if not obj2.body then return end

    self.joint = love.physics.newWeldJoint(obj1.body, obj2.body, self.x, self.y, false)
end

function Weld:event_start()
end

function Weld:initPhysics()
end

function Weld:setPosition(x, y)
    self.x = x
    self.y = y
end

function Weld:getPosition()
    return self.x, self.y
end

function Weld:isTouchingPlayer()
end

function Weld:update(dt)
end

function Weld:draw()
end

function Weld:destroy()
    PhysBox.destroy(self)
    self.joint:destroy()
end

return Weld
