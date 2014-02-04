
PhysBox = require("entities.physbox")

Flag = class("Flag", PhysBox)

function Flag:initialize()
    PhysBox.initialize(self)

    self.spritesheet1 = SpriteSheet:new("sprites/Flag_blue.png", 32, 32)
    self.spritesheet2 = SpriteSheet:new("sprites/Flag_green.png", 32, 32)
end

function Flag:postSpawn()
end

function Flag:initPhysics()
end

function Flag:setPosition(x, y)
    self.x = x
    self.y = y
end

function Flag:isTouchingPlayer()
    for k,v in pairs(self.touching) do
        if v.type == "PLAYER" then
            return v
        end
    end
    return false
end

function Flag:update(dt)
    if self.FlagDelay > 0 then
        self.FlagDelay = self.FlagDelay - dt
    end

    local isTouching = self:isTouchingPlayer()

    if self.FlagDelay <= 0 then
        if isTouching and not self.hasPressedLastUpdate then
            self:trigger("onpress", isTouching)
            self.FlagDelay = 0.25
            self.pressed = true
        end
    end

    if not isTouching and self.pressed and self.FlagDelay <= 0 then
        self:trigger("onrelease", isTouching)
        self.pressed = false
    end

    self.hasPressedLastUpdate = isTouching
end

function Flag:draw()
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)

    love.graphics.setColor(255, 255, 255)
    if self.pressed then
        if self.collisiongroup == "blue" then
            self.spritesheet1:draw(1, 0, -16, -16-8)
        else
            self.spritesheet2:draw(1, 0, -16, -16-8)
        end
    else
        if self.collisiongroup == "blue" then
            self.spritesheet1:draw(0, 0, -16, -16-8)
        else
            self.spritesheet2:draw(0, 0, -16, -16-8)
        end
    end

    love.graphics.pop()
end

return Flag
