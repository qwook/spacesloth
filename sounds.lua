
local soundLibrary = {}

function cacheSound(name)
    soundLibrary[name] = soundLibrary[name] or love.audio.newSource("assets/sounds/" .. name)
end

function playSound(name)
    soundLibrary[name] = soundLibrary[name] or love.audio.newSource("assets/sounds/" .. name)
    soundLibrary[name]:play()
end
