
PhysBox = require("entities.physbox")

Toggle = class("Toggle", PhysBox)

function Toggle:initialize()
    PhysBox.initialize(self)

    self.spritesheet1 = SpriteSheet:new("sprites/switch_blue.png", 32, 32)
    self.spritesheet2 = SpriteSheet:new("sprites/switch_green.png", 32, 32)
end

function Toggle:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, self:getProperty("phystype") or 'static')
    self.shape = love.physics.newPolygonShape(-16, 3, 16, 3, 8, -3, -8, -3 )
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setUserData(self)
    self.fixture:setFriction(0.5)

    self.hasPressedLastUpdate = false
    self.ToggleDelay = 0
    self.pressed = false
end

function Toggle:fixSpawnPosition()
    local x, y = self:getPosition()
    self:setPosition(x+32, y+12)
end

function Toggle:postSpawn()
end

function Toggle:isTouchingPlayer()
    for k,v in pairs(self.touching) do
        if v.type == "PLAYER" then
            return v
        end
    end
    return false
end

function Toggle:update(dt)
    if self.ToggleDelay > 0 then
        self.ToggleDelay = self.ToggleDelay - dt
    end

    local isTouching = self:isTouchingPlayer()

    if isTouching and isTouching.controller:wasKeyPressed("crouch") then
        self:trigger("ontoggle", isTouching)
        self.ToggleDelay = 0.25
        self.pressed = not self.pressed
        if self.pressed == true then
            self:trigger("onpress", isTouching)
            playSound("clack_down.wav")
        else
            self:trigger("onrelease", isTouching)
            playSound("clack_up.wav")
        end
    end

    self.hasPressedLastUpdate = isTouching
end

function Toggle:draw()
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
end

return Toggle
