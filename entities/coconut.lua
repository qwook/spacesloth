
BaseEntity = require("entities.core.baseentity")

Coconut = class("Coconut", BaseEntity)

function Coconut:initialize()
    BaseEntity.initialize(self)
    self.isCoconut = true
    self.nextDie = 1
end

function Coconut:initPhysics()
    local shape = love.physics.newCircleShape(16)
    self:makeSolid("dynamic", shape)
    self:setFriction(0)
end

function Coconut:update(dt)
    self.nextDie = self.nextDie - dt
    if self.nextDie <= 0 then
        self:destroy()
    end
end

function Coconut:draw()
end

return Coconut
