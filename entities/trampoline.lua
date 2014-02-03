
PhysBox = require("entities.physbox")

Trampoline = class("Trampoline", PhysBox)

function Trampoline:initialize(x, y, w, h)
    PhysBox.initialize(self)
    self.width = w
    self.height = h
    self.solid = false
    self.touching = {}
    self.spritesheet = SpriteSheet:new("sprites/trampoline_angled.png", 32, 32)
end

function Trampoline:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'static')
    self.shape = love.physics.newRectangleShape(32, 16)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setSensor(true)
    self.fixture:setUserData(self)

    self.anim = 0
end

function Trampoline:update(dt)
    if self.anim > 0 then
        self.anim = self.anim - dt*3
    end
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

    player:setVelocity(0, -0)

    self.anim = 1
    setTimeout(function()
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

        xGoalPos = xGoalPos + 32 -- slight adjustment

        dx = xGoalPos - xPlayerPos
        dy = yGoalPos - yPlayerPos
        print("dx: " .. dx .. " dy: " .. dy)
        local vel = math.sqrt((math.pow(dx, 2)*GRAVITY)/(2*(dx+dy)))
        print(vel)
        if vel == vel then
            player:setVelocity(vel, -vel)
            player:stopJump()
            playSound("thwap.wav")
        end
    end,
    0.12)

end

function Trampoline:draw()
    if not DEBUG then return end
    
    local x, y = self:getPosition()
    local r = self:getAngle()

    local anim = 0

    if self.anim > 0 then
        anim = math.floor((0.25 - self.anim)+2)
    end

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)

    -- love.graphics.setColor(0, 255, 0, 100)
    -- love.graphics.rectangle('fill', 0, 0, 32, 16)
    -- love.graphics.rectangle('line', 0, 0, 32, 16)

    love.graphics.setColor(255, 255, 255)
    -- self.spritesheet:draw(anim, 0, 0, -16, 0, 1, 1)
    self.spritesheet:draw(anim, 0, 32, -16, 0, -1, 1)

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
