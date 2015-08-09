Movable = {
    movableInit = function(self, a, max_v, gravity_scale, max_dashes)
        self.a = a 
        self.init_max_v = max_v
        self.max_v = max_v 
        self.gravity_scale = gravity_scale
        self.moving = {left = false, right = false}
        self.dashing = {left = false, right = false}
        self.collision_pairs = 0
        self.last_n = Vector(0, 0)
        self.side_colliding = {left = false, right = false}
        self.direction = 'right'
        self.dashes_left = max_dashes
        self.max_dashes = max_dashes
        self.pushing = false
        self.can_dash = true

        self.body:setGravityScale(gravity_scale)
        self.body:setFixedRotation(true)
        if instanceOf(Player, self) then self.body:setLinearDamping(1) end

        self:collectorAddMessage(beholder.observe('MOVE LEFT' .. self.id, function() 
            self.moving.left = true 
        end))
        self:collectorAddMessage(beholder.observe('MOVE RIGHT' .. self.id, function() 
            self.moving.right = true 
        end))
        self:collectorAddMessage(beholder.observe('SHIFT PRESSED' .. self.id, function()
            if self.direction == 'right' then
                beholder.trigger('DASH RIGHT PRESSED' .. self.id)
            else
                beholder.trigger('DASH LEFT PRESSED' .. self.id)
            end
        end))
        self:collectorAddMessage(beholder.observe('SHIFT RELEASED' .. self.id, function()
            if self.dashing.left then self.dashing.left = false end
            if self.dashing.right then self.dashing.right = false end
        end))
        self:collectorAddMessage(beholder.observe('DASH LEFT PRESSED' .. self.id, function() 
            if self.dashes_left > 0 then
                if not self.dashing.left then
                    if self.can_dash then
                        beholder.trigger('PLAY SOUND EFFECT', 'dash')
                        self.dashing.left = true 
                        self:collectorAddTimer(main_chrono:after(0.25, function()
                            if self.dashing.left then
                                self.dashing.left = false
                            end
                        end))
                        self:collectorAddTimer(main_chrono:every(0.04, 10, function()
                            if self.dashing.left then
                                self:collectorAddTimer(main_chrono:after(math.prandom(0.01, 0.02), function()
                                    local x, y = self.body:getPosition()
                                    beholder.trigger('CREATE PLAYER SHADOW' .. current_level_id, x, y, 'left')
                                end))
                            end
                        end))
                        self.dashes_left = self.dashes_left - 1
                        if self.dashes_left < 1 then
                            self.can_dash = false
                            self:collectorAddTimer(main_chrono:after(0.5, function()
                                if not self.can_dash then
                                    self.can_dash = true
                                end
                            end))
                        end
                    end
                end
            end
        end))
        self:collectorAddMessage(beholder.observe('DASH RIGHT PRESSED' .. self.id, function() 
            if self.dashes_left > 0 then
                if not self.dashing.left then
                    if self.can_dash then
                        beholder.trigger('PLAY SOUND EFFECT', 'dash')
                        self.dashing.right = true 
                        self:collectorAddTimer(main_chrono:after(0.25, function()
                            if self.dashing.right then
                                self.dashing.right = false
                            end
                        end))
                        self:collectorAddTimer(main_chrono:every(0.04, 10, function()
                            if self.dashing.right then
                                self:collectorAddTimer(main_chrono:after(math.prandom(0.01, 0.02), function()
                                    local x, y = self.body:getPosition()
                                    beholder.trigger('CREATE PLAYER SHADOW' .. current_level_id, x, y, 'right')
                                end))
                            end
                        end))
                        self.dashes_left = self.dashes_left - 1
                        if self.dashes_left < 1 then
                            self.can_dash = false
                            self:collectorAddTimer(main_chrono:after(0.5, function()
                                if not self.can_dash then
                                    self.can_dash = true
                                end
                            end))
                        end
                    end
                end
            end
        end))
        self:collectorAddMessage(beholder.observe('DASH LEFT RELEASED' .. self.id, function()
            if self.dashing.left then
                self.dashing.left = false
            end
        end))
        self:collectorAddMessage(beholder.observe('DASH RIGHT RELEASED' .. self.id, function()
            if self.dashing.right then
                self.dashing.right = false
            end
        end))

        self:collectorAddMessage(beholder.observe('COLLISION ENTER' .. self.id, function(nx, ny) 
            if nx < 0 then self.side_colliding.left = true end
            if nx > 0 then self.side_colliding.right = true end
        end))

        self:collectorAddMessage(beholder.observe('COLLISION EXIT' .. self.id, function(solid) 
            local sx, sy = solid.body:getPosition()
            local x, y = self.body:getPosition()
            if x > sx then self.side_colliding.left = false end
            if x < sx then self.side_colliding.right = false end
        end))
    end,

    push = function(self, v)
        local x, y = self.body:getLinearVelocity()
        if self.direction == 'right' then self.body:setLinearVelocity(-v, y)
        else self.body:setLinearVelocity(v, y) end
        self.pushing = true
    end,

    movableUpdate = function(self, dt)
        if instanceOf(Player, self) then
            -- print(self.collision_pairs, self.side_colliding.left, self.side_colliding.right)
        end
        self.p.x, self.p.y = self.body:getPosition()
        local x, y = self.body:getLinearVelocity()

        if self.moving.left then
            if not self.side_colliding.left then
                self.body:setLinearVelocity(-self.max_v, y)
                self.direction = 'left'
                self.pushing = false
            end
        end

        if self.moving.right then
            if not self.side_colliding.right then
                self.body:setLinearVelocity(self.max_v, y)
                self.direction = 'right'
                self.pushing = false
            end
        end

        if not self.moving.right and not self.moving.left then
            if not self.pushing then
                self.body:setLinearVelocity(0, y)
            end
        end

        self.body:setGravityScale(self.gravity_scale)

        if self.dashing.left then
            if not self.side_colliding.left then
                self.body:setLinearVelocity(-2*self.max_v, 0)
                self.direction = 'left'
                self.pushing = false
            end
        end

        if self.dashing.right then
            if not self.side_colliding.right then
                self.body:setLinearVelocity(2*self.max_v, 0)
                self.direction = 'right'
                self.pushing = false
            end
        end

        if self.dashing.right or self.dashing.left then
            self.body:setGravityScale(0)
        end

        self.moving.left = false
        self.moving.right = false
    end
}
