
Physical = require("entities.core.physical")

PhysBox = class("PhysBox", BaseEntity)

function PhysBox:initialize()
    self.name = "noname"
    self.contacts = {}
    self.touching = {}
    self.properties = {}
    self.visible = true
    self.frozen = false
    self.solid = true
    self.color = {r = 255, g = 255, b = 255, a = 255}

    self.width = 32
    self.height = 32
    self.spritesheet = SpriteSheet:new("sprites/box_generic.png", 32, 32)
    self.image = loadImage("sprites/doorcrate.gif"):getData()

    self.type = "PHYSBOX"

    table.insert(map.objects, self)
end

-- this will act as if an image is a framebuffer and draws on it
local function blit(dst, src, dx, dy, sx, sy, sw, sh)
    dst:mapPixel(function(x, y, r, g, b, a)
                 if (x >= dx and x < dx + sw) and
                    (y >= dy and y < dy + sh) then

                    local deltax = (x - dx)
                    local deltay = (y - dy)

                    local r, g, b, a = src:getPixel(sx + deltax, sy + deltay)
                    if a > 0 then
                        return r, g, b, a
                    end

                 end

                 return r, g, b, a
    end)
end

function PhysBox:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, self:getProperty("phystype") or 'dynamic')
    
    if self.brushw > 0 and self.brushh > 0 then
        self.width = self.brushw
        self.height = self.brushh
        self.shape = love.physics.newRectangleShape(self.brushw, self.brushh)
    else
        self.shape = love.physics.newRectangleShape(32, 32)
    end
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setUserData(self)

    -- generate a randomized box thing
    local data = love.image.newImageData(self.width, self.height)

    -- draw inner boxes
    for x = 0, math.ceil(self.width/32) do
        for y = 0, math.ceil(self.height/32) do
            blit(data, self.image, x*32, y*32, 32*math.floor(math.random(3, 4)), 0, 32, 32)
        end
    end

    -- draw sides
    for x = 0, math.ceil(self.width/32) do
        blit(data, self.image, x*32, 0, 32*1, 0, 32, 32)
        blit(data, self.image, x*32, self.height-32, 32*1, 32*2, 32, 32)
    end
    for y = 0, math.ceil(self.height/32) do
        blit(data, self.image, 0, y*32, 0, 32*1, 32, 32)
        blit(data, self.image, self.width-32, y*32, 32*2, 32*1, 32, 32)
    end

    -- draw corners
    blit(data, self.image, 0, 0, 0, 0, 32, 32)
    blit(data, self.image, self.width-32, 0, 32*2, 0, 32, 32)
    blit(data, self.image, self.width-32, self.height-32, 32*2, 32*2, 32, 32)
    blit(data, self.image, 0, self.height-32, 0, 32*2, 32, 32)
    self.generatedbox = love.graphics.newImage(data)

end

-- tiled wrongly offsets stuff
function PhysBox:fixSpawnPosition()
    local x, y = self:getPosition()
    self:setPosition(x + self.width/2 + 16, y + self.height/2 + 16)
end

function PhysBox:postSpawn()
end

function PhysBox:destroy()
    table.removevalue(map.objects, self)

    if self.fixture then
        self.fixture:destroy()
    end
    if self.body then
        self.body:destroy()
    end
    self.body = nil
    self.fixture = nil
    self.shape = nil
end

function PhysBox:update(dt)
end

function PhysBox:draw()
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)

    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    love.graphics.draw(self.generatedbox, -self.width/2, -self.height/2)

    love.graphics.pop()
end

function PhysBox:beginContact(other, contact)
    table.insert(self.contacts, contact)
    table.insert(self.touching, other)
end

function PhysBox:endContact(other, contact)
    table.removevalue(self.contacts, contact)
    table.removeonevalue(self.touching, other)
end

return PhysBox
