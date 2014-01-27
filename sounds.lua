
local soundLibrary = {}

function cacheSound(name)
    soundLibrary[name] = soundLibrary[name] or love.audio.newSource("assets/sounds/" .. name)
end

function playSound(name, volume)
    soundLibrary[name] = soundLibrary[name] or love.audio.newSource("assets/sounds/" .. name)
    soundLibrary[name]:setVolume(volume or 1)
    soundLibrary[name]:play()
end


local musicLibrary = {}


function cacheMusic(name)
    musicLibrary[name] = musicLibrary[name] or love.audio.newSource("assets/music/" .. name)
end

function playMusic(name, volume)
    musicLibrary[name] = musicLibrary[name] or love.audio.newSource("assets/music/" .. name)
    musicLibrary[name]:setVolume(volume)
    musicLibrary[name]:play()
end
