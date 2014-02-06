
BaseEntity = require("entities.core.baseentity")

Button = class("Button", BaseEntity)

function Button:initialize()
    PhysBox.initialize(self)

    self.spritesheet1 = SpriteSheet:new("sprites/button_blue.png", 32, 32)
    self.spritesheet2 = SpriteSheet:new("sprites/button_green.png", 32, 32)
end

function Button:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, self:getProperty("phystype") or 'static')
    self.shape = love.physics.newPolygonShape(-16, 3, 16, 3, 8, -3, -8, -3 )
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setUserData(self)
    self.fixture:setFriction(0.25)

    self.hasPressedLastUpdate = false
    self.buttonDelay = 0
    self.pressed = false
end

function Button:fixSpawnPosition()
    local x, y = self:getPosition()
    self:setPosition(x+32, y+12)
end

function Button:postSpawn()
end

function Button:isTouchingPlayer()
    for k,v in pairs(self.touching) do
        if v.type == "PLAYER" then
            return v
        end
    end
    return false
end

function Button:update(dt)
    if self.buttonDelay > 0 then
        self.buttonDelay = self.buttonDelay - dt
    end

    local isTouching = self:isTouchingPlayer()

    if self.buttonDelay <= 0 then
        if isTouching and not self.hasPressedLastUpdate then
            self:trigger("onpress", isTouching)
            self.buttonDelay = 0.25
            self.pressed = true
            playSound("click_hi.wav")
        end
    end

    if not isTouching and self.pressed and self.buttonDelay <= 0 then
        self:trigger("onrelease", isTouching)
        self.pressed = false
        playSound("click_lo.wav")
    end

    self.hasPressedLastUpdate = isTouching
end

function Button:draw()
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)

    love.graphics.setColor(255, 255, 255)
    if self.pressed then
        if self.collisiongroup == "blue" then
            self.spritesheet1:draw(1, 0, -16, -16 -12)
        else
            self.spritesheet2:draw(1, 0, -16, -16 -12)
        end
    else
        if self.collisiongroup == "blue" then
            self.spritesheet1:draw(0, 0, -16, -16 -12)
        else
            self.spritesheet2:draw(0, 0, -16, -16 -12)
        end
    end

    love.graphics.pop()

    -- love.graphics.setColor(255, 0, 0)
    -- love.graphics.polygon("fill", self.body:getWorldPoints( self.shape:getPoints() ))
    
end

return Button
