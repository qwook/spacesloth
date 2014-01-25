
function table.hasvalue(tbl, val)
    for _, v in pairs(tbl) do
        if val == v then return true end
    end
    return false
end

function table.removevalue(tbl, val)
    while table.hasvalue(tbl, val) do
        for i, v in pairs(tbl) do
            if val == v then table.remove(tbl, i) break end
        end
    end
end
