gravity = 1000
local xSpawnPos = love.graphics.getWidth() / 4
local ySpawnPos = love.graphics.getHeight() / 2
local liveEntities = {}

function newLiveCircle(x, y)
	dx = x - xSpawnPos
	dy = y - ySpawnPos
	print("dx: " .. dx .. " dy: " .. dy)
	local vel = math.sqrt((math.pow(dx, 2)*gravity)/(2*(dx+dy)))
	print(vel)
	if vel == vel then
		local body = love.physics.newBody(world, xSpawnPos, ySpawnPos, 'dynamic')
		local shape = love.physics.newCircleShape(10)
		local density = 1
		local fixture = love.physics.newFixture(body, shape, density)
		body:setLinearVelocity(vel, -vel)
		table.insert(liveEntities, body)
	end
end

function love.mousepressed(x, y, button)
	print("Mouse X: " .. x .. "Mouse Y:" .. y)
	newLiveCircle(x, y)
end

function love.load()
	love.physics.setMeter(32)
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