
STI = require("libs.sti")

Map = class("Map")

function Map:initialize()
    self.map = {}
end

function Map:initPhysics()
    -- self.body = love.physics.newBody(world, 0, 0, 'dynamic')
    -- self.shape = love.physics.newRectangleShape(50, 50)
    -- self.fixture = love.physics.newFixture(self.body, self.shape, 1)
end

-- function Map:getPosition()
    -- return self.body:getPosition()
-- end

-- function Map:setPosition(x, y)
    -- return self.body:setPosition(x, y)
-- end

function Map:set(x, y, tile)
    self.map[y] = self.map[y] or {}
    self.map[y][x] = tile

    tile:setPosition(x * 50, y * 50)
end

function Map:get(x, y)
    if self.map[y] == nil then
        return nil
    end

    return self.map[y][x]
end

function Map:draw()
    for y, row in pairs(self.map) do
        for x, tile in pairs(row) do
            tile:draw()
        end
    end
end

return Map
