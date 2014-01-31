
DEACCELERATION_SPEED = 600 -- how much you're able to deaccelerate after jumping
IMPULSE_AFTER_JUMPING = 7.5 -- how much you're able to "nudge" after jumping
PLAYER_FRICTION = 0.75 -- friction
PLAYER_FRICTION_SLIDING = 0.01 -- friction while sliding

MOVING_ACCELERATION = 20 -- how much it should accelerate
MOVING_SPEED = 200 -- constant moving speed on ground

Physical =      require("entities.core.physical")
SpriteSheet =   require("util.spritesheet")
Particle =      require("entities.core.particle")
WalkingDust =   require("entities.particles.walkingdust")

Player = class('Player', Physical)

function Player:initialize()
    self.name = "Stewart"
    self.type = "PLAYER"
    self.collisiongroup = "blue"

    self.spritesheet = SpriteSheet:new("sprites/players.png", 32, 32)
    self.expression = 0
   
    self.isother = false

    self:initPhysics()
end

function Player:event_multiplyVelocity(x, y)
    local vx, vy = self.body:getLinearVelocity()
    self.body:setLinearVelocity(vx * tonumber(x), vy * tonumber(y))
    self.body:setAwake(true)
end

function Player:event_addVelocity(x, y)
    local vx, vy = self.body:getLinearVelocity()
    self.body:setLinearVelocity(vx + tonumber(x), vy + tonumber(y))
    self.body:setAwake(true)
end

function Player:event_setVelocity(x, y)
    self.body:setLinearVelocity(tonumber(x), tonumber(y))
    self.body:setAwake(true)
end

function Player:event_setFriction(frict)
    self.body:setFriction(frict)
    self.body:setAwake(true)
end

function Player:event_applyImpulse(x, y)
    self.body:applyLinearImpulse(x, y)
    self.body:setAwake(true)
end

function Player:event_teleportTo(name)

    for k,v in pairs(map.objects) do
        if v.name == name then
            -- print(v:getPosition())
            self:setPosition(v:getPosition())
            -- self:setPosition(self:getPosition())
            return
        end
    end
end

function Player:call(name, args)
    if self["event_" .. name] then
        self["event_" .. name](self, unpack(args))
    end
end

function Player:setController(input)
    self.controller = input
end

function Player:initPhysics()
    self.body = love.physics.newBody(world, 0, 0, 'dynamic')
    -- self.shape = love.physics.newRectangleShape(32, 28)
    -- self.shape = love.physics.newCircleShape(14)
    self.shape = love.physics.newPolygonShape(-14, -14, -14, 0, 14*math.cos(math.pi*(3/4)), 14*math.sin(math.pi*(3/4)), 0, 14, 14*math.cos(math.pi/4), 14*math.sin(math.pi/4), 14, 0, 14, -14)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.fixture:setUserData(self)
    self.fixture:setFriction(PLAYER_FRICTION)
    self.body:setMass(20)
    self.body:setFixedRotation(true)

    self.contacts = {}

    self.floorangle = 0
    self.floornx = 0
    self.floorny = 0

    self.nextJump = 0

    self.facing = 'right'
    self.moving = false
    self.crouching = false

    self.nextDust = 0
end

function Player:isOnFloor()
    local x, y = self:getPosition()
    y = y + 6

    for k, contact in pairs(self.contacts) do
        local x1, y1, x2, y2 = contact:getPositions()
        if ((y1 or y-1) > y and (y2 or y+1) > y) then
            self.floornx, self.floorny = contact:getNormal()
            return true
        end
    end

    return false
end

function Player:update(dt)

    -- handle animation --

    if self.controller:wasKeyPressed("left") then
        self.facing = 'left'
    elseif self.controller:wasKeyPressed("right")  then
        self.facing = 'right'
    end

    if self.controller:isKeyDown("crouch") then
        self.crouching = true
    else
        self.crouching = false
    end

    if self.nextDust > 0 then
        self.nextDust = self.nextDust - dt
    end

    self.expression = 0
    if (self.controller:isKeyDown(":|")) then self.expression = self.expression + 1 end
    if (self.controller:isKeyDown(":/")) then self.expression = self.expression + 2 end

    -- handle physics --

    local velx, vely = self.body:getLinearVelocity()

    if math.length(velx, vely) > 0.1 then
        self.moving = true
    else
        self.moving = false
    end

    -- true = up, false = down, nil = going straight
    local goingUpOrDown = nil
    local ypoop = self.floornx

    if self.crouching then
        self.fixture:setFriction(PLAYER_FRICTION_SLIDING)
    else
        self.fixture:setFriction(PLAYER_FRICTION)
    end

    if self:isOnFloor() then

        if self.nextJump > 0 then
            self.nextJump = self.nextJump - dt
        end

        local jumping = false

        if self.controller:isKeyDown("jump") and self.nextJump <= 0 then
            self.body:setLinearVelocity(velx/10, vely/5)
            self.body:applyLinearImpulse(0, -400)
            self.nextJump = 0.1
            goingUpOrDown = nil

            playSound("bwop.wav")
            jumping = true

            local smoke = Particle:new()
            smoke:setPosition(self:getPosition())
        end

        if self.controller:isKeyDown("left") and not jumping then
            if math.abs(velx) < 100 then
                self.body:applyLinearImpulse(-MOVING_ACCELERATION, 0)
            else
                self.body:setLinearVelocity(-MOVING_SPEED, vely)
            end

            -- this is for climbing stairs
            if self.floorangle > -math.pi*(4/5) and self.floorangle < -math.pi/2-0.15  then
                goingUpOrDown = false
            end
            if self.floorangle < math.pi*(4/5) and self.floorangle > -math.pi/2+0.15 then
                goingUpOrDown = true
                ypoop = -ypoop
            end
        end

        if self.controller:isKeyDown("right") and not jumping then
            if math.abs(velx) < 100 then
                self.body:applyLinearImpulse(MOVING_ACCELERATION, 0)
            else
                self.body:setLinearVelocity(MOVING_SPEED, vely)
            end

            -- this is for climbing stairs
            if self.floorangle > -math.pi*(4/5) and self.floorangle < -math.pi/2-0.15  then
                goingUpOrDown = true
            end
            if self.floorangle < math.pi*(4/5) and self.floorangle > -math.pi/2+0.15 then
                goingUpOrDown = false
                ypoop = -ypoop
            end
        end

        -- so for climbing stairs, we actually push the player up a bit
        -- when they're going up stairs, and push them down when they're going
        -- down stairs.
        if self.nextJump <= 0 then
            local velx, vely = self.body:getLinearVelocity()
            -- up
            if goingUpOrDown == true then
                -- self.body:applyLinearImpulse(0, -50)
                self.body:setLinearVelocity(velx, 200 * ypoop)
            -- down
            elseif goingUpOrDown == false then
                -- self.body:applyLinearImpulse(0, 10)
                self.body:setLinearVelocity(velx, 200 * -ypoop)
            end
            goingUpOrDown = nil
        end

    -- not on floor, we're in the air
    else
        if self.controller:isKeyDown("left") then
            if velx >= 0 then
                self.body:setLinearVelocity(velx - DEACCELERATION_SPEED*dt, vely)
            elseif math.abs(velx) < 250 then
                self.body:applyLinearImpulse(-IMPULSE_AFTER_JUMPING, 0)
            end
        end

        if self.controller:isKeyDown("right") then
            if velx <= 0 then
                self.body:setLinearVelocity(velx + DEACCELERATION_SPEED*dt, vely)
            elseif math.abs(velx) < 250 then
                self.body:applyLinearImpulse(IMPULSE_AFTER_JUMPING, 0)
            end
        end
    end

