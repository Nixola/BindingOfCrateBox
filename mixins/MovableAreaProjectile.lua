MovableAreaProjectile = {
    movableAreaProjectileInit = function(self, angle, projectile_area_movement_type, projectile_area_movement_subtype)
        self.movement_type = projectile_area_movement_type
        self.movement_subtype = projectile_area_movement_subtype
        self.r = angle
        self.creation_time = love.timer.getTime()

        local projectile_area_movement = projectiles_movement[projectile_area_movement_type][projectile_area_movement_subtype]
        self.v_i = projectile_area_movement.v_i or 0
        self.v_f = projectile_area_movement.v_f or 0
        self.a = projectile_area_movement.a or 0
        self.a_delay = projectile_area_movement.a_delay or 0
        self.time_limit = projectile_area_movement.time_limit
        self.v = self.v_i
        self.over = false
        self.dir = angleToDirection(self.r)
        self.gravity = 0

        if self.time_limit then
            self:collectorAddTimer(main_chrono:after(self.time_limit, function()
                self.dead = true
            end))
        end

        if self.projectile_modifier.gravity then 
            self.body:setGravityScale(self.projectile_modifier.gravity)
            self.gravity = PHYSICS_METER*PHYSICS_GRAVITY*self.projectile_modifier.gravity
            self.body:setLinearVelocity(math.cos(self.r)*self.v, math.sin(self.r)*self.v)
        else self.body:setGravityScale(0) end
    end,

    movableAreaProjectileUpdate = function(self, dt)
        if self.projectile_modifier.name == 'IPECAC' then
            if self.dir == 'left' then self.r = self.r + math.pi*dt
            else self.r = self.r - math.pi*dt end
            self.body:setAngle(self.r)
        end

        self.p.x, self.p.y = self.body:getPosition()
        local x, y = self.body:getLinearVelocity()
        if not self.over then self:move(dt) end
        local vx, vy = x, y

        if self.projectile_modifier.gravity then
            self.body:setLinearVelocity(vx, vy)
        else self.body:setLinearVelocity(math.cos(self.r)*self.v, math.sin(self.r)*self.v) end
    end,

    move = function(self, dt)
        self.v = self.v + self.a*dt
        if self.v_f >= self.v_i then
            if self.v >= self.v_f then 
                self.v = self.v_f
                self.over = true 
            end
        else 
            if self.v <= self.v_f then 
                self.v = self.v_f
                self.over = true 
            end 
        end
    end
}
