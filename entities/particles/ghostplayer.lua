
Particle = require("entities.core.particle")

GhostPlayer = class("Particle", Particle)
GhostPlayer.spritesheet = SpriteSheet:new("sprites/players.png", 32, 32)

function GhostPlayer:initialize()
    Particle.initialize(self)

    self.zindex = nil
    self.scale = 1
    self.lifetime = 0.5

    self.ang = 0
end

function GhostPlayer:setAim(x, y)
    self.xAim = x
    self.yAim = y
    self.ang = math.atan2(y, x)
end

function GhostPlayer:update(dt)
    Particle.update(self, dt)
end

function GhostPlayer:draw()
    self.spritesheet:draw(0, 0, -16, -18)
    local x, y = self:getPosition()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(self.ang)

    self.xAim = self.xAim or 0
    self.yAim = self.yAim or 0

    -- love.graphics.setLineWidth(3)

    love.graphics.setColor(255, 255, 255, self.lifetime/0.5 * 255)
    self.spritesheet:draw(0, 1, -16, -18)
    -- love.graphics.line(0, 0, self.xAim, self.yAim)
    -- love.graphics.line(self.xAim, self.yAim, self.xAim + math.cos(self.ang+math.pi*(3/4))*10, self.yAim + math.sin(self.ang+math.pi*(3/4))*10)
    -- love.graphics.line(self.xAim, self.yAim, self.xAim + math.cos(self.ang-math.pi*(3/4))*10, self.yAim + math.sin(self.ang-math.pi*(3/4))*10)

    -- love.graphics.setLineWidth(1)

    love.graphics.pop()
end

return GhostPlayer
