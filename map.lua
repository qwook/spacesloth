
STI = require("libs.sti")
Tile = require("tile")

Map = class("Map")

function Map:initialize(mapname)
    self.map = {}
    self.objects = {}

    self.tiledmap = STI.new(mapname)
    self.tiledmap:createCollisionMap("Collision")

    self.background = self:getImageLayer("Background")

    local collision = self.tiledmap.collision.data

    for y, row in pairs(collision) do
        for x, tile in pairs(row) do
            if (tile == 1) then
                local colshape = self.tiledmap.layers["Collision"].data[y][x].properties.colshape
                if (colshape == "1") then
                    self:set(x, y, Tile:new(self.tiledmap.tilewidth, self.tiledmap.tileheight))
                elseif (colshape == "2") then
                    self:set(x, y, Tile2:new(self.tiledmap.tilewidth, self.tiledmap.tileheight))
                elseif (colshape == "3") then
                    self:set(x, y, Tile3:new(self.tiledmap.tilewidth, self.tiledmap.tileheight))
                elseif (colshape == "4") then
                    self:set(x, y, Tile4:new(self.tiledmap.tilewidth, self.tiledmap.tileheight))
                elseif (colshape == "5") then
                    self:set(x, y, Tile5:new(self.tiledmap.tilewidth, self.tiledmap.tileheight))
                end
            end
        end
    end
end

function Map:spawnObjects()
    for _, v in pairs(self:getObjectsLayer("Objects")) do
        if v.name == "player1" then
            player = Player:new()
            player:setController(input)
            player:setPosition(v.x + 16, v.y + 16)
        elseif v.name == "player2" then
            player2 = Cindy:new()
            player2:setController(input2)
            player2:setPosition(v.x + 16, v.y + 16)
        elseif tostring(v.type) and _G[v.type] and type(_G[v.type]) == "table" then
            local instance = _G[v.type]:new()
            instance:setPosition(v.x + 16, v.y + 16)
        end
    end
end

function Map:getImageLayer(layername)
    if self.tiledmap.layers[layername] == nil then return nil end
    return self.tiledmap.layers[layername].image
end

function Map:getObjectsLayer(layername)
    if self.tiledmap.layers[layername] == nil then return {} end
    return self.tiledmap.layers[layername].objects or {}
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

    tile:setPosition(x * self.tiledmap.tilewidth, y * self.tiledmap.tileheight)
end

function Map:get(x, y)
    if self.map[y] == nil then
        return nil
    end

    return self.map[y][x]
end

function Map:draw()
    love.graphics.push()
    love.graphics.translate(self.tiledmap.tilewidth/2, self.tiledmap.tileheight/2)
    love.graphics.setColor(255, 255, 255, 255)
    self.tiledmap:drawTileLayer(self.tiledmap.layers["Ground"])
    love.graphics.pop()
    -- self.tiledmap:drawCollisionMap()

    -- for y, row in pairs(self.map) do
    --     for x, tile in pairs(row) do
    --         tile:draw()
    --     end
    -- end
end

return Map
