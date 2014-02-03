
PhysBox = require("entities.physbox")

Trampoline = class("Trampoline", PhysBox)

function Trampoline:initialize(x, y, w, h)
    PhysBox.initialize(self)
    self.width = w
    self.height = h
    self.touching = {}
end

function Trampoline:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'static')
    self.shape = love.physics.newRectangleShape(32, 16)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setSensor(true)
    self.fixture:setUserData(self)
end

function Trampoline:update(dt)
end

-- the reason I offset the position and setposition by 16,
-- is because the physics object is set by the origin
-- so i offset it by the origin.
-- other strange factors also occur, idk.
function Trampoline:getPosition()
    local x, y = PhysBox.getPosition(self)
    return x-16, y
end

function Trampoline:setPosition(x, y)
    PhysBox.setPosition(self, x+16, y)
end

function Trampoline:touchedPlayer(player)

    -- no goal set
    if not self.goal then return end

    -- find the goal object
    local goals, goal = map:findObjectsByName(self.goal)
    if goals[1] == nil then
        return
    else
        goal = goals[1]
    end

    local xPlayerPos, yPlayerPos = player:getPosition()
    local xGoalPos, yGoalPos = goal:getPosition()

    dx = xGoalPos - xPlayerPos
    dy = yGoalPos - yPlayerPos
    print("dx: " .. dx .. " dy: " .. dy)
    local vel = math.sqrt((math.pow(dx, 2)*GRAVITY)/(2*(dx+dy)))
    print(vel)
    if vel == vel then
        player:setVelocity(vel, -vel)
    end

end

function Trampoline:draw()
    if not DEBUG then return end
    
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)

    love.graphics.setColor(0, 255, 0, 100)
    love.graphics.rectangle('fill', 0, 0, 32, 16)
    love.graphics.rectangle('line', 0, 0, 32, 16)

    love.graphics.pop()
end

function Trampoline:beginContact(other, contact, isother)
    onNextUpdate(function()
        if other.type == "PLAYER" then
            self:touchedPlayer(other)
        end
    end)
end

function Trampoline:endContact(other, contact, isother)
end

return Trampoline
