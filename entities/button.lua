
PhysBox = require("physbox")

Button = class("Button", PhysBox)

function Button:initialize()
    PhysBox.initialize(self)

    self.spritesheet1 = SpriteSheet:new("assets/button_blue.png", 32, 32)
    self.spritesheet2 = SpriteSheet:new("assets/button_green.png", 32, 32)
end

function Button:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'static')
    self.shape = love.physics.newRectangleShape(32, 0.15)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setUserData(self)
    self.fixture:setFriction(0.5)
end

function Button:setPosition(x, y)
    PhysBox.setPosition(self, x, y+8)
end

function Button:isTouchingPlayer()
    for k,v in pairs(self.touching) do
        if v.type == "PLAYER" then
            return true
        end
    end
    return false
end

function Button:update(dt)
end

function Button:draw()
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)

    love.graphics.setColor(255, 255, 255)
    if self:isTouchingPlayer() then
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

return Button
