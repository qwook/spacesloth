
local soundLibrary = {}

function playSound(name)
    soundLibrary[name] = soundLibrary[name] or love.audio.newSource("assets/music/" .. name)

    
end
