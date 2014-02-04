
-- A camera control entity
-- Triggers:
-- cameraname:setActivated(true)
-- cameraname:setActivated(false)
--
-- Events:
-- onDone

PhysBox = require("entities.physbox")

Camera = class("Camera", PhysBox)

function Camera:initialize()
    PhysBox.initialize(self)
    self.isCamera = true
    self.activated = false
end

function Camera:postSpawn()
end

function Camera:event_setactivated(activated)
    if activated == "true" then
        self.activated = true
    else
        self.activated = false
    end
end

function Camera:update(dt)
end

function Camera:postSpawn()
    self.scale = self.scale or 1
end

function Camera:initPhysics()
end

function Camera:getCameraPosition()
    return self.x, self.y
end

function Camera:getScale()
    return 1
end

function Camera:setPosition(x, y)
    self.x = x
    self.y = y
end

function Camera:getPosition()
    return self.x, self.y
end

function Camera:draw()
end

return Camera
