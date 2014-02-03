local gravity = 300
local xSpawnPos = love.graphics.getWidth() / 4
local ySpawnPos = love.graphics.getHeight() / 2
local liveEntities = {}
local vel = 400 -- Higher vel gives higher apex and more range. Lower clears low ceilings.

function newLiveCircle(x, y)
	local dx = x - xSpawnPos
	local dy = ySpawnPos - y -- Account for funky coordinate systems.
	local theta, vx, vy -- vx and vy are the x and y components of the projectile velocity.

	-- Root is [÷/-]1. Sometimes two parabolas are possible, root selects which one is to be used.
	-- root = -1 will launch the projectile such that it hits the target before the apex, if possible.
	local root = 1
	-- The discriminant determines if the shot is even possible.
	local discriminant = math.pow(vel, 4) - gravity*(gravity*dx*dx + 2*dy*vel*vel)
	if discriminant > 0 then
		-- Find the angle of launch.
		theta = math.atan((vel*vel + root*math.sqrt(discriminant))/(gravity*dx))
		-- Divide the velocity into x and y components.
		vx = vel*math.cos(theta)
		vy = vel*math.sin(theta)
		print("theta: " .. math.deg(theta) .. " vx: ".. vx .. " vy: " .. vy)
	
		-- Sanity check to avoid feeding a nil value into the physics engine.
		if vx == vx and vy == vy then
			-- Actually create and fire the projectile.
			print("FIRING!")
			local body = love.physics.newBody(world, xSpawnPos, ySpawnPos, 'dynamic')
			local shape = love.physics.newCircleShape(10)
			local density = 1
			local fixture = love.physics.newFixture(body, shape, density)
			body:setLinearVelocity(vx, -vy)
			table.insert(liveEntities, body)
		end
	end
end

function love.mousepressed(x, y, button)
	print("Mouse X: " .. x .. " Mouse Y:" .. y)
	newLiveCircle(x, y)
end

function love.load()
	world = love.physics.newWorld()
	world:setGravity(0, gravity)
end

function love.draw()
	for i,body in pairs(liveEntities) do
		local x, y = body:getPosition()
		love.graphics.circle("fill", x, y, 10, 36)
	end
end

function love.update(dt)
	world:update(dt)
end