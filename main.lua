
class = require("middleclass")

Sloth = class('Sloth')

function Sloth:initialize()
    self.image = love.graphics.newImage("sloth.jpg")
end

function Sloth:draw()
    love.graphics.draw(self.image, 10, 10)
end

----------------------------------------------------

local sloth = Sloth:new()

function love.load()
end

function love.update(dt)
end

function love.draw()
    sloth:draw()
end

function love.update()
end
