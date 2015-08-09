function loadChance()
    local bomb_mult, chest_mult, heart_mult, money_mult, book_1_mult, book_7_mult = 1, 1, 1, 1, 1, 1 
    if more_chests then chest_mult = more_chests_chance end
    if more_hearts then heart_mult = more_hearts_chance end
    if more_money then money_mult = more_money_chance end
    if more_bombs then bomb_mult = more_bombs_chance end
    if book_1 then book_1_mult = book_1_chance end
    if book_7 then book_7_mult = book_7_chance end
    chances = {}
    chances['Chest'] = function()
        if dice(0.2*(luck)) then return 'Item' end
        if dice(0.1*book_7_mult*(luck)) then return 'API' end
        if dice(0.2*(2-luck)) then return 'Trap' end
        if dice(0.2*(2-luck)) then return 'Chest' end
        local drops = {}
        if dice(0.5*money_mult*(luck)) then table.insert(drops, 'BronzeCoin') end
        if dice(0.6*money_mult*(luck)) then table.insert(drops, 'ManyBronzeCoins') end
        if dice(0.5*heart_mult*book_1_mult*(luck)) then 
            if dice(0.7) then table.insert(drops, 'HalfHeart')
            else dice(0.3) table.insert(drops, 'Heart') end
        end
        if dice(0.5*book_1_mult*(luck)) then
            if dice(0.7) then table.insert(drops, 'HalfMask')
            else dice(0.3) table.insert(drops, 'Mask') end
        end
        if dice(0.1*bomb_mult*(luck)) then table.insert(drops, 'Bomb') end
        return drops 
    end
    chances['Enemy'] = function(hard)
        if hard then
            if dice(0.5*chest_mult*(luck)) then return 'Chest' end
            if dice(0.2*book_7_mult*(luck)) then return 'API' end
            return chooseWithProb({'BronzeCoin', 'HalfHeart', 'Heart', 
                                   'HalfMask', 'Mask', 'ManyBronzeCoins'}, {0.5, 0.1, 0.1, 0.1, 0.1, 0.1})
        else
            if dice(0.3*money_mult*(2-luck)*(1.58333 - difficulty*0.0833333)) then 
                if dice(0.6) then return 'BronzeCoin'
                else return 'ManyBronzeCoins' end
            end
            if dice(0.015*heart_mult*book_1_mult*(2-luck)*(3.22222 - difficulty*0.22222)) then 
                if dice(0.7) then return 'HalfHeart'
                else dice(0.3) return 'Heart' end
            end
            if dice(0.015*book_1_mult*(2-luck)*(3.22222 - difficulty*0.22222)) then
                if dice(0.7) then return 'HalfMask'
                else dice(0.3) return 'Mask' end
            end
            if dice(0.015*chest_mult*(luck)) then return 'Chest' end
            if dice(0.015*bomb_mult*(luck)) then return 'Bomb' end
            if dice(0.01*book_7_mult*(luck)) then return 'API' end
        end
    end
end

function drop(object)
    if instanceOf(Enemy, object) then
        local x, y = object.body:getPosition()
        local s = chances['Enemy'](object.hard)
        if s then
            if s ~= 'API' then
                if s == 'ManyBronzeCoins' then
                    local n = math.random(2, 5)
                    for i = 1, n do
                        beholder.trigger('CREATE RESOURCE' .. current_level_id, 'BronzeCoin', x, y)
                    end
                else beholder.trigger('CREATE RESOURCE' .. current_level_id, s, x, y) end
            else
                local api = pools['Enemy'][math.random(1, #pools['Enemy'])]
                beholder.trigger('CREATE RESOURCE' .. current_level_id, 'API', x, y, api[1], api[2])
            end
        end

    elseif instanceOf(Resource, object) then
        local x, y = object.body:getPosition()
        if object.type == 'Chest' then
            local loot = chances['Chest']()
            if loot == 'Trap' then 
            elseif loot == 'Chest' then
                beholder.trigger('CREATE RESOURCE' .. current_level_id, 'Chest', x, y)
            elseif loot == 'Item' then
                local item = pools['ChestItem'][math.random(1, #pools['ChestItem'])]
                beholder.trigger('CREATE RESOURCE' .. current_level_id, 'API', x, y, item[1], item[2])
            elseif loot == 'API' then
                local api = pools['ChestAPI'][math.random(1, #pools['ChestAPI'])]
                beholder.trigger('CREATE RESOURCE' .. current_level_id, 'API', x, y, api[1], api[2])
            else
                if loot then
                    for _, resource in ipairs(loot) do
                        if resource == 'ManyBronzeCoins' then
                            local n = math.random(2, 5)
                            for i = 1, n do
                                beholder.trigger('CREATE RESOURCE' .. current_level_id, 'BronzeCoin', x, y)
                            end
                        else
                            beholder.trigger('CREATE RESOURCE' .. current_level_id, resource, x, y)
                        end
                    end
                end
            end
        end
    end
end
