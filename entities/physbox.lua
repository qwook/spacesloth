
Physical = require("entities.core.physical")

PhysBox = class("PhysBox", Physical)

function PhysBox:initialize()
    self.contacts = {}
    self.touching = {}
    self.visible = true
    self.frozen = false

    self.width = 32
    self.height = 32
    self.spritesheet = SpriteSheet:new("sprites/box_generic.png", 32, 32)

    self.type = "PHYSBOX"

    table.insert(map.objects, self)
end

function PhysBox:postSpawn()
end

function PhysBox:eval(str, activator)
    local name, event, arg = string.match(str, "([0-9A-z]+)%:([0-9A-z]+)%(([^%)]*)%)")
    name = string.lower(name)
    event = string.lower(event)

    if not name or not event or not arg then return end

    local args = {}
    string.gsub(arg, "[^, ]+", function(a) table.insert(args, a) end)

    local objs = {}

    if name == "global" then
        if events[event] then
            events[event](events[event], unpack(args))
        end
        return
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

    for k, obj in pairs(objs) do
        if (obj.call) then
            obj:call(event, args)
        end
    end

end

function PhysBox:call(name, args)
    if self["event_" .. name] then
        self["event_" .. name](self, unpack(args))
    end
end

function PhysBox:trigger(event, activator)
    local n = self[string.lower(event)]
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
end

function PhysBox:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'dynamic')
    if self.brushw > 0 and self.brushh > 0 then
        self.width = self.brushw
        self.height = self.brushh
        self.shape = love.physics.newRectangleShape(self.brushw, self.brushh)
    else
        self.shape = love.physics.newRectangleShape(32, 32)
    end
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setUserData(self)
    self.fixture:setFriction(0.1)
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
            if not self.frozenJoint then
                local x, y = self:getPosition()
                self.frozenJoint = love.physics.newWeldJoint(self.body, map.body, x, y, true)
            end
        end
        self.visible = false
    end
end

function PhysBox:setPosition(x, y)
    self.body:setPosition(x, y)
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

    love.graphics.setColor(255, 255, 255)
    -- love.graphics.rectangle('fill', -self.width/2, -self.height/2, 32, 32)
    self.spritesheet:draw(0, 0, -self.width/2, -self.height/2, 0, self.width/32, self.height/32)

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
