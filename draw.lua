
local camera1_x, camera1_y = 0, 0
local camera2_x, camera2_y = 0, 0

function love.draw()

    local offsetx = love.graphics.getWidth()/2
    local offsety = love.graphics.getHeight()/2

    local p1x, p1y = player:getPosition()
    local p2x, p2y = player2:getPosition()

    camera1_x, camera1_y = math.lerp(camera1_x, camera1_y, p1x, p1y, 0.15)
    camera2_x, camera2_y = math.lerp(camera2_x, camera2_y, p2x, p2y, 0.15)

    love.graphics.push()
        love.graphics.translate(0, math.floor(-love.graphics.getHeight()/4))
        love.graphics.translate(math.floor(-camera1_x+offsetx), math.floor(-camera1_y+offsety))

        love.graphics.setScissor(0, 0, love.graphics.getWidth(), love.graphics.getHeight()/2)

            map:draw()
            player:draw()
            player2:draw()

        love.graphics.setScissor()

    love.graphics.pop()



    love.graphics.push()
        love.graphics.translate(0, love.graphics.getHeight()/4)
        love.graphics.translate(-camera2_x+offsetx, -camera2_y+offsety)

        love.graphics.setScissor(0, love.graphics.getHeight()/2, love.graphics.getWidth(), love.graphics.getHeight())

            map:draw()
            player:draw()
            player2:draw()

        love.graphics.setScissor()

    love.graphics.pop()

end
