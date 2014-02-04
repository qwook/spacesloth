
Physical = require("entities.core.physical")

PhysBox = class("PhysBox", Physical)

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
    -- self.spritesheet = SpriteSheet:new("sprites/doorcrate.png", 32, 32)
    self.image = loadImage("sprites/doorcrate.gif"):getData()

    self.type = "PHYSBOX"

    table.insert(map.objects, self)
end

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

function PhysBox:eval(str, activator)
    local name, event, arg = string.match(str, "([0-9A-z]+)%:([0-9A-z]+)%(([^%)]*)%)")

    if not name then print("[map syntax error: " .. self.name .. "] no name") return end
    if not event then print("[map syntax error: " .. self.name .. "] no event") return end

    name = string.lower(name)
    event = string.lower(event)

    local args = {}
    string.gsub(arg, "[^, ]+", function(a) table.insert(args, a) end)

    local objs = {}

    if name == "global" then
        if events[event] then
            events[event](events[event], unpack(args))
        end
        return
    elseif name == "self" then
        objs = {self}
    elseif name == "player1" then
        objs = {player}
    elseif name == "player2" then
        objs = {player2}
    elseif name == "activator" then
        objs = {activator}
    else
        for k,v in pairs(map.objects) do
            if v.name == name then
                table.insert(objs, v)
            end
        end
    end

    if #objs == 0 then
        print("[map warning: " .. self.name .. "] no such object named: " .. name)
    end

    for k, obj in pairs(objs) do
        if (obj.call) then
            obj:call(event, args)
        end
    end

end

function PhysBox:setProperty(name, value)
    self.properties[name:lower()] = value
end

function PhysBox:getProperty(name)
    for k,v in pairs(self.properties) do
        if k:lower() == name:lower() then
            return v
        end
    end
end

function PhysBox:call(name, args)
    if self["event_" .. name:lower()] then
        self["event_" .. name:lower()](self, unpack(args))
    else
        print("[map warning: " .. self.name .. "] no such event named: " .. name)
    end
end

function PhysBox:trigger(event, activator)
    local n = self:getProperty(event)
    if n then
        local events = {}
        string.gsub(n..";", "([^;]+);", function(a) table.insert(events, a) end)
        for _, i in pairs(events) do
            self:eval(i, activator)
        end
    end
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

function PhysBox:event_setcolor(r, g, b, a)
    self.color = {r = tonumber(r), g = tonumber(g), b = tonumber(b), a = tonumber(a)}
end

function PhysBox:event_setcollisiongroup(group)
    self.collisiongroup = group
    player:forceCollisionRecalculation()
    player2:forceCollisionRecalculation()
end

function PhysBox:event_destroy()
    self:destroy()
end

function PhysBox:event_teleportto(name)

    for k,v in pairs(map.objects) do
        if v.name == name then
            -- print(v:getPosition())
            self:setPosition(v:getPosition())
            -- self:setPosition(self:getPosition())
            return
        end
    end
end


function PhysBox:event_setgravity(gravity)
    if not self.body then return end
    self.body:setGravityScale(tonumber(gravity))
end

-- when you freeze a box, you basically weld it to the world
function PhysBox:event_setfrozen(frozen)
    if not self.body then return end
    if frozen == "true" then
        self.frozen = true
        if self.frozenJoint or not self.visible then return end
        local x, y = self:getPosition()
        self.frozenJoint = love.physics.newWeldJoint(self.body, map.body, x, y, true)
    elseif frozen == "false" then
        self.frozen = false
        if not self.frozenJoint or not self.visible then return end
        self.frozenJoint:destroy()
        self.frozenJoint = nil
    end
end

function PhysBox:event_setvisible(visible)
    if visible == "true" then
        if not self.frozen then
            if self.frozenJoint then
                self.frozenJoint:destroy()
                self.frozenJoint = nil
            end
        end
        self.visible = true
    elseif visible == "false" then
        if self.visible then
            if not self.frozenJoint and self.body then
                local x, y = self:getPosition()
                self.frozenJoint = love.physics.newWeldJoint(self.body, map.body, x, y, true)
            end
        end
        self.visible = false
    end
    player:forceCollisionRecalculation()
    player2:forceCollisionRecalculation()
end

function PhysBox:event_setvelocity(x, y)
    self.body:setLinearVelocity(tonumber(x), tonumber(y))
end

function PhysBox:setPosition(x, y)
    local hadFrozenJoint = false
    if self.frozenJoint then
        hadFrozenJoint = true
        self.frozenJoint:destroy()
    end
    self.body:setPosition(x, y)
    if hadFrozenJoint then
        local x, y = self:getPosition()
        self.frozenJoint = love.physics.newWeldJoint(self.body, map.body, x, y, true)
    end
end

function PhysBox:getPosition()
    return self.body:getPosition()
end

function PhysBox:getAngle(r)
    self.body:getAngle(r)
end

function PhysBox:getAngle()
    return self.body:getAngle()
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
    -- love.graphics.rectangle('fill', -self.width/2, -self.height/2, 32, 32)
    -- self.spritesheet:draw(0, 0, -self.width/2, -self.height/2, 0, self.width/32, self.height/32)
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
