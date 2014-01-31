
-- This is an empty entity. It's created when the map editor
-- Doesn't supply

PhysBox = require("entities.physbox")

Timer = class("Timer", PhysBox)

function Timer:initialize()
    PhysBox.initialize(self)
    self.activated = false
    self.timeLife = 0
end

function Timer:event_start()
    self.timeLife = tonumber(self.time) or 0
end

function Timer:initPhysics()
end

function Timer:setPosition(x, y)
    self.x = x
    self.y = y
end

function Timer:getPosition()
    return self.x, self.y
end

function Timer:isTouchingPlayer()
end

function Timer:update(dt)
    if self.timeLife > 0 then
        self.timeLife = self.timeLife - dt
        if self.timeLife <= 0 then
            self:trigger("onend")
        end
    end
end

function Timer:draw()
end

return Timer
