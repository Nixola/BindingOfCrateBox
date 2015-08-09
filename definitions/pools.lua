function APIify(type, t)
    local out = {}
    for _, name in ipairs(t) do
        table.insert(out, {type, name})
    end
    return out
end

function removeTable(t1, t2)
    tbl1 = table.copy(t1)
    tbl2 = table.copy(t2)
    for i = #tbl1, 1, -1 do
        for j = 1, #tbl2 do
            if tbl1[i] == tbl2[j] then
                table.remove(tbl1, i)
            end
        end
    end
    return tbl1
end

function unlockItems()
    local unlock_table = {
        {'map', 'weapon', 'item'},
        {'item', 'item'},
        {'weapon', 'item', 'item'},
        {'map', 'item'},
        {'item', 'item'},
        {'map', 'weapon', 'item'},
        {'map', 'weapon', 'item'},
    }

    local unlocked_map = nil
    local unlocked_weapons = {}
    local unlocked_items = {}

    local run_file = love.filesystem.newFile('run')
    run_file:open('r')
    local n = run_file:read()
    local unlocks_list = unlock_table[n+1]
    love.filesystem.remove('run')
    local new_run = love.filesystem.newFile('run')
    new_run:open('w')
    new_run:write(tostring(n+1))
    if not unlocks_list then return end
    for _, it in ipairs(unlocks_list) do
        if it == 'map' then
            local map_file = love.filesystem.newFile('maps')
            map_file:open('r')
            local maps_string = map_file:read()
            local maps_itr = maps_string:gmatch("[^\r\n]+")
            local i = 1
            locked_maps = {}
            for line in maps_itr do
                if i == 1 then table.insert(maps_list, line); unlocked_map = line
                else table.insert(locked_maps, line) end
                i = i + 1
            end
            love.filesystem.remove('maps')
            local file = love.filesystem.newFile('maps')
            file:open('w')
            for _, map in ipairs(locked_maps) do
                file:write(map .. '\r\n')
            end

        elseif it == 'weapon' then
            local attack_file = love.filesystem.newFile('attacks')
            attack_file:open('r')
            local attacks_string = attack_file:read()
            local attacks_itr = attacks_string:gmatch("[^\r\n]+")
            local i = 1
            locked_attacks = {}
            for line in attacks_itr do
                if i == 1 then table.insert(attack_names, line); table.insert(unlocked_weapons, line)
                else table.insert(locked_attacks, line) end
                i = i + 1
            end
            love.filesystem.remove('attacks')
            local file = love.filesystem.newFile('attacks')
            file:open('w')
            for _, attack in ipairs(locked_attacks) do
                file:write(attack .. '\r\n')
            end

        elseif it == 'item' then
            local item_file = love.filesystem.newFile('passives')
            item_file:open('r')
            local item_string = item_file:read()
            local item_itr = item_string:gmatch("[^\r\n]+")
            local i = 1
            locked_passives = {}
            for line in item_itr do
                if i == 1 then table.insert(passive_names, line); table.insert(unlocked_items, line)
                else table.insert(locked_passives, line) end
                i = i + 1
            end
            love.filesystem.remove('passives')
            local file = love.filesystem.newFile('passives')
            file:open('w')
            for _, passive in ipairs(locked_passives) do
                file:write(passive .. '\r\n')
            end
        end
    end

    if unlocked_map then beholder.trigger('UNLOCK TEXT', 'a new map') end
    local j = 0
    for i, d in ipairs(unlocked_weapons) do 
        main_chrono:after(1*i, function()
            beholder.trigger('UNLOCK TEXT', d) 
        end)
        j = i
    end
    for i, d in ipairs(unlocked_items) do 
        main_chrono:after(1*(j+i), function()
            beholder.trigger('UNLOCK TEXT', d)
        end)
    end
end

