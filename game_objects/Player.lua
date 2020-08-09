Player = class('Player', Entity)
Player:include(Collector)
Player:include(PhysicsRectangle)
Player:include(Input)
Player:include(Movable)
Player:include(Jumper)
Player:include(Hittable)
Player:include(Logic)
Player:include(Attacker)
Player:include(Itemuser)
Player:include(LogicActivation)
Player:include(PlayerEnemyVisual)
Player:include(Stats)

function Player:initialize(world, x, y)
    Entity.initialize(self, x, y)
    self:collectorInit()
    self:physicsRectangleInit(world, 'dynamic', PLAYERW, PLAYERH)
    self:inputInit(playerInputKeys)
    self:movableInit(PLAYERA, statsToValues(player_stats).speed, PLAYER_GRAVITY_SCALE, 1)
    self:jumperInit(PLAYER_JUMP_IMPULSE, 1)
    self:hittableInit(0.05, 32)
    self:logicInit()
    self:attackerInit()
    self:itemuserInit()
    self:logicActivationInit()
    self:visualInit({walk_left = player_left, walk_right = player_right}, 36, 42, 0.15)
    self:statsInit(player_stats)

    self.dying_rgb = {255, 255, 255, 255}

    --[[
    -- Item specific
    self.player_dead = false
    self.dead_ringer_decoy_p = nil
    self.dead_ringer_anim = table.choose({self.walk_left, self.walk_right})
    self:collectorAddMessage(beholder.observe('EXPLODE DEAD RINGER DECOY', function()
        if self.dead_ringer_decoy_p then
            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'EnemyDead', self.dead_ringer_decoy_p.x, self.dead_ringer_decoy_p.y, ITEMGET_PS)
            main_chrono:cancel(self.dead_ringer_cid)
            self.dead_ringer_decoy_p = nil
        end
    end))
    ]]--

    self.passives = table.copy(player_passives)
    for _, passive in ipairs(self.passives) do
        if passive == 'The Scout' then if self.max_jumps == 1 then self.max_jumps = 2 end
        elseif passive == "JUMP'NSHOOTMAN" then self.max_jumps = 3
        elseif passive == 'Rainbow Dash' then if self.max_dashes == 1 then self.max_dashes = 2 end
        elseif passive == "DASH'NSHOOTMAN" then self.max_dashes = 3 end
    end
    self.familiars = {}
    self.buffs = table.copy(p_buffs)

    self.enemies_list_bomb = nil
    self:collectorAddMessage(beholder.observe('ENEMIES LIST REPLY', function(enemies)
        self.enemies_list_bomb = enemies
    end))

    self.bombing = false
    self.bombing_hard = false
    self:collectorAddMessage(beholder.observe('BOMB PRESSED' .. self.id, function()
        if bombs > 0 and not self.bombing_hard then
            bombs = bombs - 1
            self.invulnerable = true
            self.bombing = true
            self.bombing_hard = true
            self.input_disabled = true
            beholder.trigger('JUMP RELEASED' .. self.id)
            self:collectorAddTimer(main_chrono:every(0.1, 20, function()
                if self.bombing then
                    beholder.trigger('ENEMIES LIST REQUEST' .. current_level_id)
                    self.enemies_list_bomb = table.filter(self.enemies_list_bomb, function(v)
                        if not v.dying then return true end
                    end)
                    if #self.enemies_list_bomb > 0 then
                        local enemy = self.enemies_list_bomb[math.random(1, #self.enemies_list_bomb)]
                        if enemy then 
                            enemy:dealDamage(6) 
                            local x, y = enemy.body:getPosition()
                            local directions = {'left', 'right'}
                            local direction = directions[math.random(1, #directions)]
                            local particles = {'Explosion1', 'Explosion2', 'Explosion3'}
                            local particle = particles[math.random(1, #particles)]
                            beholder.trigger('CREATE PLAYER SHADOW' .. current_level_id, x, y, direction, true, true)
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, particle, x, y, {32, 32, 32, 255, 64, 64, 64, 0})
                            self:collectorAddTimer(main_chrono:every(0.05, 5, function()
                                local bombs = {'bomb1', 'bomb2', 'bomb3', 'bomb4', 'bomb5', 'bomb6', 'bomb7', 'bomb8'}
                                local bomb = bombs[math.random(1, #bombs)]
                                beholder.trigger('CREATE AREA' .. current_level_id, x + math.random(-48, 48), y + math.random(-48, 48), 'small', bomb, {}, false, true)
                                beholder.trigger('SHAKE' .. current_level_id, 1, 0.2)
                            end))
                        end
                    else
                        self.invulnerable = false
                        self.bombing = false
                        self.input_disabled = false
                    end
                    self.enemies_list_bomb = nil
                end
            end))
            self:collectorAddTimer(main_chrono:after(2, function()
                self.invulnerable = false
                self.bombing = false
                self.bombing_hard = false
                self.input_disabled = false
            end))
        end
    end))
end

function Player:update(dt)
    self:inputUpdate(dt)
    self:jumperUpdate(dt)
    self:movableUpdate(dt) 
    self:logicUpdate(dt)
    self:itemUpdate(dt)
    self:visualUpdate(dt)
    self:attackUpdate(dt)
    self:statsUpdate(dt)

    -- Minigun/Natascha's slow
    if self.current_attack then
        if self.current_attack.name == 'Minigun' or self.current_attack.name == 'Natascha' then
            if self.activated and not self.slowed then self:setSlow(0.25, 0.1) end
        end
    end

    -- Buffs
    for i = #self.buffs, 1, -1 do
        if item_specific[self.buffs[i].name] then
            if love.timer.getTime() > self.buffs[i].t + item_specific[self.buffs[i].name].duration*effect_duration_multiplier then
                if self.buffs[i].name == "Gangplank's Soul" then 
                    gangplanks_soul = false
                elseif self.buffs[i].name == 'Double Damage' then
                    double_damage = false
                elseif self.buffs[i].name == 'Double Defense' then
                    double_defense = false
                end
                table.remove(self.buffs, i)
            end
        end
    end
end

function Player:draw()
    if self.bombing then return end
    if not self.invisible then
        if self.blinking then love.graphics.setColor(colors.white(0))
        else love.graphics.setColor(colors.white(self.alpha)) end
    else love.graphics.setColor(colors.white(self.alpha)) end
    if self.current_attack then
        if self.current_attack.name == 'Brimstone' then
            --love.graphics.setColorMode('combine')
            love.graphics.setColor(unpack(self.brim_rgb))
        end
    end
    self:visualDraw()
    --love.graphics.setColorMode('modulate')
    love.graphics.setColor(colors.white)
    self:attackDraw()
    self:itemDraw()
    self:physicsRectangleDraw()
end

function Player:collisionSolid(solid, nx, ny)
    beholder.trigger('COLLISION ENTER' .. self.id, nx, ny)
end

function Player:collisionEnemy(enemy)
    if self.invulnerable then return end
    --[[
    -- Activate dead ringer if the player has it and collided with an enemy
    if self.current_item then
        if self.current_item.name == 'The Dead Ringer' then
            -- Create dead ringer's decoy
            if not self.dead_ringer_decoy_p then
                self.dead_ringer_anim = table.choose({self.walk_left, self.walk_right})
                self.dead_ringer_decoy_p = Vector(self.p.x, self.p.y)
                -- Decoy's particles
                local id = main_chrono:every(0.05, function()
                    local r1, g1, b1, a1 = math.random(200, 236), math.random(200, 236), math.random(200, 216), 255
                    local r2, g2, b2, a2 = math.random(200, 236), math.random(200, 236), math.random(200, 216), 0
                    local c = {r1, g1, b1, a1, r2, g2, b2, a2}
                    if self.dead_ringer_decoy_p then
                        beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'Up', self.dead_ringer_decoy_p.x+math.random(-self.w/2, self.w/2), self.dead_ringer_decoy_p.y+self.h/2-math.random(4), c)
                    end
                end)
                self:collectorAddTimer(id)
                self.dead_ringer_cid = id.id
                -- Change item to invis watch and activate it
                self.current_item = items['Invis Watch']
                self:useActiveItem(self.current_item.activation)
            end
        -- Item but not dead ringer
        else
            if not enemy.dying then
                beholder.trigger('HIT' .. self.id)
                if enemy.hard then beholder.trigger('HP DECREASE' .. self.id, 1)
                else beholder.trigger('HP DECREASE' .. self.id, 0.5) end
            end
        end
    -- No item
    else
    ]]--
    local x, y = self.body:getPosition()
    if not enemy.dying then
        if okay then
            if dice(0.35*(luck)) then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {222, 29, 29, 255, 196, 24, 24, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {196, 24, 24, 255, 222, 29, 29, 0})
                if dice(0.7) then beholder.trigger('CREATE RESOURCE' .. current_level_id, 'HalfHeart', x, y)
                else beholder.trigger('CREATE RESOURCE' .. current_level_id, 'Heart', x, y) end
            end
        end
        beholder.trigger('PLAY SOUND EFFECT', 'player_hit')
        beholder.trigger('HIT' .. self.id)
        if enemy.hard then beholder.trigger('HP DECREASE' .. self.id, 1)
        else beholder.trigger('HP DECREASE' .. self.id, 0.5) end
    end
end

function Player:collisionItemBox(itembox)
    local next_attack = generateNewAttack(self.current_attack) 
    local next_item = generateNewItem(self.current_item) 
    local next_passive = generateNewPassive()
    local attack_or_item_or_passive = chooseWithProb({'attack', 'item', 'passive'}, {0.4, 0.3, 0.3})

    -- New _ is an attack: simply set the new attack and create a new box
    if attack_or_item_or_passive == 'attack' then 
        self.can_attack_press = false
        self.can_attack_down = false 
        self:collectorAddTimer(main_chrono:after(0.02, function() self.can_attack_down = true; self.can_attack_press = true end))
        if self.current_attack.name == 'Brimstone' then
            self.brim_release = nil
        elseif self.current_attack.name == 'Stickybomb Launcher' and next_attack.name ~= 'Stickybomb Launcher' then
            self.current_item = items['Empty']
        end
        -- Change attack
        self.current_attack = next_attack
        beholder.trigger('ATTACK CHANGE' .. self.id)
        if self.current_attack.name == 'Stickybomb Launcher' then self.current_item = items['Stickybomb Launcher'] end
        beholder.trigger('CREATE ITEMBOX' .. current_level_id, next_attack.name)

    elseif attack_or_item_or_passive == 'passive' then
        next_passive.action(self)
        table.insert(self.passives, next_passive.name)
        beholder.trigger('CREATE ITEMBOX' .. current_level_id, next_passive.name)

    -- New _ is an item: remove previous items, set new item and create new box
    elseif attack_or_item_or_passive == 'item' then
        -- If the player is or has the invis watch then set him back to normal
        -- and explode possible decoys.
        if self.current_item.name == 'Invis Watch' then
            if self.invisible_cid then main_chrono:cancel(self.invisible_cid.id) end
            if self.invisible_tid then main_tween.stop(self.invisible_tid) end
            self.alpha = 255
            self.invisible = false
            self.invulnerable = false
            beholder.trigger('EXPLODE DEAD RINGER DECOY') 

        elseif self.current_item.name == 'Stickybomb Launcher' and next_item.name ~= 'Stickybomb Launcher' then
            self.current_attack = attacks['Rock Throw']
            beholder.trigger('PROJECTILES LIST REQUEST' .. current_level_id)
            for _, projectile in ipairs(self.projectiles_list) do
                if projectile.projectile_modifier.name == 'Stickybomb Launcher' then
                    projectile.dead = true
                end
            end
        end
        -- A new item means all existing cooldowns get removed
        self.can_item_press = true
        self.can_item_down = true
        self.current_item = next_item 
        if self.current_item.name == 'Stickybomb Launcher' then self.current_attack = attacks['Stickybomb Launcher'] end
        beholder.trigger('CREATE ITEMBOX' .. current_level_id, next_item.name) 
    end
    beholder.trigger('ITEMGET MOVE TEXT' .. itembox.id, itembox.p.x, itembox.p.y)
    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ItemGet', itembox.p.x, itembox.p.y, ITEMGET_PS)
end

function Player:spawnParticleEffectsItem(proj)
    if self.current_item then
        if self.current_item.name == "Anivia's R" then
            beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Blizzard', proj, {x = 0, y = 0}, {97, 174, 237, 255, 37, 114, 117, 0})
            beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Blizzard', proj, {x = 0, y = 0}, {37, 114, 177, 255, 97, 174, 237, 0}) 
            beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Blizzard', proj, {x = 0, y = 0}, {111, 153, 255, 255, 111, 153, 255, 0})
            self.current_item = items['Empty']
        end
    end
end

-- Spawn attack specific particles... Fix this function later!
-- This is here and not on Projectile because I need to access the player's current attack.
-- I could move it there but... :3c 
function Player:spawnParticleEffects(proj)
    if self.current_attack then
        if self.current_attack.p_effect then
            -- p_follow = true -> should follow parent, in this case parent = proj
            if self.current_attack.p_follow then
                -- p_interval = 0 -> continuous particle effect
                if self.current_attack.p_interval == 0 then

                -- p_interval != -> particle effect spawned every p_interval seconds
                else
                    if self.current_attack.p_effect == 'Flamethrower' then
                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval*2, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGunTrail', proj.p.x, proj.p.y, FLARE_RED_PS)
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGunTrail', proj.p.x-math.random(4), proj.p.y-math.random(4), FLARE_RED_PS)
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGunTrail', proj.p.x+math.random(4), proj.p.y+math.random(4), FLARE_RED_PS)
                        end))

                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGun', proj.p.x, proj.p.y, FLARE_RED_PS)
                        end))
                    end
                end

            -- p_follow = false -> shouldn't follow parent, just spawn particles in its current position (proj.p.x, .p.y)
            else
                if self.current_attack.p_interval == 0 then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, self.current_attack.p_effect, proj.p.x, proj.p.y, self.current_attack.p_color)
                else
                    if self.current_attack.p_effect == 'Rocket Launcher' then
                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'RocketLauncher1', proj.p.x, proj.p.y, BLIZZARD_BLUE)
                        end))

                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval*2, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'RocketLauncher2', proj.p.x, proj.p.y, BLIZZARD_GRAY)
                        end))

                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval*3, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'RocketLauncher3', proj.p.x, proj.p.y, BLIZZARD_WHITE)
                        end))
                    
                    elseif self.current_attack.p_effect == 'Ember' then
                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval*2, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGunTrail', proj.p.x, proj.p.y, FLARE_RED_PS)
                        end))

                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGun', proj.p.x, proj.p.y, FLARE_RED_PS)
                        end))

                    elseif self.current_attack.p_effect == 'Sludge Bomb' then
                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval*2, function()
                            local r, g, b = math.random(77, 97), math.random(54, 74), math.random(106, 126)
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGunTrail', proj.p.x, proj.p.y, 
                                             POISON_GREEN)
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGunTrail', proj.p.x, proj.p.y, 
                                            {r, g, b, 255, r, g, b, 0})
                        end))

                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval, function()
                            local r, g, b = math.random(77, 97), math.random(54, 74), math.random(106, 126)
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGun', proj.p.x, proj.p.y, 
                                             POISON_GREEN)
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGun', proj.p.x, proj.p.y, 
                                            {r, g, b, 255, r, g, b, 0})
                        end))
                    end
                end
            end
        end
    end
end

function Player:randomize(proj)
    if self.current_attack then
        if self.current_attack.projectile_modifiers then
            if self.current_attack.projectile_modifiers.randomize_v then
                if self.current_attack.name == 'Psyburst' then
                    proj.v = math.prandom(proj.v_i-100, proj.v_i+100)
                    proj.a = math.prandom(proj.a-75, proj.a+75)
                end
            end
        end
    end
end

function Player:keypressed(key)
    self:inputKeypressed(key)
end

function Player:keyreleased(key)
    self:inputKeyreleased(key)
end
