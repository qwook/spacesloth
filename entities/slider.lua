
-- This is an empty entity. It's created when the map editor
-- Doesn't supply

PhysBox = require("entities.physbox")

Slider = class("Slider", PhysBox)

function Slider:initialize()
    PhysBox.initialize(self)
end

function Slider:postSpawn()
    local objs = map:findObjectsByName(self:getProperty("object"))
    local obj = objs[1]

    if not obj then return end
    if not obj.body then return end

    local ang = math.rad(tonumber(self:getProperty("angle") or 0))

    love.physics.newPrismaticJoint(map.body, obj.body, self.x, self.y, math.cos(ang), math.sin(ang), true)
end

function Slider:event_start()
end

function Slider:initPhysics()
end

function Slider:setPosition(x, y)
    self.x = x
    self.y = y
end

function Slider:getPosition()
    return self.x, self.y
end

function Slider:isTouchingPlayer()
end

function Slider:update(dt)
end

function Slider:draw()
end

return Slider
