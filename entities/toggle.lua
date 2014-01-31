
PhysBox = require("entities.physbox")

Toggle = class("Toggle", PhysBox)

function Toggle:initialize()
    PhysBox.initialize(self)

    self.spritesheet1 = SpriteSheet:new("assets/sprites/switch_blue.png", 32, 32)
    self.spritesheet2 = SpriteSheet:new("assets/sprites/switch_green.png", 32, 32)
end

function Toggle:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'static')
    self.shape = love.physics.newRectangleShape(32, 0.15)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setUserData(self)
    self.fixture:setFriction(0.5)

    self.hasPressedLastUpdate = false
    self.ToggleDelay = 0
    self.pressed = false
end

function Toggle:setPosition(x, y)
    PhysBox.setPosition(self, x+8, y+10)
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
        self:trigger(self.ontoggle, isTouching)
        self.ToggleDelay = 0.25
        self.pressed = not self.pressed
        if self.pressed == true then
            self:trigger(self.onpress, isTouching)
            playSound("clack_down.wav")
        else
            self:trigger(self.onrelease, isTouching)
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
            self.spritesheet1:draw(1, 0, -16, -16-10)
        else
            self.spritesheet2:draw(1, 0, -16, -16-10)
        end
    else
        if self.collisiongroup == "blue" then
            self.spritesheet1:draw(0, 0, -16, -16-10)
        else
            self.spritesheet2:draw(0, 0, -16, -16-10)
        end
    end

    love.graphics.pop()
end

return Toggle
