function loadPassives()
    local passive = struct('name', 'action', 'undo', 'desc_text', 'other_text')
    passives = {}

    passives['Book #7'] = passive('Book #7', function(self)
        book_7 = true
        self.stats.speed = self.stats.speed - 1
        self.stats.damage = self.stats.damage - 1
        self.stats.cooldown = self.stats.cooldown - 1
        self.stats.pierce = self.stats.pierce - 1
        self.stats.reflect = self.stats.reflect - 1
        self.stats.max_hp = self.stats.max_hp - 1
        if self.stats.hp > self.stats.max_hp then self.stats.hp = self.stats.max_hp end
        if self.stats.damage < 1 then self.stats.damage = 1 end
        if self.stats.speed < 1 then self.stats.speed = 1 end
        if self.stats.cooldown < 1 then self.stats.cooldown = 1 end
        if self.stats.pierce < 1 then self.stats.pierce = 1 end
        if self.stats.reflect < 1 then self.stats.reflect = 1 end
    end, nil, 'more passives, all stats down', {})

    passives['Book #6'] = passive('Book #6', function(self)
        added_difficulty = added_difficulty + 1
    end, nil, 'difficulty up', {})

    passives['Book #5'] = passive('Book #5', function(self)
        self.stats.cooldown = self.stats.cooldown + 2
        self.stats.speed = self.stats.speed + 2
        if self.stats.cooldown > 8 then self.stats.cooldown = 8 end
        if self.stats.speed > 8 then self.stats.speed = 8 end
        added_difficulty = added_difficulty + 1
    end, nil, 'fire rate, speed, difficulty up', {})

    passives['Book #4'] = passive('Book #4', function(self)
        self.stats.damage = self.stats.damage + 1
        if self.stats.damage > 8 then self.stats.damage = 8 end
        added_difficulty = added_difficulty + 1
    end, nil, 'damage, difficulty up', {'a deal with the devil'})

    passives['Book #3'] = passive('Book #3', function(self)
        self.stats.pierce = self.stats.pierce + 2
        added_difficulty = added_difficulty + 1
        if self.stats.pierce > 8 then self.stats.pierce = 8 end
    end, nil, 'pierce, difficulty up', {})

    passives['Book #2'] = passive('Book #2', function(self)
        self.stats.damage = self.stats.damage + 1
        if self.stats.damage > 8 then self.stats.damage = 8 end
    end, nil, 'damage up', {})

    passives['Book #1'] = passive('Book #1', function(self)
        book_1 = true
        self.stats.damage = self.stats.damage + 2
        if self.stats.damage > 8 then self.stats.damage = 8 end
    end, nil, 'less hearts, less masks, damage up', {})

    passives['Love'] = passive('Love', function(self)
        more_hearts = true
    end, nil, 'more hearts', {})

    passives['Cannon Barrage'] = passive('Cannon Barrage', function(self)
        more_bombs = true
        bombs = bombs + 3
    end, nil, 'more bombs', {})

    passives['Rains of Castamere'] = passive('Rains of Castamere', function(self)
        arrows = true
    end, nil, 'arrows!', {})

    passives['Ninja Assassin'] = passive('Ninja Assassin', function(self)
        self.stats.cooldown = self.stats.cooldown + 2
        self.stats.speed = self.stats.speed + 1
        self.stats.damage = self.stats.damage - 1
        if self.stats.cooldown > 8 then self.stats.cooldown = 8 end
        if self.stats.speed > 8 then self.stats.speed = 8 end
        if self.stats.damage < 1 then self.stats.damage = 1 end
    end, nil, 'fire rate, speed up', {})

    passives['My Reflection'] = passive('My Reflection', function(self)
        self.stats.reflect = self.stats.reflect + 1
        if self.stats.reflect > 8 then self.stats.reflect = 8 end
    end, nil, 'reflect up', {"hiding wounds won't ease the pain"})

    passives["Charon's Obol"] = passive("Charon's Obol", function(self)
        more_money = true
    end, nil, 'more money', {'rogue legacy kinda sucked :('})

    passives["Jack Sparrow's Heart"] = passive("Jack Sparrow's Heart", function(self)
        more_chests = true
    end, nil, 'more chests', {'savy?'})

    passives['Watermelon'] = passive('Watermelon', function(self)
        self.stats.max_hp = self.stats.max_hp + 1
        self.stats.hp = self.stats.hp + 1
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
        if self.stats.hp > self.stats.max_hp then self.stats.hp = self.stats.max_hp end
    end, nil, 'hp up', {})

    passives['Pie'] = passive('Pie', function(self)
        self.stats.max_hp = self.stats.max_hp + 2
        self.stats.hp = self.stats.hp + 2
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
        if self.stats.hp > self.stats.max_hp then self.stats.hp = self.stats.max_hp end
    end, nil, 'hp, hearts up', {})

    passives['Orange'] = passive('Orange', function(self)
        self.stats.max_hp = self.stats.max_hp + 1
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
        self.stats.hp = self.stats.max_hp
    end, nil, 'hp up', {})

    passives['Meat'] = passive('Meat', function(self)
        self.stats.max_hp = self.stats.max_hp + 2
        self.stats.hp = self.stats.hp + 1
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
        if self.stats.hp > self.stats.max_hp then self.stats.hp = self.stats.max_hp end
    end, nil, 'hp, hearts up', {})

    passives['Fish'] = passive('Fish', function(self)
        self.stats.max_hp = self.stats.max_hp + 2
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
    end, nil, 'hp up', {})

    passives['Cherry'] = passive('Cherry', function(self)
        self.stats.max_hp = self.stats.max_hp + 1
        self.stats.hp = self.stats.hp + 1
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
        if self.stats.hp > self.stats.max_hp then self.stats.hp = self.stats.max_hp end
    end, nil, 'hp, hearts up', {})

    passives['Egg'] = passive('Egg', function(self)
        self.stats.max_hp = self.stats.max_hp + 1
        self.stats.hp = self.stats.hp + 1
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
        if self.stats.hp > self.stats.max_hp then self.stats.hp = self.stats.max_hp end
    end, nil, 'hp, hearts up', {})

    passives['Cheese'] = passive('Cheese', function(self)
        self.stats.max_hp = self.stats.max_hp + 1
        self.stats.hp = self.stats.hp + 1
        if self.stats.hp > self.stats.max_hp then self.stats.hp = self.stats.max_hp end
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
    end, nil, 'hp, hearts up', {})

    passives['Carrot'] = passive('Carrot', function(self)
        self.stats.max_hp = self.stats.max_hp + 1
        self.stats.hp = self.stats.hp + 1
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
        if self.stats.hp > self.stats.max_hp then self.stats.hp = self.stats.max_hp end
    end, nil, 'hp up', {})

    passives['Bread'] = passive('Bread', function(self)
        self.stats.max_hp = self.stats.max_hp + 1
        self.stats.hp = self.stats.hp + 1
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
        if self.stats.hp > self.stats.max_hp then self.stats.hp = self.stats.max_hp end
    end, nil, 'hp up', {})

    passives['Banana'] = passive('Banana', function(self)
        self.stats.max_hp = self.stats.max_hp + 1
        self.stats.hp = self.stats.hp + 1
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
        if self.stats.hp > self.stats.max_hp then self.stats.hp = self.stats.max_hp end
    end, nil, 'hp up', {})

    passives['Apple'] = passive('Apple', function(self)
        self.stats.max_hp = self.stats.max_hp + 1
        self.stats.hp = self.stats.hp + 1
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
        if self.stats.hp > self.stats.max_hp then self.stats.hp = self.stats.max_hp end
    end, nil, 'hp, hearts up', {'steve jobs died'})

    passives['Impervius'] = passive('Impervius', function(self)
        self.stats.max_hp = self.stats.max_hp + 1
        self.stats.reflect = self.stats.reflect + 1
        if self.stats.reflect > 8 then self.stats.reflect = 8 end
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
    end, nil, 'hp, reflect up', {})

    passives['Equilibrium Spear'] = passive('Equilibrium Spear', function(self)
        stun_damage = true
    end, nil, 'stunning shots', {})

    passives['Enchanted Crystal Spear'] = passive('Enchanted Crystal Spear', function(self)
        ice_damage = true
    end, nil, 'slowing shots', {})

    passives['Grog Soaked Spear'] = passive('Grog Soaked Spear', function(self)
        poison_damage = true
    end, nil, 'poisoning shots', {})

    passives["Starshooter"] = passive("Starshooter", function(self)
        self.stats.cooldown = self.stats.cooldown + 3
        self.stats.speed = self.stats.speed + 1
        self.stats.damage = self.stats.damage - 1
        self.stats.pierce = self.stats.pierce - 1
        self.stats.reflect = self.stats.reflect - 1
        if self.stats.cooldown > 8 then self.stats.cooldown = 8 end
        if self.stats.speed > 8 then self.stats.speed = 8 end
        if self.stats.damage < 1 then self.stats.damage = 1 end
        if self.stats.pierce < 1 then self.stats.pierce = 1 end
        if self.stats.reflect < 1 then self.stats.reflect = 1 end
    end, nil, 'fire rate, speed up', {})

    passives["Everything's Okay"] = passive("Everything's Okay", function(self)
        okay = true
    end, nil, 'healing defense', {"you're safe"})

    passives['Waterbending = Healing'] = passive('Waterbending = Healing', function(self)
        vampirism = true
    end, nil, 'healing attacks', {})

    passives['Not Masamune'] = passive('Not Masamune', function(self)
        self.stats.damage = self.stats.damage + 1
        self.stats.pierce = self.stats.pierce + 1
        if self.stats.damage > 8 then self.stats.damage = 8 end
        if self.stats.pierce > 8 then self.stats.pierce = 8 end
    end, nil, 'damage, pierce up', {})

    passives["Ayla's Necklace"] = passive("Ayla's Necklace", function(self)
        self.stats.damage = self.stats.damage + 1
        self.stats.speed = self.stats.speed + 1
        self.stats.max_hp = self.stats.max_hp + 1
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
        self.stats.hp = self.stats.max_hp
        if self.stats.damage > 8 then self.stats.damage = 8 end
        if self.stats.speed > 8 then self.stats.speed = 8 end
    end, nil, 'damage, speed, hp, hearts up', {})

    passives["Marle's Pendant"] = passive("Marle's Pendant", function(self)
        self.stats.max_hp = self.stats.max_hp + 2
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
    end, nil, 'hp up', {})

    passives["Legolas' Bow"] = passive("Legolas' Bow", function(self)
        self.stats.cooldown = self.stats.cooldown + 1
        if self.stats.cooldown > 8 then self.stats.cooldown = 8 end
    end, nil, 'fire rate up', {"they're taking the hobbits to isengard"})

    passives['The Pentagram'] = passive('The Pentagram', function(self)
        self.stats.damage = self.stats.damage + 2
        if self.stats.damage > 8 then self.stats.damage = 8 end
    end, nil, 'damage up', {})

    passives['Earth Automaton'] = passive('Earth Automaton', function(self)
        green_tower = true
    end, nil, '', {})
    
    passives['Fire Automaton'] = passive('Fire Automaton', function(self)
        red_tower = true
    end, nil, '', {})

    passives['Air Automaton'] = passive('Air Automaton', function(self)
        yellow_tower = true
    end, nil, '', {})

    passives['Water Automaton'] = passive('Water Automaton', function(self)
        blue_tower = true
    end, nil, '', {})

    passives['The Scout'] = passive('The Scout', function(self) 
        if self.max_jumps == 1 then self.max_jumps = 2 end 
        self.stats.speed = self.stats.speed + 2
        if self.stats.speed > 8 then self.stats.speed = 8 end
    end, nil, 'double jump, speed up', {})

    passives['Rainbow Dash'] = passive('Rainbow Dash', function(self)
        if self.max_dashes == 1 then self.max_dashes = 2 end 
        self.stats.speed = self.stats.speed + 2
        if self.stats.speed > 8 then self.stats.speed = 8 end
    end, nil, 'double dash, speed up', {})

    passives["DASH'NSHOOTMAN"] = passive("DASH'NSHOOTMAN", function(self)
        self.max_dashes = 3
        self.stats.cooldown = self.stats.cooldown + 1
        if self.stats.cooldown > 8 then self.stats.cooldown = 8 end
    end, nil, 'triple dash, fire rate up', {})

    passives["MOV'NSHOOTMAN"] = passive("MOV'NSHOOTMAN", function(self)
        self.stats.cooldown = self.stats.cooldown + 1
        self.stats.speed = self.stats.speed + 1
        if self.stats.cooldown > 8 then self.stats.cooldown = 8 end
        if self.stats.speed > 8 then self.stats.speed = 8 end
    end, nil, 'fire rate, speed up', {})

    passives["JUMP'NSHOOTMAN"] = passive("JUMP'NSHOOTMAN", function(self) 
        self.max_jumps = 3 
        self.stats.cooldown = self.stats.cooldown + 1
        if self.stats.cooldown > 8 then self.stats.cooldown = 8 end
    end, nil, 'triple jump, fire rate up', {"they don't know obama", "i don't feel sorry for you", "yeah! yeah, lemons!"})

    passives['The Tom Cruise'] = passive('The Tom Cruise', function(self)
        self.stats.speed = self.stats.speed + 1
        if self.stats.speed > 8 then self.stats.speed = 8 end
    end, nil, 'speed up', {"you can't catch me, gay thoughts!", "loved him in the matrix"})

    passives['The Michael Bay'] = passive('The Michael Bay', function(self)
        self.stats.explosion_size = self.stats.explosion_size + 2
        if self.stats.explosion_size > 8 then self.stats.explosion_size = 8 end
        exploding_shots = true
    end, nil, 'exploding shots, explosion size up', {})

    passives['King of Loss'] = passive('King of Loss', function(self)
        self.stats.mask = self.stats.mask + 2
        money = money + 25
    end, nil, '+masks, +money', {"we're all crying for respect and attention", "every monetary pile will buy me a precious smile", "long live the dying king!"})

    passives['Chronomage'] = passive('Chronomage', function(self)
        chronomaged = true
        effect_duration_multiplier = effect_duration_multiplier + 0.25
    end, nil, 'double item use, effect duration up', {"zilean's gift"})

    passives['Thick Skin'] = passive('Thick Skin', function(self)
        thick_skinned = true
    end, nil, 'damage resistance', {})

    passives['Kiri kiri kiri'] = passive('Kiri kiri kiri', function(self)
        self.stats.damage = self.stats.damage + 1
        self.stats.pierce = self.stats.pierce + 1
        if self.stats.damage > 8 then self.stats.damage = 8 end
        if self.stats.pierce > 8 then self.stats.pierce = 8 end
    end, nil, 'damage, pierce up', {})

    passives['Ricochet'] = passive('Ricochet', function(self)
        self.stats.reflect = self.stats.reflect + 1
        if self.stats.reflect > 8 then self.stats.reflect = 8 end
    end, nil, 'reflect up', {})

    passives['HL3'] = passive('HL3', function(self)
        self.stats.reflect = self.stats.reflect + 2
        if self.stats.reflect > 8 then self.stats.reflect = 8 end
    end, nil, 'reflect up', {"when?", "gaben, why?", "will it be worth the weight?"})

    passives['Gun Kata'] = passive('Gun Kata', function(self)
        self.stats.damage = self.stats.damage + 1
        self.stats.speed = self.stats.speed + 1
        self.stats.cooldown = self.stats.cooldown + 1
        if self.stats.damage > 8 then self.stats.damage = 8 end
        if self.stats.speed > 8 then self.stats.speed = 8 end
        if self.stats.cooldown > 8 then self.stats.cooldown = 8 end
    end, nil, 'damage, speed, fire rate up', {})

    passives['ASPD'] = passive('ASPD', function(self)
        local hp = self.stats.max_hp
        self.stats.max_hp = 0
        self.stats.hp = 0
        self.stats.mask = self.stats.mask + 2*hp
        tat_free = true
    end, nil, 'hp->masks', {"2spooky4me"})

    passives['Fitter, Happier'] = passive('Fitter, Happier', function(self)
        self.stats.speed = self.stats.speed + 1
        self.stats.damage = self.stats.damage + 1
        self.stats.cooldown = self.stats.cooldown + 1
        self.stats.pierce = self.stats.pierce + 1
        self.stats.reflect = self.stats.reflect + 1
        self.stats.max_hp = self.stats.max_hp + 1
        if self.stats.damage > 8 then self.stats.damage = 8 end
        if self.stats.speed > 8 then self.stats.speed = 8 end
        if self.stats.cooldown > 8 then self.stats.cooldown = 8 end
        if self.stats.pierce > 8 then self.stats.pierce = 8 end
        if self.stats.reflect > 8 then self.stats.reflect = 8 end
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
        -- add more later
    end, nil, 'all stats up', {"more productive"})

    passives['Rare Candy'] = passive('Rare Candy', function(self)
        self.stats.speed = self.stats.speed + 1
        self.stats.damage = self.stats.damage + 1
        self.stats.cooldown = self.stats.cooldown + 1
        self.stats.pierce = self.stats.pierce + 1
        self.stats.reflect = self.stats.reflect + 1
        self.stats.max_hp = self.stats.max_hp + 1
        if self.stats.damage > 8 then self.stats.damage = 8 end
        if self.stats.speed > 8 then self.stats.speed = 8 end
        if self.stats.cooldown > 8 then self.stats.cooldown = 8 end
        if self.stats.pierce > 8 then self.stats.pierce = 8 end
        if self.stats.reflect > 8 then self.stats.reflect = 8 end
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
        -- add more later
    end, nil, 'all stats up', {})

    passives['Gentle Giant'] = passive('Gentle Giant', function(self)
        self.stats.speed = self.stats.speed + 2
        self.stats.damage = self.stats.damage + 2
        self.stats.cooldown = self.stats.cooldown + 2
        self.stats.pierce = self.stats.pierce + 2
        self.stats.reflect = self.stats.reflect + 2
        self.stats.max_hp = self.stats.max_hp + 2
        if self.stats.damage > 8 then self.stats.damage = 8 end
        if self.stats.speed > 8 then self.stats.speed = 8 end
        if self.stats.cooldown > 8 then self.stats.cooldown = 8 end
        if self.stats.pierce > 8 then self.stats.pierce = 8 end
        if self.stats.reflect > 8 then self.stats.reflect = 8 end
        if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
        -- add more later
        self.stats.mask = 0
        self.stats.hp = self.stats.max_hp
        gentle_giant = true
        no_new_masks = true
    end, nil, 'all stats up, vulnerable', {})

    passives['Genius, Billionaire, Playboy, Philanthropist'] = passive('Genius, Billionaire, Playboy, Philanthropist', function(self)
        money = money + 25
        self.stats.mask = self.stats.mask + 2
        if money >= 100 then money = 99 end
    end, nil, '+money, +masks', {})

    passives['Wildfire'] = passive('Wildfire', function(self)
        fire_spreads = true
    end, nil, 'fire spreads', {})
end
