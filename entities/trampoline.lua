
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

function Trampoline:postSpawn()
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
    return x-32, y
end

function Trampoline:setPosition(x, y)
    PhysBox.setPosition(self, x+32, y)
end

function Trampoline:touchedPlayer(player)

    -- we'll touch this later:
    -- local vel = 1200 -- Higher vel gives higher apex and more range. Lower clears low ceilings.

    -- stop the player in his tracks
    player:setVelocity(0, 0)

    -- start the animation
    self.anim = 1

    -- wait 0.12 seconds, then shoot the player
    -- using a javascript style timer :V
    setTimeout(function()
        -- no goal set
        if not self:getProperty("goal") then return end

        -- find the goal object
        local goals = map:findObjectsByName(self:getProperty("goal"))
        local goal
        if goals[1] == nil then
            return
        else
            goal = goals[1]
        end

        local xPlayerPos, yPlayerPos = player:getPosition()
        local xGoalPos, yGoalPos = goal:getPosition()

        local flipped = false
        if (xGoalPos < xPlayerPos) then
            flipped = true
            xGoalPos = 2*xPlayerPos - xGoalPos
            xGoalPos = (xGoalPos - xPlayerPos)
        end

        xGoalPos = xGoalPos + 32 -- slight adjustment

        local dx = xGoalPos - xPlayerPos
        local dy = yPlayerPos - yGoalPos -- Account for funky coordinate systems.
        local theta, vx, vy -- vx and vy are the x and y components of the projectile velocity.

        -- Root is [÷/-]1. Sometimes two parabolas are possible, root selects which one is to be used.
        -- root = -1 will launch the projectile such that it hits the target before the apex, if possible.
        local root = 1
        -- The discriminant determines if the shot is even possible.

        local vel = self:getProperty("power") or 0
        local discriminant = math.pow(vel, 4) - GRAVITY*(GRAVITY*dx*dx + 2*dy*vel*vel)
        
        -- if the lame map editor didn't set a velocity, 
        -- calculate a velocity that will give a good discriminant
        if discriminant <= 0 then
                vel = math.sqrt(math.sqrt(math.pow((GRAVITY*2*dy), 2) + 4*(1 + GRAVITY*(GRAVITY*dx*dx))) + (GRAVITY*2*dy)) / math.sqrt(2)
                discriminant = math.pow(vel, 4) - GRAVITY*(GRAVITY*dx*dx + 2*dy*vel*vel)
        end
        
        if discriminant > 0 then
            -- Find the angle of launch.
            theta = math.atan((vel*vel + root*math.sqrt(discriminant))/(GRAVITY*dx))
            -- Divide the velocity into x and y components.
            vx = vel*math.cos(theta)
            vy = vel*math.sin(theta)
            -- print("theta: " .. math.deg(theta) .. " vx: ".. vx .. " vy: " .. vy)
        
            -- Sanity check to avoid feeding a nil value into the physics engine.
            if vx == vx and vy == vy then
                player:setVelocity(vx, -vy)
                player:stopJump()
                playSound("thwap.wav")
            end
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

    love.graphics.setColor(255, 255, 255)
    -- self.spritesheet:draw(anim, 0, 16, -16, 0, 1, 1)
    self.spritesheet:draw(anim, 0, 32+16, -16, 0, -1, 1)

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
