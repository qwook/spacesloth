
function love.draw()

    local offsetx = love.graphics.getWidth()/2
    local offsety = love.graphics.getHeight()/2

    local p1x, p1y = player:getPosition()
    local p2x, p2y = player2:getPosition()

    love.graphics.push()
        love.graphics.translate(0, -love.graphics.getHeight()/4)
        love.graphics.translate(-p1x+offsetx, -p1y+offsety)

        love.graphics.setScissor(0, 0, love.graphics.getWidth(), love.graphics.getHeight()/2)

            map:draw()
            player:draw()
            player2:draw()

        love.graphics.setScissor()

    love.graphics.pop()



    love.graphics.push()
        love.graphics.translate(0, love.graphics.getHeight()/4)
        love.graphics.translate(-p2x+offsetx, -p2y+offsety)

        love.graphics.setScissor(0, love.graphics.getHeight()/2, love.graphics.getWidth(), love.graphics.getHeight())

            map:draw()
            player:draw()
            player2:draw()

        love.graphics.setScissor()

    love.graphics.pop()

end
