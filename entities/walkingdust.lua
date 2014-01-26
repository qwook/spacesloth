
Particle = require("entities.particle")

WalkingDust = class("Particle", Particle)

function WalkingDust:initialize()
    Particle.initialize(self)

    self.lifetime = 0.5
    self.spritesheet = SpriteSheet:new("assets/dust2.png", 32, 32)
end

function WalkingDust:draw()
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)
    love.graphics.scale(2)

    love.graphics.setColor(141, 143, 166)
    self.spritesheet:draw(math.floor((0.5 - self.lifetime)/0.5*5)%5, 0, -16, -16)
    print(math.floor((0.5 - self.lifetime)/0.5*5)%5)

    love.graphics.pop()
end

return WalkingDust
