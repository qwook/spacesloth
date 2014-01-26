
Physical = require("physical")

PhysBox = class("PhysBox", Physical)

function PhysBox:initialize()
    self:initPhysics()
    self.contacts = {}
    self.touching = {}

    self.spritesheet = SpriteSheet:new("assets/box_generic.png", 32, 32)

    table.insert(map.objects, self)
end

function PhysBox:eval(str, activator)
    local name, event, arg = string.match(str, "([0-9A-z]+)%:([0-9A-z]+)%(([^%.]*)%)")

    if not name or not event or not arg then return end

    local args = {}
    string.gsub(arg, "[^, ]+", function(a) table.insert(args, a) end)

    local objs

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
    local n = tostring(event)
    if n then
        self:eval(n, activator)
    end
end

function PhysBox:destroy()
    table.removevalue(map.objects, self)
end

function PhysBox:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'dynamic')
    self.shape = love.physics.newRectangleShape(32, 32)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setUserData(self)
    self.fixture:setFriction(0.1)
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
    -- love.graphics.rectangle('fill', -16, -16, 32, 32)
    self.spritesheet:draw(0, 0, -16, -16)

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