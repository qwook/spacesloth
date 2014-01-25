
bit = require("bit")

Input = class("Input")

IN_KEYS = {
    ["attack"] =    bit.lshift(1, 1);
    ["jump"] =      bit.lshift(1, 2);
    ["left"] =      bit.lshift(1, 3);
    ["right"] =     bit.lshift(1, 4);
    ["crouch"] =    bit.lshift(1, 5);
}

function Input:initialize()
    self.binds = {}
    self.keyCodes = 0
    self._keyCodes = 0
    self.lastKeyCodes = 0
end

-- usage: input:isKeyDown("attack") == true
function Input:isKeyDown(in_key)
    local key_enum = IN_KEYS[in_key]
    if key_enum == nil then return end
    return bit.band(self.keyCodes, key_enum) ~= 0
end

-- Only true for the first frame key is down. Use for jumping, etc.
function Input:wasKeyPressed(in_key)
    local key_enum = IN_KEYS[in_key]
    if key_enum == nil then return end

    return  (bit.band(self._keyCodes, key_enum) ~= 0) and
            (bit.band(self.lastKeyCodes, key_enum) == 0)
end

function Input:update()
    self.lastKeyCodes = self._keyCodes
    self._keyCodes = self.keyCodes
end

function Input:keyPress(in_key)
    if IN_KEYS[in_key] == nil then return end
    local key_enum = IN_KEYS[in_key]

    if bit.band(self.keyCodes, key_enum) == 0 then
        self.keyCodes = self.keyCodes + key_enum
    end
end

function Input:keyRelease(in_key)
    if IN_KEYS[in_key] == nil then return end
    local key_enum = IN_KEYS[in_key]

    if bit.band(self.keyCodes, key_enum) ~= 0 then
        self.lastKeyCodes = self.keyCodes
        self.keyCodes = self.keyCodes - key_enum
    end
end

function Input:eventKeyPressed(key)
    local in_key = self.binds[key]

    -- this isn't bound to anything valid. exit
    if in_key == nil then return end

    self:keyPress(in_key)
end

function Input:eventKeyReleased(key)
    local in_key = self.binds[key]

    -- this isn't bound to anything valid. exit
    if in_key == nil then return end

    self:keyRelease(in_key)
end

function Input:eventJoyPressed(key)
    local in_key = self.binds["joy_" .. key]

    if in_key == nil then return end

    self:keyPress(in_key)
end

function Input:eventJoyReleased(key)
    local in_key = self.binds["joy_" .. key]

    if in_key == nil then return end

    self:keyRelease(in_key)
end

function Input:bind(key, in_key)
    self.binds[key] = in_key
end

return Input
