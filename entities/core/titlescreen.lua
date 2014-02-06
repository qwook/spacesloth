
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

function TitleScreen:initPhysics()
end

function TitleScreen:setPosition(x, y)
    self.x = x
    self.y = y
end

function TitleScreen:getPosition()
    return self.x, self.y
end

function TitleScreen:getCameraPosition(x, y)
    return self.x, self.y
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
    -- love.graphics.draw(self.image, -self.image:getWidth()/2, -self.image:getHeight()/2)
end

return TitleScreen
