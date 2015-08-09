function loadAttacks()
    instant = struct('damage', 'cooldown')
    dot = struct('interval', 'times', 'damage')
    slow = struct('percentage', 'duration')

    local INF = 10000

    local attack = struct('name', 'activation', 'activation_delay', 'cooldown', 'recoil',
                          'c_chance', 'c_intensity', 'c_duration', 
                          'p_effect', 'p_follow', 'p_interval',
                          'attack_p_color', 'control',
                          'area_logic_type', 'area_logic_subtype', 'area_modifiers', 
                          'movement_type', 'movement_subtype', 'projectile_modifiers',
                          'line_logic_type', 'line_logic_subtype', 'line_modifiers',
                          'desc_text', 'other_text')
    attacks = {}

    attacks['Mutant Spider'] = attack(
        'Mutant Spider', 'down', nil, 1, nil,
        nil, nil, nil,
        nil, nil, nil,
        YELLOW_PS, nil,
        nil, nil, nil,
        'normal', 'default', {name = 'Mutant Spider', instant = instant(0.5, 0.5)})

    attacks['Resonance Cascade'] = attack(
        'Resonance Cascade', 'down', nil, 1, nil,
        nil, nil, nil,
        nil, nil, nil,
        YELLOW_PS, nil,
        nil, nil, nil,
        'normal', 'default', {name = 'Resonance Cascade', instant = instant(0.5, 0.5), fork = 'up'})

    attacks['Bicurious'] = attack(
        'Bicurious', 'down', nil, 0.3, nil,
        nil, nil, nil,
        nil, nil, nil,
        YELLOW_PS, nil,
        nil, nil, nil,
        'normal', 'default', {name = 'Bicurious', instant = instant(0.25, 0.5)})

    attacks['A Friend'] = attack(
        'A Friend', 'down', nil, 0.4, nil,
        nil, nil, nil,
        nil, nil, nil,
        YELLOW_PS, nil,
        nil, nil, nil,
        'normal', 'default', {instant = instant(0.25, 0.5)})

    attacks['A Better Friend'] = attack(
        'A Better Friend', 'down', nil, 0.2, nil,
        nil, nil, nil,
        nil, nil, nil,
        ENEMY_RED_PS, nil,
        nil, nil, nil,
        'normal', 'default', {instant = instant(0.25, 0.5)})

    attacks['Bubblebeam'] = attack(
        'Bubblebeam', 'down', nil, 1, nil,
        nil, nil, nil,
        nil, nil, nil,
        BLUE_PS, nil,
        nil, nil, nil,
        'decelerating', 'default', {name = 'Bubblebeam', instant = instant(0.175, 0.5), gravity = -0.5})


    attacks['Rock Throw'] = attack(
        'Rock Throw', 'down', nil, 0.2, nil,
        nil, nil, nil,
        nil, nil, nil,
        ROCK_PS, nil,
        nil, nil, nil, 
        'normal', 'medium', {name = 'Rock Throw', instant = instant(0.5, 0.5), gravity = 2})

    attacks['Dual'] = attack(
        'Dual', 'press', nil, 0.1, nil,
        nil, nil, nil,
        nil, nil, nil,
        YELLOW_PS, nil,
        nil, nil, nil,
        'normal', 'default', {instant = instant(0.5, 0.5), back = true})

    attacks['Razor Leaf'] = attack(
        'Razor Leaf', 'down', nil, 0.15, 50,
        nil, nil, nil, 
        nil, nil, nil,
        YELLOW_PS, nil,
        nil, nil, nil,
        'normal', 'default', {name = 'Razor Leaf', instant = instant(0.25, 0.5), gravity = -0.5})

    attacks['Magnum'] = attack(
        'Magnum', 'press', nil, 0.2, 200,
        nil, nil, nil,
        nil, nil, nil,
        YELLOW_PS, nil,
        nil, nil, nil,
        'normal', 'fast', {width = 12, height = 12, instant = instant(2, 0.5)})

    attacks['Rocket Launcher'] = attack(
        'Rocket Launcher', 'press', nil, 0.92, nil,
        nil, nil, nil,
        'Rocket Launcher', nil, 0.025,
        YELLOW_PS, nil,
        'exploding', 'default', {instant = instant(5, 0.5)},
        'accelerating', 'default', {width = 12, height = 12, instant = instant(5, 0.5)})

    attacks["Anivia's R"] = attack(
        "Anivia's R", 'press', nil, 2, nil,
        nil, nil, nil,
        "Anivia's R", true, 0,
        BLIZZARD_WHITE, nil,
        'huge', 'blizzard', {name = "Anivia's R", slow = slow(0.25, 0.5), instant = instant(0.1, 0.5)},
        'decelerating', 'blizzard', {name = "Anivia's R", pierce = INF})

    attacks['The Direct Hit'] = attack(
        'The Direct Hit', 'press', nil, 0.92, nil,
        nil, nil, nil,
        'Rocket Launcher', nil, 0.025,
        YELLOW_PS, nil,
        'exploding', 'small', {instant = instant(5, 0.5)},
        'accelerating', 'fast', {width = 12, height = 12, instant = instant(5, 0.5)})

    attacks['Ember'] = attack(
        'Ember', 'down', nil, 0.5, nil,
        nil, nil, nil,
        'Ember', nil, 0.05,
        FLARE_RED_PS, nil,
        nil, nil, nil,
        'normal', 'fast', {name = 'Ember', width = 12, dot = dot(0.5, 20, 0.1), gravity = 1, instant = instant(0.1, 0.5)})

    attacks['Flamethrower'] = attack(
        'Flamethrower', 'down', nil, 0.1, nil,
        nil, nil, nil,
        'Flamethrower', true, 0.01,
        FLARE_RED_PS, nil,
        'small', 'flame', {name = 'Flamethrower', dot = dot(0.2, 25, 0.1)},
        'normal', 'slow', {name = 'Flamethrower', width = 12, height = 12,  dot = dot(0.2, 25, 0.1), gravity = 2})

    attacks['Sludge Bomb'] = attack(
        'Sludge Bomb', 'press', nil, 1.4, nil,
        nil, nil, nil,
        'Sludge Bomb', nil, 0.05,
        IPECAC_PS, nil,
        'exploding', 'default', {name = 'Sludge Bomb', instant = instant(2, 1), dot = dot(0.5, 4, 0.25)},
        'normal', 'IPECAC', {name = 'Sludge Bomb', instant = instant(1, 1), width = 16, height = 16, gravity = 2})

    attacks['Psyburst'] = attack(
        'Psyburst', 'down', nil, 0.6, 150,
        nil, nil, nil,
        nil, nil, nil,
        YELLOW_PS, nil,
        nil, nil, nil,
        'decelerating', 'psyburst', {name = 'Psyburst', randomize_v = true, instant = instant(0.2, 0.5)})

    attacks['Minigun'] = attack(
        'Minigun', 'down', 0.44, 0.015, 150,
        1, 1, 0.2,
        nil, nil, nil,
        YELLOW_PS, nil,
        nil, nil, nil,
        'normal', 'default', {name = 'Minigun', instant = instant(0.1, 0.5)})

    attacks['Natascha'] = attack(
        'Natascha', 'down', 0.88, 0.015, 150,
        1, 1, 0.2,
        nil, nil, nil,
        YELLOW_PS, nil,
        nil, nil, nil,
        'normal', 'default', {name = 'Natascha', instant = instant(0.05, 0.5), slow = slow(0.5, 1)})

    attacks['Egg Bomb Launcher'] = attack(
        'Egg Bomb Launcher', 'down', nil, 0.9, nil,
        nil, nil, nil,
        nil, nil, nil,
        YELLOW_PS, nil,
        'exploding', 'grenade', {name = 'Egg Bomb Launcher', instant = instant(1.25, 0.5)},
        'normal', 'default', {name = 'Egg Bomb Launcher', width = 8, height = 8, gravity = 4, reflecting = INF, duration = 2.5}) 

    attacks['Stickybomb Launcher'] = attack(
        'Stickybomb Launcher', 'down', nil, 0.6, nil,
        nil, nil, nil,
        nil, nil, nil,
        YELLOW_PS, nil,
        'exploding', 'stickybomb', {name = 'Stickybomb Launcher', instant = instant(5, 0.5)},
        'normal', 'default', {name = 'Stickybomb Launcher', width = 12, height = 12, gravity = 3, pierce = INF})

    attacks["The Beggar's Bazooka"] = attack(
        "The Beggar's Bazooka", 'down', INF, 0.24, nil,
        nil, nil, nil,
        'Rocket Launcher', nil, 0.025,
        YELLOW_PS, 0,
        'exploding', 'default', {instant = instant(5, 0.5)},
        'accelerating', 'medium', {width = 12, height = 12, instant = instant(5, 0.5)})

    attacks['Brimstone'] = attack(
        'Brimstone', 'down', INF, 1, nil,
        nil, nil, nil,
        nil, nil, nil,
        ENEMY_RED_PS, 1,
        nil, nil, nil,
        nil, nil, nil,
        'normal', 'brimstone', {name = 'Brimstone', instant = instant(5, 0.5), pierce = INF})

    attacks['Technology 2'] = attack(
        'Technology 2', 'down', nil, 0.075, nil,
        nil, nil, nil,
        nil, nil, nil,
        ENEMY_RED_PS, nil,
        nil, nil, nil,
        nil, nil, nil,
        'normal', 'technology 2', {name = 'Technology 2', instant = instant(0.05, 0.1), pierce = INF})

    attacks['Technology'] = attack(
        'Technology', 'down', nil, 0.3, nil,
        nil, nil, nil,
        nil, nil, nil,
        ENEMY_RED_PS, nil,
        nil, nil, nil,
        nil, nil, nil,
        'normal', 'technology', {name = 'Technology', instant = instant(0.25, 0.1), pierce = INF})

    attacks['green9090'] = attack(
        'green9090', 'down', nil, 0.4, nil,
        nil, nil, nil,
        nil, nil, nil,
        GREEN_PS, nil,
        nil, nil, nil,
        nil, nil, nil,
        'normal', 'technology', {name = 'green9090', instant = instant(0.5, 0.1), pierce = INF})

    local yellow_color = {color = LIGHT_YELLOW, hit_color = YELLOW_PS}
    local blizzard_color = {color = BLIZZARD_WHITE, hit_color = BLIZZARD_WHITE}
    local flare_red_color = {color = FLARE_RED, hit_color = FLARE_RED_PS}
    local flare_blue_color = {color = FLARE_BLUE, hit_color = FLARE_BLUE_PS}
    local ipecac_color = {color = POISON_GREEN, hit_color = IPECAC_PS}
    local invisible_color = {color = INVISIBLE, hit_color = INVISIBLE_PS}
    local red_color = {color = RED, hit_color = ENEMY_RED_PS}
    local green_color = {color = GREEN, hit_color = GREEN_PS}
    local rock_color = {color = ROCK, hit_color = ROCK_PS}
    local blue_color = {color = BLUE, hit_color = BLUE_PS}
    local r_pink_1_color = {color = R_PINK_1, hit_color = R_PINK_1_PS}
    local r_pink_2_color = {color = R_PINK_2, hit_color = R_PINK_2_PS}
    local r_orange_color = {color = R_ORANGE, hit_color = R_ORANGE_PS}
    local r_yellow_color = {color = R_YELLOW, hit_color = R_YELLOW_PS}
    local r_yellow_green_color = {color = R_YELLOW_GREEN, hit_color = R_YELLOW_GREEN_PS}
    local r_green_color = {color = R_GREEN, hit_color = R_GREEN_PS}
    local r_blue_1_color = {color = R_BLUE_1, hit_color = R_BLUE_1_PS}
    local r_blue_2_color = {color = R_BLUE_2, hit_color = R_BLUE_2_PS}

    insertDefaultsToGroup({'Rock Throw', 'Dual', 'Razor Leaf', 'Magnum', 'Rocket Launcher', 
                           'The Direct Hit', 'Psyburst', 'Minigun', 'Natascha', 'Egg Bomb Launcher',
                           'Stickybomb Launcher', "The Beggar's Bazooka", 'A Friend', 'Bicurious',
                           'Mutant Spider', 'Resonance Cascade'}, {yellow_color}, 'projectile_modifiers')
    insertDefaultsToGroup({'Rock Throw'}, {rock_color}, 'projectile_modifiers')
    insertDefaultsToGroup({"Anivia's R"}, {blizzard_color}, 'projectile_modifiers')
    insertDefaultsToGroup({'Ember'}, {flare_red_color}, 'projectile_modifiers')
    insertDefaultsToGroup({'A Better Friend'}, {red_color}, 'projectile_modifiers')
    insertDefaultsToGroup({'Flamethrower'}, {invisible_color}, 'projectile_modifiers')
    insertDefaultsToGroup({'Sludge Bomb'}, {ipecac_color}, 'projectile_modifiers')
    insertDefaultsToGroup({'Technology 2', 'Technology', 'Brimstone'}, {red_color}, 'line_modifiers')
    insertDefaultsToGroup({'green9090'}, {green_color}, 'line_modifiers')
    insertDefaultsToGroup({'Bubblebeam'}, {blue_color}, 'projectile_modifiers')

    attacks_list = {}
    table.insert(attacks_list, attacks['Razor Leaf'])
    table.insert(attacks_list, attacks['Egg Bomb Launcher'])
    table.insert(attacks_list, attacks['Psyburst'])
    table.insert(attacks_list, attacks['Rock Throw'])
    table.insert(attacks_list, attacks['Ember'])
    table.insert(attacks_list, attacks['Sludge Bomb'])
    table.insert(attacks_list, attacks['Resonance Cascade'])
    table.insert(attacks_list, attacks['Mutant Spider'])
    table.insert(attacks_list, attacks['Minigun'])
    table.insert(attacks_list, attacks['Technology'])
    table.insert(attacks_list, attacks['Magnum'])
    table.insert(attacks_list, attacks['Technology 2'])
    table.insert(attacks_list, attacks['Rocket Launcher'])
    table.insert(attacks_list, attacks['Brimstone'])
    table.insert(attacks_list, attacks['Stickybomb Launcher'])
    table.insert(attacks_list, attacks['Flamethrower'])
    table.insert(attacks_list, attacks["The Beggar's Bazooka"])
    table.insert(attacks_list, attacks['Natascha'])
    table.insert(attacks_list, attacks['The Direct Hit'])
    table.insert(attacks_list, attacks['Dual'])
end

function insertTableToKey(orig_t, add_t, key)
    if key then for k, v in pairs(add_t) do orig_t[key][k] = v end
    else for k, v in pairs(add_t) do orig_t[k] = v end end 
    return orig_t
end

function insertDefaultsToTarget(target, defaults, key)
    for _, default in ipairs(defaults) do
        insertTableToKey(attacks[target], default, key)
    end
end

function insertDefaultsToGroup(targets, defaults, key)
    for _, target in ipairs(targets) do
        insertDefaultsToTarget(target, defaults, key)
    end
end
