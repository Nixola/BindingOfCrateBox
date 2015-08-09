Itemuser = {
    itemuserInit = function(self)
        self.current_item = table.copy(player_item)

        -- Screen
        self.screen = nil
        self.screen_duration = nil
        self.screen_p = {x = 0, y = 0}
        self.screen_s = nil
        self.screen_s_tween = nil
        self.screen_r = nil
        self.screen_r_tween = nil

        -- Spider Butt
        self.enemies_list = {}
        beholder.observe('ENEMIES LIST REPLY', function(list) self.enemies_list = list end)

        -- Stickybomb Launcher
        self.projectiles_list = {}
        beholder.observe('PROJECTILES LIST REPLY', function(list) self.projectiles_list = list end)
    end,

    -- This function is useless now. I'm not sure how I'm gonna handle passives...
    usePassiveItem = function(self)
        local name = self.current_item.name
    end,

    -- Screen pre-attack triggers:
    -- Sets current screen modifiers and triggers screen drawing.
    triggerScreen = function(self, name)
        self.screen = screens[name].image
        self.screen_duration = screens[name].duration
        self.screen_p.x = math.random(0, 100)
        self.screen_p.y = math.random(0, 100)
        self.screen_s = screens[name].s_i 
        self.screen_s_tween = screens[name].s_tween
        self.screen_r = screens[name].r_i
        self.screen_r_tween = screens[name].r_tween

        if self.screen_s then self:collectorAddTween(main_tween(self.screen_duration, self, {screen_s = screens[name].s_f}, self.screen_s_tween)) end
        if self.screen_r then self:collectorAddTween(main_tween(self.screen_duration, self, {screen_r = math.prandom(-screens[name].r_f, screens[name].r_f)}, self.screen_r_tween)) end

        self:collectorAddTimer(main_chrono:after(self.screen_duration, function()
            self.screen = nil
            self.screen_duration = nil
            self.screen_p = {x = 0, y = 0}
            self.screen_s = nil
            self.screen_s_tween = nil
            self.screen_r = nil
            self.screen_r_tween = nil
        end))
    end,

    useActiveItem = function(self, activation_type)
        local empty_item = function()
            if chronomaged then
                if not chronomaged_used then
                    chronomaged_used = true
                else
                    self.current_item = items['Empty']
                    chronomaged_used = false
                end
            else
                self.current_item = items['Empty']
            end
        end

        if self.current_item.activation == activation_type then
            local name = self.current_item.name
            
            -- The Invisibility Watch:
            -- Turns the player invisible/invincible for a certain duration and back to normal if he attacks.
            -- [a-z]id is the id/handler of that message/tween/timer in case the item gets re-used before the
            -- timer runs out and whatnot.
            if name == 'Invis Watch' then
                if not self.invisible then
                    -- Set invisibility/invulnerability to true + alpha tween
                    self.invisible = true
                    self.invulnerable = true
                    local tid = main_tween(item_specific['Invis Watch'].turn_duration, self, {alpha = 64}, 'linear')
                    self:collectorAddTween(tid)
                    self.invisible_tid = tid
                    -- After 'duration' player goes back to normal
                    local cid = main_chrono:after(item_specific['Invis Watch'].duration, function()
                        self.alpha = 255
                        self.invisible = false
                        self.invulnerable = false
                        -- Remove invis watch
                        empty_item()
                        -- If this invis watch was created because of dead ringer usage,
                        -- on top of returning the player back to normal, destroy the decoy.
                        --[[
                        if self.dead_ringer_decoy_p then 
                            self.current_item = items['Empty']
                            beholder.trigger('EXPLODE DEAD RINGER DECOY') 
                        end
                        ]]--
                    end)
                    self:collectorAddTimer(cid)
                    self.invisible_cid = cid
                else
                    -- If the item was used again while the player was invisible, cancel the previous
                    -- tweens/timers so they don't randomly activate after 'duration'.
                    if self.invisible_cid then main_chrono:cancel(self.invisible_cid.id) end
                    if self.invisible_tid then main_tween.stop(self.invisible_tid) end
                    -- Item used again = back to normal
                    self.alpha = 255
                    self.invisible = false
                    self.invulnerable = false
                    self.invisible_cid = nil
                    empty_item()
                    -- Same as above, if this invis watch was from dead ringer usage,
                    -- destroy the decoy.
                    --[[
                    if self.dead_ringer_decoy_p then 
                        self.current_item = items['Empty']
                        beholder.trigger('EXPLODE DEAD RINGER DECOY') 
                    end
                    ]]--
                end
            
            -- Spider Butt:
            -- Slows and damages all enemies for a certain duration
            elseif name == 'Spider Butt' then
                beholder.trigger('ENEMIES LIST REQUEST' .. current_level_id)
                for _, enemy in ipairs(self.enemies_list) do
                    enemy:dealDamage(item_specific['Spider Butt'].damage)
                    enemy:setSlow(item_specific['Spider Butt'].slow_value, item_specific['Spider Butt'].duration)
                end
                empty_item()
                self.enemies_list = nil

            elseif name == 'Through the Fire and Flames' then
                beholder.trigger('ENEMIES LIST REQUEST' .. current_level_id)
                for _, enemy in ipairs(self.enemies_list) do
                    enemy:dealDamage(item_specific['Through the Fire and Flames'].damage)
                    enemy:setDot(item_specific['Through the Fire and Flames'].interval, 
                                 item_specific['Through the Fire and Flames'].times,
                                 item_specific['Through the Fire and Flames'].damage)
                    enemy:setBurn(item_specific['Through the Fire and Flames'].interval, 
                                 item_specific['Through the Fire and Flames'].times,
                                 item_specific['Through the Fire and Flames'].damage)
                end
                empty_item()
                self.enemies_list = nil

            -- The Salamanca!:
            -- Releases a mine that explodes after a few seconds
            elseif name == 'The Salamanca!' then
                beholder.trigger('CREATE MINE' .. current_level_id, self.p.x, self.p.y, item_specific['The Salamanca!'].mine)
                self:triggerScreen('Salamanca')
                self:collectorAddTimer(main_chrono:after(mines[item_specific['The Salamanca!'].mine].ti, function()
                    beholder.trigger('SHAKE', 10, 1)
                end))
                empty_item()

            -- Stickybomb Launcher:
            -- Explodes all currently alive stickybomb projectiles
            elseif name == 'Stickybomb Launcher' then
                beholder.trigger('PROJECTILES LIST REQUEST' .. current_level_id)
                for _, projectile in ipairs(self.projectiles_list) do
                    if projectile.projectile_modifier.name == 'Stickybomb Launcher' then
                        beholder.trigger('AREA ON HIT' .. projectile.id, projectile.p.x, projectile.p.y)
                        projectile.dead = true
                    end
                end
                self.projectiles_list = nil

            -- Anivia's R:
            -- Creates a slow moving area that damages and slows all enemies within
            elseif name == "Anivia's R" then
                local attack = self.current_attack
                self.current_attack = attacks["Anivia's R"]
                self:attack(self.current_item.activation)
                self.current_attack = attack

            elseif name == 'The Joker' then
                beholder.trigger('CREATE FAMILIAR' .. current_level_id, 'Flaria', true)
                beholder.trigger('CREATE FAMILIAR' .. current_level_id, 'Flaria', true)
                beholder.trigger('CREATE FAMILIAR' .. current_level_id, 'Flaria', true)
                beholder.trigger('CREATE FAMILIAR' .. current_level_id, 'Flaria', true)
                empty_item()

            elseif name == "Gangplank's Soul" then
                local already_in_use = false
                for _, buff in ipairs(self.buffs) do
                    if buff.name == "Gangplank's Soul" then already_in_use = true end
                end
                if not already_in_use then
                    gangplanks_soul = true
                    table.insert(self.buffs, {t = love.timer.getTime(), name = "Gangplank's Soul"}) 
                    empty_item()
                end

            elseif name == 'Double Damage' then
                local already_in_use = false
                for _, buff in ipairs(self.buffs) do
                    if buff.name == 'Double Damage' then already_in_use = true end
                end
                if not already_in_use then
                    double_damage = true
                    table.insert(self.buffs, {t = love.timer.getTime(), name = 'Double Damage'}) 
                    empty_item()
                end

            elseif name == 'Double Defense' then
                local already_in_use = false
                for _, buff in ipairs(self.buffs) do
                    if buff.name == 'Double Defense' then already_in_use = true end
                end
                if not already_in_use then
                    double_defense = true
                    table.insert(self.buffs, {t = love.timer.getTime(), name = 'Double Defense'}) 
                    empty_item()
                end
            end

            for _, potion in ipairs(potions) do
                if name == potion then
                    local text = potions_map[potion](self)
                    items[potion].desc_text = text
                    beholder.trigger('UI TEXT', 'Item', potion)
                    table.insert(self.buffs, {t = love.timer.getTime(), name = potion}) 
                    empty_item()
                end
            end
        end
    end,

    itemUpdate = function(self, dt)
        if self.current_item then
            if self.current_item.activation == 'passive' then self:usePassiveItem() end     
        end
    end,

    itemDraw = function(self)
        if self.current_item then
            local name = self.current_item.name
            
            if name == 'Invis Watch' then
                -- Draw timer rectangle thingy above the player
                if self.invisible then
                    local d = item_specific['Invis Watch'].duration
                    local t = 0
                    if self.invisible_cid then t = self.invisible_cid.t end
                    love.graphics.rectangle('line', (self.p.x-self.w/1.5-2)*scale, (self.p.y-self.h/2-16)*scale, 1.5*self.w*scale, 8*scale)
                    love.graphics.rectangle('fill', (self.p.x-self.w/1.5-2)*scale, (self.p.y-self.h/2-16)*scale, (1.5*self.w-(t*1.5*self.w/d))*scale, 8*scale)
                end
                
                -- Draw decoy as the player's first frame always
                --[[
                if self.dead_ringer_decoy_p then
                    self.dead_ringer_anim:seek(1)
                    self.dead_ringer_anim:draw(self.dead_ringer_decoy_p.x*scale - self.w*scale/2, self.dead_ringer_decoy_p.y*scale - self.h*scale/2, 0, scale, scale)
                end
                ]]--
            end
        end 

        -- Fix later. Add item specific screens
        if self.screen then
            love.graphics.push()
            love.graphics.translate(self.screen_p.x, self.screen_p.y)
            love.graphics.rotate(self.screen_r or 0)
            love.graphics.translate(-self.screen_p.x, -self.screen_p.y)
            love.graphics.draw(self.screen, self.screen_p.x, self.screen_p.y, 0, self.screen_s, self.screen_s) 
            love.graphics.pop()
        end
    end
}
