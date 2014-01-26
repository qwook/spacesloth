
PhysBox = require("physbox")

Prop = class("Prop", PhysBox)

function Prop:initialize()
    PhysBox.initialize(self)
end

function Prop:postSpawn()
    self.animlife = 0
    self.spritewidth = tonumber(self.spritewidth)
    self.spriteheight = tonumber(self.spriteheight)
    self.spritesheet = SpriteSheet:new("assets/sprites/" .. self.sprite, self.spritewidth, self.spriteheight)

    -- local x, y = self:getPosition()
    -- self:setPosition(x + self.spritewidth, y)
end

function Prop:event_loopAnimation(y, xfrom, xto, speed)
    self.animspeed = speed
    self.animlife = 0
    self.animy = tonumber(y)
    self.xfrom = tonumber(xfrom)
    self.xto = tonumber(xto)
    self.loop = true
end

function Prop:event_playAnimation(y, xfrom, xto, duration)
    self.animlife = tonumber(duration)
    self.animduration = tonumber(duration)
    self.animy = tonumber(y)
    self.xfrom = tonumber(xfrom)
    self.xto = tonumber(xto)
    self.loop = false
end

function Prop:update(dt)
    if self.loop then
        self.animlife = self.animlife + dt * self.animspeed
    end

    if self.animlife > 0 and not self.loop then
        self.animlife = self.animlife - dt
    end
end

function Prop:draw()
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)

    love.graphics.setColor(255, 255, 255)


    if self.animlife > 0 then
        local t

        if self.loop then
            t = self.animlife
        else
            t = (self.animduration - self.animlife) / self.animduration
        end

        local s = (self.xto - self.xfrom) + 1
        self.spritesheet:draw(self.xfrom + (math.floor(t*s) % s), self.animy, -self.spritewidth/2, -self.spriteheight/2)
    else
        self.spritesheet:draw(0, 0, -self.spritewidth/2, -self.spriteheight/2)
    end

    love.graphics.pop()
end

function Prop:initPhysics()
end

function Prop:setPosition(x, y)
    self.x = x
    self.y = y
end

function Prop:getPosition()
    return self.x, self.y
end

function Prop:setAngle(r)
end

function Prop:getAngle()
    return 0
end

return Prop
