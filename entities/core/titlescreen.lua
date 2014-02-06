
BaseEntity = require("entities.core.baseentity")

TitleScreen = class("TitleScreen", BaseEntity)

function TitleScreen:initialize()
    BaseEntity.initialize(self)
    singleCamera = true
    self.isCamera = true

    self.life = 0

    self.image = love.graphics.newImage("assets/sprites/bako.png")
    self.image:setFilter('linear', 'linear')
end

function TitleScreen:getCameraPosition()
    return self:getPosition()
end

function TitleScreen:update(dt)
    if self.life < 1 then
        self.life = self.life + dt
    else
        self.life = 1
    end
end

function TitleScreen:draw()
    local bounce = math.outBounce(self.life, 0, 1, 1)

    local x, y = self:getPosition()
    love.graphics.draw(self.image, x-self.image:getWidth()/2 * 1, y-self.image:getHeight()/2 + bounce*500 - 600, 0, 1)
end

return TitleScreen
