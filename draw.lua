
local camera1_x, camera1_y = 0, 0
local camera2_x, camera2_y = 0, 0

local function drawSingleScreen()

    for i, object in pairs(map.objects) do
        if object.isCamera then
            camera1_x, camera1_y = object:getPosition()
        end
    end


    local bg_ratio = love.graphics.getHeight()/map.background:getHeight()

    local offsetx = love.graphics.getWidth()/2
    local offsety = love.graphics.getHeight()/2

    love.graphics.push()
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(map.background, 0, 0, 0, bg_ratio, bg_ratio)

        love.graphics.translate(math.round(-camera1_x+offsetx), math.round(-camera1_y+offsety))

        map:draw("player1")

        for i, object in pairs(map.objects) do
            object:draw()
        end
        
        player2:draw()
        player:draw()
    love.graphics.pop()

end

local function drawSplitScreen()

    local offsetx = love.graphics.getWidth()/2
    local offsety = love.graphics.getHeight()/2

    local p1x, p1y = player:getPosition()
    local p2x, p2y = player2:getPosition()

    camera1_x, camera1_y = math.lerp(camera1_x, camera1_y, p1x, p1y, 0.15)
    camera2_x, camera2_y = math.lerp(camera2_x, camera2_y, p2x, p2y, 0.15)

    local bg_ratio = love.graphics.getHeight()/map.background:getHeight()

    love.graphics.push()
        love.graphics.setScissor(0, 0, love.graphics.getWidth(), love.graphics.getHeight()/2)

        love.graphics.translate(0, math.round(-love.graphics.getHeight()/4))

        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(map.background, -camera1_x/50, -camera1_y/40, 0, bg_ratio, bg_ratio)

        love.graphics.translate(math.round(-camera1_x+offsetx), math.round(-camera1_y+offsety))

            if not collisionSwapped then
                map:draw("player1")
            else
                map:draw("player2")
            end

            for i, object in pairs(map.objects) do
                if object.zindex == -1 then
                    object:draw()
                end
            end

            for i, object in pairs(map.objects) do
                if (object.zindex == 0 or object.zindex == nil) and object.visible ~= false then
                    if (object.collisiongroup == nil or
                        object.collisiongroup == "shared" or
                        object.collisiongroup == "blue") or
                        (object.visibleonboth == "true") then
                        object:draw()
                    end
                end
            end
            
            player2:draw()
            player:draw()

        love.graphics.setScissor()

    love.graphics.pop()



    love.graphics.push()
        love.graphics.setScissor(0, love.graphics.getHeight()/2, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.translate(0, love.graphics.getHeight()/4)

        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(map.background, -camera2_x/50, -camera2_y/40, 0, bg_ratio, bg_ratio)

        love.graphics.translate(-camera2_x+offsetx, -camera2_y+offsety)

            if not collisionSwapped then
                map:draw("player2")
            else
                map:draw("player1")
            end

            for i, object in pairs(map.objects) do
                if object.zindex == -1 then
                    object:draw()
                end
            end

            for i, object in pairs(map.objects) do
                if (object.zindex == 0 or object.zindex == nil) and object.visible ~= false then
                    if (object.collisiongroup == nil or
                        object.collisiongroup == "shared" or
                        object.collisiongroup == "green") or
                        (object.visibleonboth == "true") then
                        object:draw()
                    end
                end
            end

            player:draw()
            player2:draw()

        love.graphics.setScissor()

    love.graphics.pop()

end

function love.draw()

    if singleCamera then
        drawSingleScreen()
    else
        drawSplitScreen()
    end

    if changeMapTime > 0 then
        love.graphics.setColor(255, 255, 255, (1 - changeMapTime)*255)
        love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end

    if changeMapTimeOut > 0 then
        love.graphics.setColor(255, 255, 255, changeMapTimeOut*255)
        love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end

    -- local w, h = 100, 100

    -- local vertices = {}
    -- for y = 1, h/10 do
    --     table.insert(vertices, 0    + math.random(-2, 2))
    --     table.insert(vertices, y*10 + math.random(-2, 2))
    -- end

    -- --
    -- for x = 1, w/10 do
    --     if (x == w/10) then
    --         table.insert(vertices, (x+1)*10 + math.random(-2, 2))
    --         table.insert(vertices, (h+10)    + math.random(-2, 2))
    --     else
    --         table.insert(vertices, x*10 + math.random(-2, 2))
    --         table.insert(vertices, h    + math.random(-2, 2))
    --     end
    -- end

    -- --
    -- for y = 1, h/10 do
    --     y = h/10 - y
    --     table.insert(vertices, w    + math.random(-2, 2))
    --     table.insert(vertices, y*10 + math.random(-2, 2))
    -- end

    -- for x = 1, w/10 do
    --     x = w/10 - x
    --     table.insert(vertices, x*10 + math.random(-2, 2))
    --     table.insert(vertices, 0    + math.random(-2, 2))
    -- end

    -- love.graphics.setColor(0, 0, 0)
    -- love.graphics.polygon('fill', vertices)

end
