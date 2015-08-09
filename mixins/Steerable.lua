-- Requires PhysicsRectangle
Steerable = {
    steerableInit = function(self, angle, v, max_v, max_f)
        self.current_behavior = 'idle'
        self.angle = angle or 0
        self.direction = angleToDirection(angle)
        self.v = Vector(math.cos(angle)*v, math.sin(angle)*v)
        self.init_max_v = max_v or 0
        self.max_v = max_v or 0
        self.max_f = max_f or 0
        self.steering = Vector(0, 0)
        self.steering_force = Vector(0, 0)
        self.applied_force = Vector(0, 0)
        self.applying = false
        self.target = Vector(0, 0)
        self.damping = 0.92
        self.stopping = false
        self.arrival_radius = 25
    end,

    steerableUpdate = function(self, dt)
        -- Only stop if self:steerableStop sets it to true
        -- otherwise reset every frame so the entity can move
        self.stopping = false

        -- Calculate self.steering based on the current behavior
        if self.current_behavior == 'seek' then
            self:steerableSeek(self.target)
        elseif self.current_behavior == 'arrival' then
            self:steerableArrival(self.target)
        elseif self.current_behavior == 'stop' then
            self:steerableStop()
        else

        end

        -- Steer
        self.steering_force = self.steering:min(self.max_f)
        if self.applying then
            self.steering_force = self.applied_force
        end
        self.v = (self.v + self.steering_force*dt):min(self.max_v)
        self.body:setLinearVelocity(self.v.x, self.v.y)
        self.angle = self.v:angle()
        if not self.applying then
            self.direction = angleToDirection(self.angle) or 'right'
        end

        -- Stop movement completely when close to 0
        if self.stopping then
            local vx, vy = math.round(self.v.x, 1), math.round(self.v.y, 1)
            if math.abs(vx) < 5 and math.abs(vy) < 5 then
                self.v.x, self.v.y = 0, 0
            end
        end
    end,

    applyForce = function(self, x, y)
        self.applying = true
        self.applied_force = Vector(x, y)
        self:collectorAddTimer(main_chrono:after(math.abs(x/1000), function()
            if self.applying then
                self.applying = false
            end
        end))
    end,
    
    steerableStop = function(self)
        self.stopping = true 
        self.steering = Vector(0, 0) 
        self.v = self.v*self.damping
    end,

    steerableSeek = function(self, target)
        local position = Vector(self.body:getPosition())
        local desired_velocity = (target - position):normalized()*self.max_v
        local velocity = Vector(self.body:getLinearVelocity())
        self.steering = desired_velocity - velocity
    end,

    steerableArrival = function(self, target)
        local position = Vector(self.body:getPosition())
        local desired_velocity = (target - position)
        local distance = desired_velocity:len()
        if distance < self.arrival_radius then
            self.current_behavior = 'stop'
            desired_velocity = desired_velocity:normalized()*self.max_v*(distance/self.arrival_radius)
        else
            desired_velocity = desired_velocity:normalized()*self.max_v
        end
        local velocity = Vector(self.body:getLinearVelocity())
        self.steering = desired_velocity - velocity
    end,

    steerableDraw = function(self)
        if self.target then
            -- love.graphics.circle('line', self.target.x, self.target.y, self.arrival_radius)
        end
    end
}
