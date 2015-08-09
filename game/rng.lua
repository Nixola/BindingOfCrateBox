-- dice(0.5) -> true 0.5 of the time, false 0.5 of the time
function dice(chance)
    local r = math.random(1, 1000)
    if r <= chance*1000 then return true else return false end
end

-- table.choose({1, 2, 3}) -> will return 1, 2 or 3
function table.choose(choices)
    return choices[math.random(1, #choices)]
end

-- chooseWithProb({'a', 'b', 'c'}, {0.5, 0.25, 0.25}) -> will choose 'a' with 0.5 prob, 
-- 'b' with 0.25 and 'c' with 0.25. Both tables should have the same amount of values and
-- the chances table should add up to 1. This is NOT checked at all, so wrong usage will
-- produce bugs.
function chooseWithProb(choices, chances)
    local r = math.random(1, 1000)
    local intervals = {}
    -- Creates a table with appropriate intervals: 
    -- chances = {0.5, 0.25, 0.25} -> intervals = {500, 750, 1000}
    for i = 1, #chances do 
        if i > 1 then table.insert(intervals, intervals[i-1]+chances[i]*1000) 
        else table.insert(intervals, chances[i]*1000) end
    end
    -- Figures out which one of the intervals was chosen based on 
    -- the intervals table and the value r.
    -- r = 250, intervals = {500, 750, 1000} should return 1, since r <= intervals[1]
    -- r = 800, intervals = {500, 750, 1000} should return 3, since r >= intervals[2] and r <= intervals[3]
    for i = 1, #intervals do
        if i > 1 then 
            if r >= intervals[i-1] and r <= intervals[i] then return choices[i] end
        else
            if r <= intervals[i] then return choices[i] end
        end
    end
end

-- Randomly chooses a new attack that isn't the one passed in.
function generateNewAttack(attack)
    if attack then
        local ats = table.copy(attacks_list)
        table.removeByValue(ats, attack)
        return ats[math.random(1, #ats)]
    else return table.copy(attacks[math.random(1, #attacks)]) end
end

-- Randomly chooses a new item that isn't the one passed in.
function generateNewItem(item)
    if item then
        local its = table.copy(items_list)
        table.removeByValue(its, item)
        return its[math.random(1, #its)]
    else return table.copy(items[math.random(1, #items)]) end
end

-- Randomly chooses a new passive.
function generateNewPassive()
    return table.copy(passives_list[math.random(1, #passives_list)])
end