end

function Player:draw()
    local x, y = self:getPosition()
    local r = self:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)

    -- love.graphics.setColor(0, 255, 0)
    -- love.graphics.rectangle('fill', -16, -16, 32, 32)

    if self.facing == 'right' then
        love.graphics.scale(1, 1)
    else
        love.graphics.scale(-1, 1)
    end

    love.graphics.setColor(255, 255, 255)

    self:drawPlayer()

    love.graphics.pop()
end

function Player:drawPlayer()
    local anim = 0
    if self.moving then
        anim = math.floor(love.timer.getTime()*10) % 4
    end

    local offset = 0
    if self.crouching then
        anim = 2
        offset = 6
    end


    self.spritesheet:draw(anim, 1, -16, -18 + offset)
    self.spritesheet:draw(self.expression, 0, -16, -18 + offset)
end

function Player:getPosition()
    return self.body:getPosition()
end

function Player:setPosition(x, y)
    self.body:setPosition(x, y)
end

function Player:getAngle()
    return self.body:getAngle()
end

function Player:setAngle(r)
    self.body:setAngle(r)
end

-- the player hit something
function Player:beginContact(other, contact, isother)
    self.isother = isother

    local x, y = self:getPosition()
    local normx, normy = contact:getNormal()

    y = y + 6

    if isother == false then
        normx = -normx
        normy = -normy
    end

    table.insert(self.contacts, contact)

    -- detect a floor
    local x1, y1, x2, y2 = contact:getPositions()

    local id, id2 = contact:getChildren()
    if isother then id = id2 end -- `isother` means we are the second object

    if ((y1 or y-1) > y and (y2 or y+1) > y) then -- and ((math.acos(dot) <= math.pi / 4 + 0.1) or (math.acos(dot) >= math.pi * (3 / 4) - 0.1)) then        
        self.floorangle = math.atan2(normy, normx)
        self.floornx = normx
        self.floorny = normy
    else
        -- if it isn't a floor, set the friction to 0
        -- we want to slide down walls, not cling onto them
        --contact:setFriction(0)
    end
 
        if other.type == "PLAYER" then
            contact:setFriction(1.5)
        end

end

function Player:endContact(other, contact, isother)
    local normx, normy = contact:getNormal()
    local cx, cy, cz = math.crossproduct(normx, normy, 0, 0, 1, 0)

    table.removevalue(self.contacts, contact)

    local x, y = self:getPosition()
    local x1, y1, x2, y2 = contact:getPositions()

    local id, id2 = contact:getChildren()
    if isother then id = id2 end -- `isother` means we are the second object

end

function Player:postSolve(other, contact, nx, ny, isother)
    if self.moving and self.nextDust <= 0 and self:isOnFloor() then
        local smoke = WalkingDust:new()
        local x, y = self:getPosition()
        local vx, vy = 0, -50

        if self.facing == "left" then
            vx = 25
        else
            vx = -25
        end

        smoke:setPosition(x+vx*0.70, y + 16)
        smoke:setVelocity(vx, vy)
        smoke:setScale(math.length(self.body:getLinearVelocity())/200)
        self.nextDust = 0.15
    end
end


-- Cindy is player 2.
Cindy = class("Cindy", Player)

function Cindy:initialize()
    Player.initialize(self)

    self.collisiongroup = "green"
    self.name = "Cindy"
end

function Cindy:drawPlayer()
    local anim = 0
    if self.moving then
        anim = math.floor(love.timer.getTime()*10) % 4
    end

    local offset = 0
    if self.crouching then
        anim = 2
        offset = 6
    end


    self.spritesheet:draw(anim, 3, -16, -18 + offset)
    self.spritesheet:draw(self.expression, 2, -16, -18 + offset)

end


return Player