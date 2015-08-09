Logic = {
    logicInit = function(self)
        self.hit_red = false
        -- [a-z]id handlers to take care of repeated/cancelled timers/tweens
        self.dotted = false
        self.dotted_cid = nil
        self.slowed = false
        self.slowed_cid = nil
        self.slowed_pid = nil
        self.stunned = false
        self.stunned_cid = nil
        self.stunned_pid = nil
        self.burning = false
        self.burning_cid = false
        self.poisoned = false
        self.poisoned_cid = false
        self.poisoned_pid = false
        self.angry = false
        self.angry_rgb = {0, 0, 0}
        self.trails = {'Trail1', 'Trail2', 'Trail3'}
        self.alpha = 255
        self.invisible = false
        self.invisible_cid = nil
        self.invisible_tid = nil
        self.invisible_pid = nil
        self.dead_ringer_cid = nil
        self.dying = false

        self:collectorAddMessage(beholder.observe('HP DECREASE' .. self.id, function(damage)
            if damage then 
                if instanceOf(Player, self) then
                    if gentle_giant then damage = math.round(damage*2, 1) end
                    if thick_skinned then damage = math.round(damage/2, 1) end
                    if double_defense then damage = math.round(damage/2, 1) end
                    if damage < 0.5 then damage = 0.5 end
                    self.stats.mask = self.stats.mask - damage 
                    if self.stats.mask < 0 then
                        self.stats.hp = self.stats.hp + self.stats.mask
                        self.stats.mask = 0
                    end
                elseif instanceOf(Enemy, self) or instanceOf(FlyingEnemy, self) or instanceOf(Boss, self) then
                    self.stats.hp = self.stats.hp - damage
                end
            end

            if self.dead then return end
            if self.stats.hp <= 0 then 
                if instanceOf(Enemy, self) or instanceOf(FlyingEnemy, self) or instanceOf(Boss, self) then 
                    if self.hard then beholder.trigger('PLAY SOUND EFFECT', 'enemy_hard_dead')
                    else beholder.trigger('PLAY SOUND EFFECT', 'enemy_dead') end
                    if not self.dying then
                        -- self.dead = true
                        self.dying = true
                        self.body:setFixedRotation(false)
                        self.fixture:setCategory(unpack(collision_masks['Familiar'].categories))
                        self.fixture:setMask(unpack(collision_masks['Familiar'].masks))
                        self.body:setGravityScale(math.prandom(-0.5, 0.5))
                        local direction = chooseWithProb({'left', 'right'}, {0.5, 0.5})
                        local angle = 0
                        if direction == 'left' then
                            angle = math.prandom(-math.pi/2, -math.pi/12)
                            self.body:setLinearVelocity(math.cos(angle)*math.random(25, 75), math.sin(angle)*math.random(25, 75))
                            self.body:setAngularVelocity(math.prandom(0, math.pi))
                        else 
                            angle = math.prandom(-math.pi+math.pi/12, -math.pi/2)
                            self.body:setLinearVelocity(math.cos(angle)*math.random(25, 75), math.sin(angle)*math.random(25, 75))
                            self.body:setAngularVelocity(math.prandom(-math.pi, 0))
                        end
                        -- self.body:setAngle(0) -- this breaks LÖVE for some reason
                        self:collectorAddTween(main_tween(0.75, self, {dying_rgb = {0, 0, 0, 0}}, 'outCubic'))
                        self:collectorAddTimer(main_chrono:after(0.75, function() self.dead = true end))
                        drop(self)
                        beholder.trigger('ENEMY DEAD' .. current_level_id)
                        --[[
                        if self.hard then -- self.hard = hard enemy type
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'EnemyDead', self.p.x, self.p.y, ENEMY_DARK_RED_PS)
                        else beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'EnemyDead', self.p.x, self.p.y, ENEMY_RED_PS) end
                        ]]--
                    end
                -- self.dead gets the entity actually removed from the game... Since we don't that to happen to the player
                -- use self.player_dead instead.
                elseif instanceOf(Player, self) then 
                    if self.stats.mask <= 0 then
                        self.dying = true
                        self.body:setFixedRotation(false)
                        self.fixture:setCategory(unpack(collision_masks['Familiar'].categories))
                        self.fixture:setMask(unpack(collision_masks['Familiar'].masks))
                        self.body:setGravityScale(math.prandom(-0.25, 0.25))
                        local direction = chooseWithProb({'left', 'right'}, {0.5, 0.5})
                        local angle = 0
                        if direction == 'left' then
                            angle = math.prandom(-math.pi/2, -math.pi/12)
                            self.body:setLinearVelocity(math.cos(angle)*math.random(25, 75), math.sin(angle)*math.random(25, 75))
                            self.body:setAngularVelocity(math.prandom(0, math.pi))
                        else 
                            angle = math.prandom(-math.pi+math.pi/12, -math.pi/2)
                            self.body:setLinearVelocity(math.cos(angle)*math.random(25, 75), math.sin(angle)*math.random(25, 75))
                            self.body:setAngularVelocity(math.prandom(-math.pi, 0))
                        end
                        -- self.body:setAngle(0) -- this breaks LÖVE for some reason
                        self:collectorAddTween(main_tween(2, self, {dying_rgb = {0, 0, 0, 0}}, 'outCubic'))
                        self:collectorAddTimer(main_chrono:after(2, function() self.dead = true end))
                        beholder.trigger('DEAD')
                    end
                end
            end
        end))

        self:collectorAddMessage(beholder.observe('HIT RED' .. self.id, function()
            self.hit_red = true
            self:collectorAddTimer(main_chrono:after(0.07, function() self.hit_red = false end))
        end))

        self:collectorAddMessage(beholder.observe('SET EPILEPSY' .. self.id, function()
            self.angry = true
            self:collectorAddTimer(main_chrono:every(0.05, function() self.angry_rgb = {math.random(64, 255), math.random(64, 255), math.random(64, 255)} end))
        end))
    end,

    dealDamage = function(self, value)
        beholder.trigger('HP DECREASE' .. self.id, value)    
        beholder.trigger('HIT RED' .. self.id)
    end,

    setSlow = function(self, value, duration)
        if duration then
            if not self.slowed then
                -- See ItemUser.lua for logic explanation. It's the same here.
                local pid = main_chrono:every(0.05, function()
                    if not self.dying then
                        if self.slowed then
                            beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Slow', self, {x = math.random(-self.w/2, self.w/2), y = math.random(-self.h/2.5, self.h/2.5)}, SLOW_PS)
                        end
                    end
                end)
                self:collectorAddTimer(pid)
                self.slowed_pid = pid.id
                self.slowed = true
                self.max_v = self.init_max_v*value
                local id = main_chrono:after(duration, function() 
                    self.slowed = false
                    self.max_v = self.init_max_v 
                    if self.slowed_pid then main_chrono:cancel(self.slowed_pid) end
                end)
                self:collectorAddTimer(id)
                self.slowed_cid = id.id
            else
                if self.slowed_cid then main_chrono:cancel(self.slowed_cid) end
                if self.slowed_pid then main_chrono:cancel(self.slowed_pid) end
                local id = main_chrono:after(duration, function()
                    self.slowed = false
                    self.max_v = self.init_max_v
                end)
                self:collectorAddTimer(id)
                self.slowed_cid = id.id
            end
        else self.max_v = self.init_max_v*value end
    end,

    setStun = function(self, duration)
        if duration then
            if not self.stunned then
                -- See ItemUser.lua for logic explanation. It's the same here.
                local pid = main_chrono:every(0.05, function()
                    if not self.dying then
                        if self.stunned then
                            beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Slow', self, {x = math.random(-self.w/2, self.w/2), y = math.random(-self.h/2, self.h/2)}, STUN_PS1)
                            beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Slow', self, {x = math.random(-self.w/2, self.w/2), y = math.random(-self.h/2, self.h/2)}, STUN_PS2)
                            beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Slow', self, {x = math.random(-self.w/2, self.w/2), y = math.random(-self.h/2, self.h/2)}, STUN_PS3)
                        end
                    end
                end)
                self:collectorAddTimer(pid)
                self.stunned_pid = pid.id
                self.stunned = true
                self.can_move = false
                local id = main_chrono:after(duration, function() 
                    self.stunned = false
                    self.can_move = true
                    if self.stunned_pid then main_chrono:cancel(self.stunned_pid) end
                end)
                self:collectorAddTimer(id)
                self.stunned_cid = id.id
            else 
                main_chrono:cancel(self.stunned_cid)
                local id = main_chrono:after(duration, function()
                    self.stunned = false
                    self.can_move = true
                    if self.stunned_pid then main_chrono:cancel(self.stunned_pid) end
                end)
                self:collectorAddTimer(id)
                self.stunned_cid = id.id
            end

        else
            self.stunned = true
            self.can_move = false
        end
    end,

    setDot = function(self, interval, times, damage)
        if not self.dotted then
            -- See ItemUser.lua for logic explanation. It's the same here.
            self.dotted = true
            local id = main_chrono:every(interval, times, function()
                self:dealDamage(damage)
            end):after(interval*times, function() self.dotted = false end)
            self:collectorAddTimer(id)
            self.dotted_cid = id.id
        else
            self.dotted = true
            main_chrono:cancel(self.dotted_cid)
            local id = main_chrono:every(interval, times, function()
                self:dealDamage(damage)
            end):after(interval*times, function() self.dotted = false end)
            self:collectorAddTimer(id)
            self.dotted_cid = id.id
        end
    end,

    setBurn = function(self, interval, times, damage)
        if not self.burning then
            self.burning = true
            local id = main_chrono:after(interval*times, function()
                self.burning = false 
            end)
            self:collectorAddTimer(id)
            self.burning_cid = id.id
        else
            self.burning = true
            main_chrono:cancel(self.burning_cid)
            local id = main_chrono:after(interval*times, function()
                self.burning = false 
            end)
            self:collectorAddTimer(id)
            self.burning_cid = id.id
        end
    end,

    setPoison = function(self, interval, times, damage)
        if not self.poisoned then
            local pid = main_chrono:every(0.05, function()
                if not self.dying then
                    if self.poisoned then
                        if self.direction == 'right' then
                            beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Slow', self, {x = math.random(-self.w/2, self.w/2)-4, y = math.random(-self.h/2.5, self.h/2.5)}, IPECAC_PS)
                        else beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Slow', self, {x = math.random(-self.w/2, self.w/2), y = math.random(-self.h/2.5, self.h/2.5)}, IPECAC_PS) end
                    end
                end
            end)
            self:collectorAddTimer(pid)
            self.poisoned_pid = pid.id
            self.poisoned = true
            local id = main_chrono:after(interval*times, function()
                self.poisoned = false 
            end)
            self:collectorAddTimer(id)
            self.poisoned_cid = id.id
        else
            self.poisoned = true
            main_chrono:cancel(self.poisoned_cid)
            local id = main_chrono:after(interval*times, function()
                self.poisoned = false 
            end)
            self:collectorAddTimer(id)
            self.poisoned_cid = id.id
        end
    end,

    -- Multiplies entity's normal speed by 'speed', adds a trail and sets random colors.
    -- Should be used for enemies only.
    setAngry = function(self, speed)
        if self.angry then return end
        self.init_max_v = speed*self.init_max_v
        beholder.trigger('SET EPILEPSY' .. self.id)
        self:collectorAddTimer(main_chrono:every(0.05, function() 
            local r1, g1, b1, a1 = math.random(128, 255), math.random(128, 255), math.random(128, 255), 255
            local r2, g2, b2, a2 = math.random(128, 255), math.random(128, 255), math.random(128, 255), 0
            local c = {r1, g1, b1, a1, r2, g2, b2, a2} 
            local trail = self.trails[math.random(1, #self.trails)]
            if not self.dying then
                if self.direction == 'right' then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, trail, self.p.x+math.cos(0)*self.w/2, math.random(self.p.y-self.h/2, self.p.y+self.h/2), c)
                else 
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, trail, self.p.x+math.cos(math.pi)*self.w/2, math.random(self.p.y-self.h/2, self.p.y+self.h/2), c) 
                end
            end
        end))
    end,

    logicUpdate = function(self, dt)
        local x, y = self.body:getPosition()
        if not self.slowed then self.max_v = self.init_max_v end
        if not self.stunned then self.stunned = false; self.can_move = true end

        if self.burning then 
            if not self.dying then
                if self.direction == 'right' then
                    beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Up', self, {x = math.prandom(-self.w/2.5, self.w/2.5)-4, y = self.h/2-math.random(4)}, FLARE_RED_PS)
                else beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Up', self, {x = math.prandom(-self.w/2.5, self.w/2.5)-2, y = self.h/2-math.random(4)}, FLARE_RED_PS) end
            end
        end

        -- Screen pass through
        if instanceOf(FlyingEnemy, self) then return end
        if instanceOf(Boss, self) then return end
        if current_map_name == 'scb_red'  or current_map_name == 'scb_pink' or current_map_name == 'scb_green' or current_map_name == 'scb_other_red' then
            if x >= 832 then self.body:setX(400); self.body:setY(16) end
            if y >= 544 and not self.dying then 
                self.body:setY(16)
                self.body:setX(400)
                if instanceOf(Enemy, self) then 
                    if dice(0.5*(0.0888889*difficulty + 0.911111)) then self:setAngry(1.5) end
                end
            elseif y <= -16 and not self.dying then 
                self.body:setY(544)
                self.body:setX(chooseWithProb({154, 800-154}, {0.5, 0.5}))
            elseif y >= 600 and self.dying then self.dead = true
            elseif y <= -64 and self.dying then self.dead = true end
        else
            if x >= 832 then self.body:setX(400); self.body:setY(16) end
            if y >= 544 and not self.dying then 
                self.body:setY(16)
                if instanceOf(Enemy, self) then 
                    if dice(0.5*(0.0888889*difficulty + 0.911111)) then self:setAngry(1.5) end
                end
            elseif y <= -16 and not self.dying then 
                self.body:setY(544)
            elseif y >= 600 and self.dying then self.dead = true
            elseif y <= -64 and self.dying then self.dead = true end
        end
    end
}
