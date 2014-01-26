
local camera1_x, camera1_y = 0, 0
local camera2_x, camera2_y = 0, 0

function love.draw()

    local offsetx = love.graphics.getWidth()/2
    local offsety = love.graphics.getHeight()/2

    local p1x, p1y = player:getPosition()
    local p2x, p2y = player2:getPosition()

    camera1_x, camera1_y = math.lerp(camera1_x, camera1_y, p1x, p1y, 0.15)
    camera2_x, camera2_y = math.lerp(camera2_x, camera2_y, p2x, p2y, 0.15)

    local bg_ratio = map.background:getHeight() / love.graphics.getHeight()

    love.graphics.push()
        love.graphics.setScissor(0, 0, love.graphics.getWidth(), love.graphics.getHeight()/2)

        love.graphics.translate(0, math.floor(-love.graphics.getHeight()/4))

        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(map.background, -camera1_x/50, -camera1_y/40, 0, bg_ratio, bg_ratio)

        love.graphics.translate(math.floor(-camera1_x+offsetx), math.floor(-camera1_y+offsety))

            map:draw("player1")
            player:draw()
            player2:draw()

            for i, object in pairs(map.objects) do
                if (object.collisiongroup == nil or
                    object.collisiongroup == "shared" or
                    object.collisiongroup == "blue") or
                    (object.visibleonboth) then
                    object:draw()
                end
            end
            
        love.graphics.setScissor()

    love.graphics.pop()



    love.graphics.push()
        love.graphics.setScissor(0, love.graphics.getHeight()/2, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.translate(0, love.graphics.getHeight()/4)

        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(map.background, -camera2_x/50, -camera2_y/40, 0, bg_ratio, bg_ratio)

        love.graphics.translate(-camera2_x+offsetx, -camera2_y+offsety)

            map:draw("player2")
            player:draw()
            player2:draw()

            for i, object in pairs(map.objects) do
                if (object.collisiongroup == nil or
                    object.collisiongroup == "shared" or
                    object.collisiongroup == "green") or
                    (object.visibleonboth) then
                    object:draw()
                end
            end

        love.graphics.setScissor()

    love.graphics.pop()

end
