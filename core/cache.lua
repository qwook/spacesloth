------------------------
-- Cache and load images

local imageLibrary = {}

function cacheImage(name)
    imageLibrary[name] = imageLibrary[name] or love.graphics.newImage("assets/" .. name)
end

function loadImage(name, volume)
    imageLibrary[name] = imageLibrary[name] or love.graphics.newImage("assets/" .. name)
    return imageLibrary[name]
end
