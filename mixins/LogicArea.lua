LogicArea = {
    logicAreaInit = function(self, parent, area_logic_type, area_logic_subtype, area_modifier, check_size_flag, dont_spawn_particles)
        self.parent = parent
        self.area_logic = areas_logic[area_logic_type][area_logic_subtype]
        self.area_logic_type = area_logic_type
        self.area_logic_subtype = area_logic_subtype
        self.area_modifier = area_modifier
        self.instant = area_modifier.instant
        self.dot = area_modifier.dot
        self.slow = area_modifier.slow
        self.stun = area_modifier.stun
        self.exploding = area_modifier.exploding
        self.r_i = self.area_logic.r_i
        self.r_f = self.area_logic.r_f
        self.area_color = {244, 244, 244, 255}
        self.dont_spawn_particles = dont_spawn_particles

        local size_flag = false
        if self.parent then
            if self.parent.parent then
                if instanceOf(Player, self.parent.parent) then
                    if self.r_i then
                        self.r_i = self.r_i*self.parent.parent.explosion_multiplier
                    end
                    if self.r_f then
                        self.r_f = self.r_f*self.parent.parent.explosion_multiplier
                    end
                    size_flag = true
                end
            end
        end

        if check_size_flag then
            self.r_i = self.r_i*player_explosion_multiplier
            self.r_f = self.r_f*player_explosion_multiplier
        end

        if self.area_modifier.gravity then
            self.body:setGravityScale(self.area_modifier.gravity)
        else self.body:setGravityScale(0) end

        -- on_hit = area should explode when it hits a wall
        -- If not on_hit then if it has a tween it means the are should change
        -- so it is changed to final radius (r_f);
        -- Else simply die after 'duration' (if duration is set) and kill parent (if parent is set)
        -- (parent would be a projectile, usually).
        if not self.area_logic.on_hit then 
            if self.area_logic.tween then
                self:collectorAddTween(main_tween(self.area_logic.duration, self, 
                                                 {radius = self.r_f}, self.area_logic.tween))
            end

            if self.area_logic.duration then
                self:collectorAddTimer(main_chrono:after(self.area_logic.duration, function() 
                    self.dead = true 
                end))
                
                if self.parent then
                    self:collectorAddTimer(main_chrono:after(self.area_logic.duration, function() 
                        self.parent.dead = true 
                    end))
                end
            end
        end

        self.projectiles_list = nil
        self.area_query_list = nil

        self:collectorAddMessage(beholder.observe('PROJECTILES LIST REPLY', function(list) 
            self.projectiles_list = list 
        end))

        self:collectorAddMessage(beholder.observe('AREA QUERY REPLY', function(list) 
            self.area_query_list = list 
        end))

        -- If following a projectile
        if self.parent then
            -- Set radius to 0 if should explode on solid contact
            if self.area_logic.on_hit then self.radius = 0 end
            self.shape:setRadius(self.radius)

            -- Create a new area with exactly the same properties as this one on contact with wall, but no parent
            -- Since it has no parents it will explode immediately
            self:collectorAddMessage(beholder.observe('AREA ON HIT' .. self.parent.id, function(x, y) 
                -- Camera shake for exploding areas;
                -- Areas that explode bigger -> smaller should be treated differently when the need comes
                if self.r_f then
                    -- Some area types shouldn't trigger shakes since they aren't actual explosions
                    -- Use modifier's name for now but later find a better (more general) approach
                    if self.area_modifier.name ~= 'Flamethrower' then
                        if self.area_modifier.name ~= 'Egg Bomb Launcher' and self.area_modifier.name ~= 'Stickybomb Launcher' then
                            beholder.trigger('SHAKE' .. current_level_id, self.r_f/16, self.area_logic.duration)

                        else
                            if self.area_modifier.name == 'Egg Bomb Launcher' then
                                beholder.trigger('SHAKE' .. current_level_id, 3, 0.5)

                            elseif self.area_modifier.name == 'Stickybomb Launcher' then
                                beholder.trigger('SHAKE' .. current_level_id, 1, math.prandom(0.5, 1.5))
                            end
                        end
                    end
                end

                if self.area_logic.on_hit then
                    beholder.trigger('CREATE AREA' .. current_level_id, x, y, self.area_logic_type, self.area_logic_subtype, self.area_modifier, size_flag)
                    self:collectorAddTimer(main_chrono:after(self.area_logic.duration, function() 
                        self.dead = true 
                    end))
                    -- Spawn area specific particle effects
                    if self.area_modifier.name == 'Flamethrower' then
                        beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlameArea', x, y, FLARE_RED_PS)
                    end
                end
            end))

            -- Same as above for enemies
            self:collectorAddMessage(beholder.observe('ENEMY ON HIT' .. self.parent.id, function(x, y)
                if self.r_f then
                    if self.area_modifier.name ~= 'Flamethrower' then
                        beholder.trigger('SHAKE' .. current_level_id, self.r_f/32, self.area_logic.duration/2)
                        if self.area_modifier.name == 'Egg Bomb Launcher' then
                            beholder.trigger('SHAKE' .. current_level_id, 3, 0.5)
                        end
                    end
                end

                if self.area_logic.on_hit then
                    beholder.trigger('CREATE AREA' .. current_level_id, x, y, self.area_logic_type, self.area_logic_subtype, self.area_modifier, size_flag)
                    self:collectorAddTimer(main_chrono:after(self.area_logic.duration, function() 
                        self.dead = true 
                    end))
                    if self.area_modifier.name == 'Flamethrower' then
                        beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlameArea', x, y, FLARE_RED_PS)
                    end
                end
            end))

            self:collectorAddMessage(beholder.observe('AREA TYPE SUBTYPE MODIFIER REQUEST' .. self.parent.id, function()
                beholder.trigger('AREA TYPE SUBTYPE MODIFIER REPLY', 
                self.area_logic_type, self.area_logic_subtype, self.area_modifier)
            end))
        else self:logicAreaOnHit() end
        -- Enemy cooldown list
        self.enemies_hit = {}
    end,
    
    addEnemy = function(self, enemy)
        table.insert(self.enemies_hit, {enemy = enemy, time = -100000000})
    end,

    -- Enemies that have been hit recently can't be hit again. This function simply
    -- checks if a certain enemy is on a certain cooldown.
    enemyOnCooldown = function(self, enemy, cooldown)
        for _, e in ipairs(self.enemies_hit) do
            if e.enemy.id == enemy.id then
                if (love.timer.getTime() - e.time) > cooldown then 
                    e.time = love.timer.getTime()
                    return false
                else return true end
            end
        end
    end,

    -- Called on constructor if area has no parent (explodes immediately)
    logicAreaOnHit = function(self)
        beholder.trigger('PLAY SOUND EFFECT', 'explosion')
        self:collectorAddTween(main_tween(self.area_logic.duration, self, {area_color = {32, 32, 32, 255}}, 'inQuart'))
        self:collectorAddTimer(main_chrono:after(self.area_logic.duration, function() 
            self.dead = true 
            local x, y = self.body:getPosition()
            local explosions = {'Explosion1', 'Explosion2', 'Explosion3'}
            if not self.dont_spawn_particles then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, explosions[math.random(1, #explosions)], x, y, {32, 32, 32, 255, 32, 32, 32, 0})
            end
        end))
        self:collectorAddTween(main_tween(self.area_logic.duration, self, 
                                         {radius = self.r_f}, self.area_logic.tween))
    end,

    logicAreaUpdate = function(self, dt)
        if self.parent then
            -- Follow parent
            self.p.x, self.p.y = self.parent.p.x, self.parent.p.y
            -- Fetches projectiles list and looks for parent, if he isn't there the he's dead
            -- and so this area should die (or explode).
            beholder.trigger('PROJECTILES LIST REQUEST' .. current_level_id)
            if not findIndexByID(self.projectiles_list, self.parent.id) then
                if not self.area_logic.on_hit then self.dead = true
                else self.parent = nil end
            end
            self.projectiles_list = nil

            if self.area_logic.on_hit then self.radius = 0 end
        end

        -- Fetches enemies inside this area and applies modifiers accordingly
        beholder.trigger('AREA QUERY REQUEST' .. current_level_id, 'circle', 'enemies', self.p.x, self.p.y, self.radius)
        for _, enemy in ipairs(self.area_query_list) do
            -- Adds enemy to cooldown list if he has not been hit yet
            if not table.containse(self.enemies_hit, enemy) then self:addEnemy(enemy) end

            if self.instant then
                if not self:enemyOnCooldown(enemy, self.instant.cooldown) then
                    if instanceOf(Player, enemy) then
                        if not enemy.invulnerable then
                            beholder.trigger('HIT' .. enemy.id)
                            beholder.trigger('HP DECREASE' .. enemy.id, 1)
                        end
                    else
                        enemy:dealDamage(self.instant.damage)
                    end

                end
            end

            if self.dot then
                enemy:setDot(self.dot.interval, self.dot.times, self.dot.damage)
                if self.area_modifier.name == 'Flamethrower' then
                    enemy:setBurn(self.dot.interval, self.dot.times, self.dot.damage)

                elseif self.area_modifier.name == 'Sludge Bomb' then
                    enemy:setPoison(self.dot.interval, self.dot.times, self.dot.damage)
                end
            end

            if self.slow then
                if not enemy.slowed then
                    enemy:setSlow(self.slow.percentage, self.slow.duration)
                end
            end

            if self.stun then
                enemy:setStun(self.stun)
            end
        end
        self.area_query_list = nil

        self.body:setPosition(self.p.x, self.p.y)
        self.shape:setRadius(self.radius)
    end
}
