Stats = {
    statsInit = function(self, stats)
        self.stats = stats
        self.explosion_multiplier = 1
        self.damage_multiplier = 1
        self.cooldown_multiplier = 1
        self.current_projectile_damage = 0
        self.current_area_damage = 0
        self.current_line_damage = 0
        self.current_cooldown = 0

        self:collectorAddMessage(beholder.observe('ATTACK CHANGE' .. self.id, function()
            if self.current_attack then
                if self.current_attack.cooldown then
                    self.current_cooldown = self.current_attack.cooldown
                end
                if self.current_attack.projectile_modifiers then
                    if self.current_attack.projectile_modifiers.instant then
                        self.current_projectile_damage = self.current_attack.projectile_modifiers.instant.damage
                    end
                end
                if self.current_attack.area_modifiers then
                    if self.current_attack.area_modifiers.instant then
                        self.current_area_damage = self.current_attack.area_modifiers.instant.damage
                    end
                end
                if self.current_attack.line_modifiers then
                    if self.current_attack.line_modifiers.instant then
                        self.current_line_damage = self.current_attack.line_modifiers.instant.damage
                    end
                end
            end
        end))

        beholder.trigger('ATTACK CHANGE' .. self.id)
    end,

    statsUpdate = function(self, dt)
        local updated_stats = statsToValues(self.stats)

        -- Speed
        self.init_max_v = updated_stats.speed or 225

        -- Explosion Size
        self.explosion_multiplier = updated_stats.explosion_size or 1
        if instanceOf(Player, self) then
            player_explosion_multiplier = self.explosion_multiplier
        end

        -- Damage
        self.damage_multiplier = updated_stats.damage or 1
        if self.current_attack then
            if self.current_attack.projectile_modifiers then
                if self.current_attack.projectile_modifiers.instant then
                    self.current_attack.projectile_modifiers.instant.damage = self.current_projectile_damage*self.damage_multiplier
                end
            end
            if self.current_attack.area_modifiers then
                if self.current_attack.area_modifiers.instant then
                    self.current_attack.area_modifiers.instant.damage = self.current_area_damage*self.damage_multiplier
                end
            end
            if self.current_attack.line_modifiers then
                if self.current_attack.line_modifiers.instant then
                    self.current_attack.line_modifiers.instant.damage = self.current_line_damage*self.damage_multiplier
                end
            end
        end

        -- Pierce
        if self.current_attack then
            if self.current_attack.projectile_modifiers then
                if self.current_attack.projectile_modifiers.pierce then
                    local p = self.current_attack.projectile_modifiers.pierce
                    if p < self.stats.pierce then self.current_attack.projectile_modifiers.pierce = self.stats.pierce end
                else
                    self.current_attack.projectile_modifiers['pierce'] = self.stats.pierce
                end
            end
            if self.current_attack.line_modifiers then
                if self.current_attack.line_modifiers.pierce then
                    local p = self.current_attack.line_modifiers.pierce
                    if p < self.stats.pierce then self.current_attack.line_modifiers.pierce = self.stats.pierce end
                else
                    self.current_attack.line_modifiers['pierce'] = self.stats.pierce
                end
            end
        end

        -- Reflect
        if self.current_attack then
            if self.current_attack.projectile_modifiers then
                if self.current_attack.projectile_modifiers.reflecting then
                    local r = self.current_attack.projectile_modifiers.reflecting
                    if r < self.stats.reflect then self.current_attack.projectile_modifiers.reflecting = math.ceil(self.stats.reflect/2) end
                else
                    self.current_attack.projectile_modifiers['reflecting'] = math.ceil(self.stats.reflect/2)
                end
            end
        end

        -- Cooldown
        self.cooldown_multiplier = updated_stats.cooldown or 1
        if self.current_attack then
            self.current_attack.cooldown = self.current_cooldown*self.cooldown_multiplier
        end
    end
}
