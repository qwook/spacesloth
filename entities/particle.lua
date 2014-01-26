
PhysBox = require("physbox")

Particle = class("Particle", PhysBox)

function Particle:initialize()
    PhysBox.initialize(self)

    self.zindex = -1
    self.x = 0
    self.y = 0

    self.lifetime = 0.5

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
    love.graphics.scale(2)

    love.graphics.setColor(141, 143, 166)
    self.spritesheet:draw(math.floor((0.5 - self.lifetime)/0.5*6)%6, 0, -16, -16)
    print(math.floor((0.5 - self.lifetime)/0.5*6)%6)

    love.graphics.pop()
end

return Particle