function loadPools()
    local e = love.filesystem.exists('run')
    locked_passives = {}
    locked_attacks = {}
    locked_maps = {}
    if e then
        local file = love.filesystem.newFile('attacks')
        file:open('r')
        local attacks = file:read()
        for line in attacks:gmatch("[^\r\n]+") do
            table.insert(locked_attacks, line)
        end

        local file2 = love.filesystem.newFile('passives')
        file2:open('r')
        local passives = file2:read()
        for line in passives:gmatch("[^\r\n]+") do
            table.insert(locked_passives, line)
        end

        local file3 = love.filesystem.newFile('maps')
        file3:open('r')
        local maps = file3:read()
        for line in maps:gmatch("[^\r\n]+") do
            table.insert(locked_maps, line)
        end

    else
        local file = love.filesystem.newFile('attacks')
        locked_attacks = {'Egg Bomb Launcher', 'Bubblebeam', 'Mutant Spider', 'Resonance Cascade'}
        file:open('w')
        for _, attack in ipairs(locked_attacks) do
            file:write(attack .. '\r\n')
        end
                    
        local file2 = love.filesystem.newFile('passives')
        locked_passives = {'Gentle Giant', 'King of Loss', 'Genius, Billionaire, Playboy, Philanthropist',
                           'Book #1', 'Book #2', 'Book #3', 'Book #4', 'Book #5', 'Book #6', 'Book #7'}
        file2:open('w')
        for _, passive in ipairs(locked_passives) do
            file2:write(passive .. '\r\n')
        end

        local file3 = love.filesystem.newFile('run')
        file3:open('w')
        file3:write('0')

        locked_maps = {'scb_green', 'scb_other_red', 'scb_blue', 'scb_red'}
        local file4 = love.filesystem.newFile('maps')
        file4:open('w')
        for _, map in ipairs(locked_maps) do
            file4:write(map .. '\r\n')
        end
    end

    collection_list = {'Razor Leaf', 'Rock Throw', 'Ember', 'Psyburst', 
                       'Egg Bomb Launcher', 'Bubblebeam', 'Mutant Spider', 'Resonance Cascade',
                       'The Scout', 'The Tom Cruise', 'The Michael Bay',
                       'King of Loss', 'Chronomage', 'Thick Skin', 'Gentle Giant',
                       'Fitter, Happier', 'Kiri kiri kiri', 'Ricochet', 'HL3',
                       'ASPD', 'Gun Kata', 'Rare Candy', 'Genius, Billionaire, Playboy, Philanthropist',
                       'Wildfire', "JUMP'NSHOOTMAN", 'Water Automaton', 'Air Automaton', 'Fire Automaton',
                       'Earth Automaton', 'The Pentagram', "Legolas' Bow", "Marle's Pendant", "Ayla's Necklace",
                       'Not Masamune', 'Waterbending = Healing', "Everything's Okay", 'Starshooter',
                       'Grog Soaked Spear', 'Enchanted Crystal Spear', 'Equilibrium Spear',
                       'Impervius', 'Fish', 'Meat', 'Orange', 'Pie', 'Watermelon',
                       "Jack Sparrow's Heart", "Charon's Obol", 'My Reflection', 
                       'Ninja Assassin', 'Love', "DASH'NSHOOTMAN", "Cannon Barrage",
                       "MOV'NSHOOTMAN", 'Rainbow Dash', 'Book #1', 'Book #2', 'Book #3',
                       'Book #4', 'Book #5', 'Book #6', 'Book #7',
                       'Bicurious', 'A Friend', 'A Better Friend', 'Flaria',
                       "Anivia's R", 'The Joker', 'Invis Watch', 'Spider Butt', 'The Salamanca!', "Gangplank's Soul",
                       'Green Potion', 'Blue Potion', 'Pink Potion', 'Orange Potion', 'Red Potion', 'White Potion',
                       'Yellow Potion', 'Double Damage', 'Double Defense', 'Through the Fire and Flames'}
                       
    passive_names = {'Wildfire', 'The Scout', "JUMP'NSHOOTMAN", 'The Tom Cruise', 
                     'The Michael Bay', 'Thick Skin', 'Kiri kiri kiri', 
                     'Ricochet', 'HL3', 'Gun Kata', 'ASPD', 'Fitter, Happier', 'Gentle Giant', 
                     'Water Automaton', 'Air Automaton', 'Earth Automaton', 'Fire Automaton', 
                     'The Pentagram', "Legolas' Bow", "Marle's Pendant", "Ayla's Necklace",
                     'Not Masamune', 'Waterbending = Healing', "Everything's Okay",
                     'Starshooter', 'Grog Soaked Spear', 'Enchanted Crystal Spear', 'Impervius', 
                     'Chronomage', 'Fish', 'Meat', 'Orange', 'Pie', 'Watermelon', 
                     "Jack Sparrow's Heart", "Charon's Obol", 'My Reflection', 'Ninja Assassin', 'Love',
                     'King of Loss', 'Genius, Billionaire, Playboy, Philanthropist',
                     'Book #1', 'Equilibrium Spear', 'Book #2', 'Book #3', 'Rainbow Dash', 'Book #4', 
                     "DASH'NSHOOTMAN", "MOV'NSHOOTMAN", 'Book #4', 'Cannon Barrage', 'Book #5', 'Book #6', 
                     'Rare Candy', 'Book #7'}
    attack_names = {'Rock Throw', 'Razor Leaf', 'Egg Bomb Launcher', 'Bubblebeam', 
                    'Psyburst', 'Ember', 'Resonance Cascade', 'Mutant Spider'}
    item_names = {"Anivia's R", 'The Joker', 'Invis Watch', 'Spider Butt', 'The Salamanca!', "Gangplank's Soul",
                  'Double Damage', 'Double Defense', 'Through the Fire and Flames', 'Green Potion', 'Blue Potion', 'Pink Potion',
                  'Orange Potion', 'Red Potion', 'White Potion', 'Yellow Potion'}
    familiar_names = {'Bicurious', 'A Friend', 'A Better Friend', 'Flaria'}

    attack_names = removeTable(attack_names, locked_attacks)
    passive_names = removeTable(passive_names, locked_passives)

    passives_list = APIify('Passive', passive_names)
    attacks_list = APIify('Attack', attack_names)
    items_list = APIify('Item', item_names)
    familiars_list = APIify('Familiar', familiar_names)

    main_API_list = table.join(table.join(table.join(passives_list, attacks_list), items_list), familiars_list)
    main_market_list = table.join(table.join(passives_list, attacks_list), familiars_list)

    pools = {}
    pools['Tutorial'] = table.copy(attacks_list)
    pools['ChestItem'] = table.copy(items_list)
    pools['ChestAPI'] = main_API_list
    pools['Enemy'] = main_API_list
    pools['Market'] = main_market_list
end

function updatePools(player)
    for _, passive in ipairs(player.passives) do
        for i = #passive_names, 1, -1 do
            if passive == passive_names[i] then
                table.remove(passive_names, i)
            end
        end
    end
    for _, familiar in ipairs(player.familiars) do
        for i = #familiar_names, 1, -1 do
            if familiar == familiar_names[i] then
                table.remove(familiar_names, i)
            end
        end
    end

    attack_names = removeTable(attack_names, locked_attacks)
    passive_names = removeTable(passive_names, locked_passives)

    passives_list = APIify('Passive', passive_names)
    attacks_list = APIify('Attack', attack_names)
    items_list = APIify('Item', item_names)
    familiars_list = APIify('Familiar', familiar_names)
    
    main_API_list = table.join(table.join(table.join(passives_list, attacks_list), items_list), familiars_list)
    main_market_list = table.join(table.join(passives_list, attacks_list), familiars_list)

    pools = {}
    pools['Tutorial'] = table.copy(attacks_list)
    pools['ChestItem'] = table.copy(items_list)
    pools['ChestAPI'] = main_API_list
    pools['Enemy'] = main_API_list
    pools['Market'] = main_market_list
end
