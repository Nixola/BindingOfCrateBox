function loadStats()
    statsToValuesTable = {}
    statsToValuesTable['speed'] = {150, 175, 200, 225, 275, 325, 350, 400} 
    statsToValuesTable['explosion_size'] = {0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2}
    statsToValuesTable['damage'] = {0.5, 0.75, 1, 1.1, 1.2, 1.3, 1.4, 1.5}
    statsToValuesTable['cooldown'] = {2, 1.5, 1.25, 1, 0.9, 0.8, 0.7, 0.6}
end

function statsToValues(stats)
    local values = {}
    for stat, value in pairs(stats) do
        if stat ~= 'hp_limit' and stat ~= 'max_hp' and stat ~= 'hp' and 
           stat ~= 'mask' and stat ~= 'pierce' and stat ~= 'reflect' then
            if value >= 1 and value <= 8 then
                values[stat] = statsToValuesTable[stat][value]
            elseif value > 8 then
                values[stat] = statsToValuesTable[stat][8]
            else
                values[stat] = statsToValuesTable[stat][1]
            end
        end
    end
    return values
end
