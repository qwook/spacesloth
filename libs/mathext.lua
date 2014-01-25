
function math.dotproduct(x1, y1, z1, x2, y2, z2)
    return x1*x2 + y1*y2 + z1*z2
end

function math.crossproduct(x1, y1, z1, x2, y2, z2)
    return y1*z2 - y2*z1, z1*x2 - z2*x1, x1*y2 - x2*y1
end

function math.length(x, y)
    return math.sqrt(x*x + y*y)
end

function math.distance(x1, y1, x2, y2)
    return math.length(x1 - x2, y1 - y2)
end

function math.normal(x, y)
    local len = math.length(x, y)
    return x / len, y / len
end

function math.clamp(input, min, max)
    if (min > max) then
        local _ = min
        min = max
        max = _
    end

    if (input < min) then return min end
    if (input > max) then return max end

    return input
end

function math.sign(n)
    if (n > 0) then return 1 end
    if (n < 0) then return -1 end
    return 0
end

function math.approach(start, _end, inc)
    return math.clamp(start + inc, start, _end)
end

function math.approach2(start, _end, inc)
    local dir = math.sign(_end - start)
    return math.clamp(start + (dir * inc), start, _end)
end
