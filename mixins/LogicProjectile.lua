LogicProjectile = {
    logicProjectileInit = function(self, parent, projectile_modifier)
        self.parent = parent
        self.projectile_modifier = table.copy(projectile_modifier)
        self.instant = self.projectile_modifier.instant
        self.dot = self.projectile_modifier.dot 
        self.multiple = self.projectile_modifier.multiple 
        self.fork = self.projectile_modifier.fork 
        self.back = self.projectile_modifier.back
        self.pierce = self.projectile_modifier.pierce
        self.reflecting = self.projectile_modifier.reflecting 
        self.slow = self.projectile_modifier.slow 
        self.stun = self.projectile_modifier.stun
        self.gravity = self.projectile_modifier.gravity
        -- See logicArea for explanation.
        self.enemies_hit = {}
    end,

    addEnemy = function(self, enemy)
        table.insert(self.enemies_hit, {enemy = enemy, time = -100000000})
    end,

    -- See logicArea for explanation.
    enemyOnCooldown = function(self, enemy, cooldown)
        for _, e in ipairs(self.enemies_hit) do
            if e.enemy.id == enemy.id then
                if (love.timer.getTime() - e.time) > cooldown then 
                    e.time = love.timer.getTime()
                    return false
                else return true end
            end
        end
    end
}
