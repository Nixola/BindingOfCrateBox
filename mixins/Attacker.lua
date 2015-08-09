Attacker = {
    attackerInit = function(self)
        self.current_attack = table.copy(player_attack)
        beholder.trigger('ATTACK CHANGE' .. self.id)

        -- The Beggar's Bazooka
        -- Fix later; make current_attack.control a table and hold control variables 
        -- (such as the ones below) there...
        self.tbb_press = nil
        self.tbb_release = nil
        self.tbb_t = 0

        -- Brimstone
        self.brim_press = nil
        self.brim_release = nil
        self.brim_t = 0
        self.brim_rgb = {128, 128, 128}
    end,

    attack = function(self, activation_type)
        local areaExists = function()
            return self.current_attack.area_logic_type and 
                   self.current_attack.area_logic_subtype
        end

        if activation_type == 'press' then
            if self.current_attack then
                if self.current_attack.name == "The Beggar's Bazooka" then
                    self.tbb_press = love.timer.getTime()

                elseif self.current_attack.name == 'Brimstone' then
                    self.brim_press = love.timer.getTime()
                end
            end
        end

        if activation_type == 'release' then
            if self.current_attack then
                if self.current_attack.name == "The Beggar's Bazooka" then
                    if self.tbb_press then
                        self.tbb_release = love.timer.getTime() - self.tbb_press
                    end
                    self.tbb_press = nil

                    if self.current_attack.control > 0 then
                        local n = self.current_attack.control
                        self:attack('down')
                        self.current_attack.control = self.current_attack.control - 1
                        self:collectorAddTimer(main_chrono:every(self.current_attack.cooldown, n-1, function()
                            self:attack('down')
                            self.current_attack.control = self.current_attack.control - 1
                        end))
                    end

                elseif self.current_attack.name == 'Brimstone' then
                    if self.brim_press then
                        self.brim_release = love.timer.getTime() - self.brim_press
                    end
                    self.brim_press = nil

                    if self.brim_release then
                        if self.brim_release >= self.current_attack.control then
                            self:attack('down')
                        end
                    end
                end
            end
        end

        -- Actual attack (projectile, area creation)
        if self.current_attack.activation == activation_type then
            if instanceOf(Player, self) then beholder.trigger('PLAY SOUND EFFECT', 'attack') end
            -- If invisibility watch is being used and the player attacked
            -- then he should be revealead. Calling useActiveItem while the current item
            -- is the invisibility watch or dead ringer while invisible does that.
            if self.invisible then self:useActiveItem(self.current_item.activation) end

            -- Camera shake
            if self.current_attack.c_chance then
                if dice(self.current_attack.c_chance) then
                    beholder.trigger('SHAKE' .. current_level_id, self.current_attack.c_intensity, self.current_attack.c_duration)
                end
            end

            -- Recoil
            if self.current_attack.recoil then 
                if includes(Movable, self) then
                    self:push(self.current_attack.recoil) 
                end
            end

            -- Exploding shots
            if exploding_shots then
                if self.current_attack then
                    if self.current_attack.name ~= 'Mutant Spider' and self.current_attack.name ~= 'Bubblebeam' and 
                       self.current_attack.name ~= 'Psyburst' and self.current_attack.name ~= 'Resonance Cascade' then
                        if dice(exploding_shots_chance*(luck)) then
                            if not self.current_attack.area_logic_type and not self.current_attack.area_logic_subtype and not self.current_attack.area_modifiers then
                                self.current_attack.area_logic_type = 'exploding'
                                self.current_attack.area_logic_subtype = 'small'
                                self.current_attack.area_modifiers = {instant = {damage = 1, cooldown = 0.5}}
                            end
                        end
                    end
                end
            end

            -- Poisoning shots
            if poison_damage then
                if self.current_attack then
                    if self.current_attack.name ~= 'Mutant Spider' and self.current_attack.name ~= 'Bubblebeam' and 
                       self.current_attack.name ~= 'Psyburst' and self.current_attack.name ~= 'Resonance Cascade' then
                        if dice(poison_chance*(luck)) then
                            if self.current_attack.projectile_modifiers then
                                self.current_attack.projectile_modifiers.dot = {interval = 0.5, times = 4, damage = 0.25}
                            end
                        end
                    end
                end
            end

            -- Slowing shots
            if ice_damage then
                if self.current_attack then
                    if self.current_attack.name ~= 'Mutant Spider' and self.current_attack.name ~= 'Bubblebeam' and 
                       self.current_attack.name ~= 'Psyburst' and self.current_attack.name ~= 'Resonance Cascade' then
                        if dice(slow_chance*(luck)) then
                            if self.current_attack.projectile_modifiers then
                                self.current_attack.projectile_modifiers.slow = {percentage = 0.5, duration = 3}
                            end
                        end
                    end
                end
            end

            -- Stunning shots
            if stun_damage then
                if self.current_attack then
                    if self.current_attack.name ~= 'Mutant Spider' and self.current_attack.name ~= 'Bubblebeam' and 
                       self.current_attack.name ~= 'Psyburst' and self.current_attack.name ~= 'Resonance Cascade' then
                        if dice(stun_chance*(luck)) then
                            if self.current_attack.projectile_modifiers then
                                self.current_attack.projectile_modifiers.stun = 2
                            end
                        end
                    end
                end
            end

            if self.current_attack.projectile_modifiers then
                local create = true
                local name = self.current_attack.projectile_modifiers.name
                if self.direction == 'right' then angle = 0 else angle = math.pi end
                local x = self.p.x + math.cos(angle)*self.w
                if name ~= 'Bicurious' then
                    beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', x, self.p.y, self.direction, self.current_attack.attack_p_color) 
                end

                --[[
                local dmg = 0
                if self.current_attack.projectile_modifiers.instant then
                    dmg = self.current_attack.projectile_modifiers.instant.damage
                    if dmg <= 0.25 then
                        self.current_attack.projectile_modifiers.width = 8
                        self.current_attack.projectile_modifiers.height = 8
                    elseif dmg > 0.25 and dmg <= 0.5 then
                        self.current_attack.projectile_modifiers.width = 10
                        self.current_attack.projectile_modifiers.height = 10
                    elseif dmg > 0.5 and dmg <= 0.75 then
                        self.current_attack.projectile_modifiers.width = 12
                        self.current_attack.projectile_modifiers.height = 12
                    elseif dmg > 0.75 and dmg <= 1 then
                        self.current_attack.projectile_modifiers.width = 12
                        self.current_attack.projectile_modifiers.height = 12
                    elseif dmg > 1 then
                        self.current_attack.projectile_modifiers.width = 16
                        self.current_attack.projectile_modifiers.height = 16
                    end
                end
                ]]--

                if name == 'Bicurious' then
                    create = false
                    local color_i = nil
                    local color_i = math.random(1, #RAINBOW_COLORS)
                    self.current_attack.attack_p_color = RAINBOW_PSS[color_i]
                    self.current_attack.projectile_modifiers.color = RAINBOW_COLORS[color_i]
                    self.current_attack.projectile_modifiers.hit_color = RAINBOW_PSS[color_i]
                    beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', x, self.p.y, self.direction, self.current_attack.attack_p_color) 
                    beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, x, self.p.y, angle-math.pi/18, 
                                     self.current_attack.movement_type, 
                                     self.current_attack.movement_subtype, 
                                     table.copy(self.current_attack.projectile_modifiers))
                    beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, x, self.p.y, angle+math.pi/18, 
                                     self.current_attack.movement_type, 
                                     self.current_attack.movement_subtype, 
                                     table.copy(self.current_attack.projectile_modifiers))

                elseif name == 'Mutant Spider' then
                    create = false
                    local px, py = nil, nil
                    local r, g, b = math.random(240, 254), math.random(240, 254), math.random(240, 254)
                    self.current_attack.attack_p_color = {r, g, b, 255, r, g, b, 0}
                    self.current_attack.projectile_modifiers.color = {r, g, b, 255}
                    self.current_attack.projectile_modifiers.hit_color = {r, g, b, 255, r, g, b, 0}
                    if areaExists() then
                        px = self.p.x + math.cos(angle)*1.5*self.w
                        py = self.p.y + 6
                        beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', px, py, 
                                         self.direction, self.current_attack.attack_p_color) 
                        beholder.trigger('CREATE PROJECTILE AREA' .. current_level_id, self, px, py, angle,
                                         self.current_attack.movement_type,
                                         self.current_attack.movement_subtype,
                                         table.copy(self.current_attack.projectile_modifiers),
                                         self.current_attack.area_logic_type,
                                         self.current_attack.area_logic_subtype,
                                         table.copy(self.current_attack.area_modifiers))
                        py = self.p.y - 6
                        beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', px, py, 
                                         self.direction, self.current_attack.attack_p_color) 
                        beholder.trigger('CREATE PROJECTILE AREA' .. current_level_id, self, px, py, angle,
                                         self.current_attack.movement_type,
                                         self.current_attack.movement_subtype,
                                         table.copy(self.current_attack.projectile_modifiers),
                                         self.current_attack.area_logic_type,
                                         self.current_attack.area_logic_subtype,
                                         table.copy(self.current_attack.area_modifiers))
                        px = self.p.x + math.cos(angle)*self.w
                        py = self.p.y + 12
                        beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', px, py, 
                                         self.direction, self.current_attack.attack_p_color) 
                        beholder.trigger('CREATE PROJECTILE AREA' .. current_level_id, self, px, py, angle,
                                         self.current_attack.movement_type,
                                         self.current_attack.movement_subtype,
                                         table.copy(self.current_attack.projectile_modifiers),
                                         self.current_attack.area_logic_type,
                                         self.current_attack.area_logic_subtype,
                                         table.copy(self.current_attack.area_modifiers))
                        px = self.p.x + math.cos(angle)*self.w
                        py = self.p.y - 12
                        beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', px, py, 
                                         self.direction, self.current_attack.attack_p_color) 
                        beholder.trigger('CREATE PROJECTILE AREA' .. current_level_id, self, px, py, angle,
                                         self.current_attack.movement_type,
                                         self.current_attack.movement_subtype,
                                         table.copy(self.current_attack.projectile_modifiers),
                                         self.current_attack.area_logic_type,
                                         self.current_attack.area_logic_subtype,
                                         table.copy(self.current_attack.area_modifiers))
                    else
                        px = self.p.x + math.cos(angle)*1.5*self.w
                        py = self.p.y + 6
                        beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', px, py, 
                                         self.direction, self.current_attack.attack_p_color) 
                        beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, px, py, angle, 
                                         self.current_attack.movement_type, 
                                         self.current_attack.movement_subtype, 
                                         table.copy(self.current_attack.projectile_modifiers))
                        py = self.p.y - 6
                        beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', px, py, 
                                         self.direction, self.current_attack.attack_p_color) 
                        beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, px, py, angle, 
                                         self.current_attack.movement_type, 
                                         self.current_attack.movement_subtype, 
                                         table.copy(self.current_attack.projectile_modifiers))
                        px = self.p.x + math.cos(angle)*self.w
                        py = self.p.y + 12
                        beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', px, py, 
                                         self.direction, self.current_attack.attack_p_color) 
                        beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, px, py, angle, 
                                         self.current_attack.movement_type, 
                                         self.current_attack.movement_subtype, 
                                         table.copy(self.current_attack.projectile_modifiers))
                        px = self.p.x + math.cos(angle)*self.w
                        py = self.p.y - 12
                        beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', px, py, 
                                         self.direction, self.current_attack.attack_p_color) 
                        beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, px, py, angle, 
                                         self.current_attack.movement_type, 
                                         self.current_attack.movement_subtype, 
                                         table.copy(self.current_attack.projectile_modifiers))
                    end

                elseif name == 'Resonance Cascade' then
                    create = false
                    local px, py = nil, nil
                    local r, g, b = math.random(240, 254), math.random(240, 254), math.random(240, 254)
                    self.current_attack.attack_p_color = {r, g, b, 255, r, g, b, 0}
                    self.current_attack.projectile_modifiers.color = {r, g, b, 255}
                    self.current_attack.projectile_modifiers.hit_color = {r, g, b, 255, r, g, b, 0}
                    if areaExists() then
                        px = self.p.x + math.cos(angle)*1.5*self.w
                        beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', px, self.p.y, 
                                         self.direction, self.current_attack.attack_p_color) 
                        beholder.trigger('CREATE PROJECTILE AREA' .. current_level_id, self, px, self.p.y, angle,
                                         self.current_attack.movement_type,
                                         self.current_attack.movement_subtype,
                                         table.copy(self.current_attack.projectile_modifiers),
                                         self.current_attack.area_logic_type,
                                         self.current_attack.area_logic_subtype,
                                         table.copy(self.current_attack.area_modifiers))
                        px = self.p.x + math.cos(angle)*self.w
                        py = self.p.y + 12
                        beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', px, py, 
                                         self.direction, self.current_attack.attack_p_color) 
                        beholder.trigger('CREATE PROJECTILE AREA' .. current_level_id, self, px, py, angle,
                                         self.current_attack.movement_type,
                                         self.current_attack.movement_subtype,
                                         table.copy(self.current_attack.projectile_modifiers),
                                         self.current_attack.area_logic_type,
                                         self.current_attack.area_logic_subtype,
                                         table.copy(self.current_attack.area_modifiers))
                        px = self.p.x + math.cos(angle)*2*self.w
                        py = self.p.y - 12
                        beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', px, py, 
                                         self.direction, self.current_attack.attack_p_color) 
                        beholder.trigger('CREATE PROJECTILE AREA' .. current_level_id, self, px, py, angle,
                                         self.current_attack.movement_type,
                                         self.current_attack.movement_subtype,
                                         table.copy(self.current_attack.projectile_modifiers),
                                         self.current_attack.area_logic_type,
                                         self.current_attack.area_logic_subtype,
                                         table.copy(self.current_attack.area_modifiers))
                    else
                        px = self.p.x + math.cos(angle)*1.5*self.w
                        beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', px, self.p.y, 
                                         self.direction, self.current_attack.attack_p_color) 
                        beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, px, self.p.y, angle, 
                                         self.current_attack.movement_type, 
                                         self.current_attack.movement_subtype, 
                                         table.copy(self.current_attack.projectile_modifiers))
                        px = self.p.x + math.cos(angle)*self.w
                        py = self.p.y + 12
                        beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', px, py, 
                                         self.direction, self.current_attack.attack_p_color) 
                        beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, px, py, angle, 
                                         self.current_attack.movement_type, 
                                         self.current_attack.movement_subtype, 
                                         table.copy(self.current_attack.projectile_modifiers))
                        px = self.p.x + math.cos(angle)*2*self.w
                        py = self.p.y - 12
                        beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', px, py, 
                                         self.direction, self.current_attack.attack_p_color) 
                        beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, px, py, angle, 
                                         self.current_attack.movement_type, 
                                         self.current_attack.movement_subtype, 
                                         table.copy(self.current_attack.projectile_modifiers))
                    end

                elseif name == 'Ember' then
                    if self.direction == 'right' then angle = angle - SPREAD_ANGLE/1.5 
                    else angle = angle + SPREAD_ANGLE/1.5 end
                
                elseif name == 'Flamethrower' then
                    angle = math.prandom(angle-4*SPREAD_ANGLE, angle+4*SPREAD_ANGLE)

                elseif name == 'Sludge Bomb' then
                    if self.direction == 'right' then angle = angle - math.prandom(SPREAD_ANGLE*6, SPREAD_ANGLE*12)
                    else angle = angle + math.prandom(SPREAD_ANGLE*6, SPREAD_ANGLE*12) end
                    local r, g, b = math.random(77, 97), math.random(54, 74), math.random(106, 126)
                    self.current_attack.attack_p_color = {r, g, b, 255, r, g, b, 0}
                    self.current_attack.projectile_modifiers.color = {r, g, b, 255}
                    self.current_attack.projectile_modifiers.hit_color = {r, g, b, 255, r, g, b, 0}

                elseif name == 'Rock Throw' then
                    if self.direction == 'right' then angle = angle - math.prandom(SPREAD_ANGLE/2, SPREAD_ANGLE*4)
                    else angle = angle + math.prandom(SPREAD_ANGLE/2, SPREAD_ANGLE*4) end

                elseif name == 'Razor Leaf' then
                    if self.direction == 'right' then angle = angle - math.prandom(-SPREAD_ANGLE, SPREAD_ANGLE/4)
                    else angle = angle + math.prandom(-SPREAD_ANGLE, SPREAD_ANGLE/4) end
                    local r, g, b = math.random(25, 88), math.random(98, 206), math.random(78, 98)
                    self.current_attack.attack_p_color = {r, g, b, 255, r, g, b, 0}
                    self.current_attack.projectile_modifiers.color = {r, g, b, 255}
                    self.current_attack.projectile_modifiers.hit_color = {r, g, b, 255, r, g, b, 0}

                elseif name == 'Bubblebeam' then
                    create = false
                    local n = math.random(8, 16)
                    local c = 0
                    for i = 1, 10 do
                        local r = math.prandom(0.02, 0.04)
                        self:collectorAddTimer(main_chrono:after(c+r, function()
                            if instanceOf(Player, self) then beholder.trigger('PLAY SOUND EFFECT', 'attack') end
                            local s_angle = nil
                            if self.direction == 'right' then s_angle = angle - math.prandom(-SPREAD_ANGLE, SPREAD_ANGLE)
                            else s_angle = angle + math.prandom(-SPREAD_ANGLE, SPREAD_ANGLE) end
                            x = self.p.x + math.cos(s_angle)*self.w
                            beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', x, self.p.y, 
                                             self.direction, self.current_attack.attack_p_color) 
                            if poison_damage then
                                if dice(poison_chance*(luck)) then
                                    if self.current_attack.projectile_modifiers then
                                        self.current_attack.projectile_modifiers.dot = {interval = 0.5, times = 4, damage = 0.25}
                                    end
                                end
                            end
                            if ice_damage then
                                if dice(slow_chance*(luck)) then
                                    if self.current_attack.projectile_modifiers then
                                        self.current_attack.projectile_modifiers.slow = {percentage = 0.5, duration = 3}
                                    end
                                end
                            end
                            if stun_damage then
                                if dice(stun_chance*(luck)) then
                                    if self.current_attack.projectile_modifiers then
                                        self.current_attack.projectile_modifiers.stun = 2
                                    end
                                end
                            end
                            if exploding_shots then
                                if dice(exploding_shots_chance*(luck)) then
                                    if not self.current_attack.area_logic_type and not self.current_attack.area_logic_subtype and not self.current_attack.area_modifiers then
                                        self.current_attack.area_logic_type = 'exploding'
                                        self.current_attack.area_logic_subtype = 'small'
                                        self.current_attack.area_modifiers = {instant = {damage = 1, cooldown = 0.5}}
                                    end
                                end
                            end
                            if areaExists() then
                                beholder.trigger('CREATE PROJECTILE AREA' .. current_level_id, self, x, self.p.y, s_angle,
                                                 self.current_attack.movement_type,
                                                 self.current_attack.movement_subtype,
                                                 table.copy(self.current_attack.projectile_modifiers),
                                                 self.current_attack.area_logic_type,
                                                 self.current_attack.area_logic_subtype,
                                                 self.current_attack.area_modifiers)
                            else 
                                beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, x, self.p.y, s_angle, 
                                                 self.current_attack.movement_type, 
                                                 self.current_attack.movement_subtype, 
                                                 table.copy(self.current_attack.projectile_modifiers))
                            end
                        end))
                        c = c + r
                    end

                elseif name == 'Psyburst' then
                    local r, g, b = math.random(77, 97), math.random(54, 74), math.random(106, 126)
                    self.current_attack.attack_p_color = {r, g, b, 255, r, g, b, 0}
                    self.current_attack.projectile_modifiers.color = {r, g, b, 255}
                    self.current_attack.projectile_modifiers.hit_color = {r, g, b, 255, r, g, b, 0}
                    create = false
                    for i = 1, 8 do
                        local s_angle = nil
                        if self.direction == 'right' then s_angle = angle - math.prandom(-SPREAD_ANGLE*3, SPREAD_ANGLE*3)
                        else s_angle = angle + math.prandom(-SPREAD_ANGLE*3, SPREAD_ANGLE*3) end
                        if poison_damage then
                            if dice(poison_chance*(luck)) then
                                if self.current_attack.projectile_modifiers then
                                    self.current_attack.projectile_modifiers.dot = {interval = 0.5, times = 4, damage = 0.25}
                                end
                            end
                        end
                        if ice_damage then
                            if dice(slow_chance*(luck)) then
                                if self.current_attack.projectile_modifiers then
                                    self.current_attack.projectile_modifiers.slow = {percentage = 0.5, duration = 3}
                                end
                            end
                        end
                        if stun_damage then
                            if dice(stun_chance*(luck)) then
                                if self.current_attack.projectile_modifiers then
                                    self.current_attack.projectile_modifiers.stun = 2
                                end
                            end
                        end
                        if exploding_shots then
                            if dice(exploding_shots_chance*(luck)) then
                                if not self.current_attack.area_logic_type and not self.current_attack.area_logic_subtype and not self.current_attack.area_modifiers then
                                    self.current_attack.area_logic_type = 'exploding'
                                    self.current_attack.area_logic_subtype = 'small'
                                    self.current_attack.area_modifiers = {instant = {damage = 1, cooldown = 0.5}}
                                end
                            end
                        end
                        if areaExists() then
                            beholder.trigger('CREATE PROJECTILE AREA' .. current_level_id, self, x, self.p.y, s_angle,
                                             self.current_attack.movement_type,
                                             self.current_attack.movement_subtype,
                                             table.copy(self.current_attack.projectile_modifiers),
                                             self.current_attack.area_logic_type,
                                             self.current_attack.area_logic_subtype,
                                             table.copy(self.current_attack.area_modifiers))
                        else 
                            beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, x, self.p.y, s_angle, 
                                             self.current_attack.movement_type, 
                                             self.current_attack.movement_subtype, 
                                             table.copy(self.current_attack.projectile_modifiers))
                        end
                    end

                elseif name == 'Minigun' or name == 'Natascha' then
                    angle = math.prandom(angle-3*SPREAD_ANGLE, angle+3*SPREAD_ANGLE)

                elseif name == 'Egg Bomb Launcher' or name == 'Stickybomb Launcher' then
                    if self.direction == 'right' then angle = angle - math.prandom(SPREAD_ANGLE*2, SPREAD_ANGLE*4)
                    else angle = angle + math.prandom(SPREAD_ANGLE*2, SPREAD_ANGLE*4) end
                    local r, g, b = math.random(240, 255), math.random(163, 183), math.random(181, 201)
                    self.current_attack.attack_p_color = {r, g, b, 255, r, g, b, 0}
                    self.current_attack.projectile_modifiers.color = {r, g, b, 255}
                    self.current_attack.projectile_modifiers.hit_color = {r, g, b, 255, r, g, b, 0}
                end

                -- Back simply creates an additional projectile in the opposite direction
                -- Same area checks than with multiple...
                if self.current_attack.projectile_modifiers.back then
                    local x = self.p.x + math.cos(math.pi-angle)*self.w
                    beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', x, self.p.y, 
                                     self.direction, self.current_attack.attack_p_color) 
                    if areaExists() then
                        beholder.trigger('CREATE PROJECTILE AREA' .. current_level_id, self, x, self.p.y, math.pi-angle,
                                         self.current_attack.movement_type,
                                         self.current_attack.movement_subtype,
                                         table.copy(self.current_attack.projectile_modifiers),
                                         self.current_attack.area_logic_type,
                                         self.current_attack.area_logic_subtype,
                                         table.copy(self.current_attack.area_modifiers))

                    else
                        beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, x, self.p.y, math.pi-angle, 
                                         self.current_attack.movement_type, 
                                         self.current_attack.movement_subtype, 
                                         table.copy(self.current_attack.projectile_modifiers))
                    end
                end

                -- Normal projectile attack
                if create then
                    if areaExists() then
                        beholder.trigger('CREATE PROJECTILE AREA' .. current_level_id, self, x, self.p.y, angle,
                                         self.current_attack.movement_type,
                                         self.current_attack.movement_subtype,
                                         table.copy(self.current_attack.projectile_modifiers),
                                         self.current_attack.area_logic_type,
                                         self.current_attack.area_logic_subtype,
                                         table.copy(self.current_attack.area_modifiers))
                    else 
                        beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, x, self.p.y, angle, 
                                         self.current_attack.movement_type, 
                                         self.current_attack.movement_subtype, 
                                         table.copy(self.current_attack.projectile_modifiers))
                    end
                end
            end

            if self.current_attack.line_modifiers then
                if self.direction == 'right' then angle = 0 else angle = math.pi end
                local x = self.p.x + math.cos(angle)*self.w
                beholder.trigger('DIRECTIONAL PARTICLE SPAWN' .. current_level_id, 'EnemyHit', x, self.p.y, 
                                 self.direction, self.current_attack.attack_p_color) 
                beholder.trigger('CREATE LINE' .. current_level_id, Vector(x, self.p.y), 
                                 Vector(x+math.cos(angle)*1000, self.p.y), angle,
                                 self.current_attack.line_logic_type, 
                                 self.current_attack.line_logic_subtype, 
                                 self.current_attack.line_modifiers)
            end
        end

        if self.current_attack then
            if self.current_attack.name ~= 'Egg Bomb Launcher' and self.current_attack.name ~= 'Sludge Bomb' and self.current_attack.name ~= "Anivia's R" then
                self.current_attack.area_logic_type = nil
                self.current_attack.area_logic_subtype = nil
                self.current_attack.area_modifiers = nil 
            end

            if self.current_attack.name ~= 'Ember' then
                self.current_attack.projectile_modifiers.dot = nil
            end
            self.current_attack.projectile_modifiers.slow = nil
            self.current_attack.projectile_modifiers.stun = nil
        end
    end,

    attackUpdate = function(self, dt)
        if self.current_attack then
            if self.current_attack.name == "The Beggar's Bazooka" then
                self.tbb_t = 0
                if self.tbb_press then 
                    self.tbb_t = love.timer.getTime() - self.tbb_press
                    if self.tbb_t >= 1 then 
                        self.current_attack.control = self.current_attack.control + 1
                        if self.current_attack.control > 3 then
                            beholder.trigger('HIT' .. self.id)
                            beholder.trigger('HP DECREASE' .. self.id, 1)
                            self.current_attack.control = 0
                        end
                        self.tbb_press = love.timer.getTime()
                        self.tbb_t = 0
                    end
                end

            elseif self.current_attack.name == 'Brimstone' then
                self.brim_t = 0
                self.brim_rgb = {128, 128, 128}
                if self.brim_press then
                    self.brim_t = love.timer.getTime() - self.brim_press
                    if self.brim_t >=1 then self.brim_t = 1 end
                    self.brim_rgb[1] = 128+127*self.brim_t
                    self.brim_rgb[2] = 128-64*self.brim_t
                    self.brim_rgb[3] = 128-64*self.brim_t
                end
            end
        end
    end,

    attackDraw = function(self)
        if self.current_attack then
            if self.current_attack.name == "The Beggar's Bazooka" then
                local d = self.current_attack.activation_delay
                if self.direction == 'right' then
                    love.graphics.rectangle('line', (self.p.x+self.w)*scale, (self.p.y+self.h/2)*scale, 8*scale, -self.h*scale) 
                    love.graphics.rectangle('fill', (self.p.x+self.w)*scale, (self.p.y+self.h/2)*scale, 8*scale, -self.tbb_t*self.h)
                    love.graphics.print(self.current_attack.control, (self.p.x+self.w-1)*scale, (self.p.y-self.h-4)*scale)
                else
                    love.graphics.rectangle('line', (self.p.x-self.w-8)*scale, (self.p.y+self.h/2)*scale, 8*scale, -self.h*scale) 
                    love.graphics.rectangle('fill', (self.p.x-self.w-8)*scale, (self.p.y+self.h/2)*scale, 8*scale, -self.tbb_t*self.h)
                    love.graphics.print(self.current_attack.control, (self.p.x-self.w-9)*scale, (self.p.y-self.h-4)*scale)
                end

            elseif self.current_attack.name == 'Brimstone' then
                --[[
                if self.brim_press then
                    if self.direction == 'right' then
                        love.graphics.rectangle('line', (self.p.x+self.w)*scale, (self.p.y+self.h/2)*scale, 8*scale, -self.h*scale) 
                        love.graphics.rectangle('fill', (self.p.x+self.w)*scale, (self.p.y+self.h/2)*scale, 8*scale, -self.brim_t*self.h)
                    else
                        love.graphics.rectangle('line', (self.p.x-self.w-8)*scale, (self.p.y+self.h/2)*scale, 8*scale, -self.h*scale) 
                        love.graphics.rectangle('fill', (self.p.x-self.w-8)*scale, (self.p.y+self.h/2)*scale, 8*scale, -self.brim_t*self.h)
                    end
                end
                --]]
            end
        end
    end
}
