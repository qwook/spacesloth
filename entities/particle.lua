
PhysBox = require("physbox")

Particle = class("Particle", PhysBox)

function Particle:initialize()
    PhysBox.initialize(self)

    self.x = 0
    self.y = 0

    self.lifetime = 1

    self.spritesheet = SpriteSheet:new("assets/dust1.png", 32, 32)
end

function Particle:initPhysics()
    -- no physics
end

function Particle:setPosition(x, y)
    self.x = x
    self.y = y
end

function Particle:getPosition()
    return self.x, self.y
end

function Particle:getAngle(r)
    return 0
end

function Particle:update(dt)
    self.lifetime = self.lifetime - dt
    if self.lifetime < 0 then
        self:destroy()
    end
    print(self.lifetime)
end

function Particle:draw()
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)

    love.graphics.setColor(255, 255, 255)
    self.spritesheet:draw(math.floor(1 - self.lifetime)%7, 0, -16, -16)

    love.graphics.pop()
end

return Particle
