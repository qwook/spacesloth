
Tile = class("Tile")

function Tile:initialize()
    self:initPhysics()
end

function Tile:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'static')
    self.shape = love.physics.newRectangleShape(50, 50)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
end

function Tile:getPosition()
    return self.body:getPosition()
end

function Tile:setPosition(x, y)
    self.body:setPosition(x, y)
end

function Tile:draw()
    local x, y = self:getPosition()

    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle('fill', x, y, 50, 50)
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('line', x, y, 50, 50)
end

return Tile
