Jumper = {
    jumperInit = function(self, jump_a, jumps_left)
        self.jump_a = jump_a
        self.max_jumps = jumps_left
        self.jumps_left = jumps_left 
        self.jump_down = false
        self.on_ground = false
        self.falling = false
        self.jump_normal = Vector(0, 0)

        self:collectorAddMessage(beholder.observe('COLLISION ENTER' .. self.id, function(nx, ny) 
            if ny > 0 then self.on_ground = true; self.jump_down = false end 
        end))

        self:collectorAddMessage(beholder.observe('JUMP PRESSED' .. self.id, function() 
            local x, y = self.body:getLinearVelocity()
            if not self.dashing.left and not self.dashing.right then
                if self.jumps_left >= 1 then 
                    beholder.trigger('PLAY SOUND EFFECT', 'jump')
                    self.jumps_left = self.jumps_left - 1
                    self.on_ground = false
                    self.body:setLinearVelocity(x, self.jump_a)
                end 
            end
        end))
        
        self.hold_to_jump = true
        self:collectorAddMessage(beholder.observe('HOLD TO JUMP REPLY', function(status) self.hold_to_jump = status end))
        self:collectorAddMessage(beholder.observe('JUMP' .. self.id, function() self.jump_down = true end))
        self:collectorAddMessage(beholder.observe('JUMP RELEASED' .. self.id, function() 
            beholder.trigger('HOLD TO JUMP REQUEST')
            if self.hold_to_jump then
                self.jump_down = false 
            end
        end))
    end,

    jumperUpdate = function(self, dt)
        local x, y = self.body:getLinearVelocity() 

        if y > 0 then self.falling = true else self.falling = false end

        -- Stops going up whenever jump key isn't being pressed
        if not self.falling then
            if not self.jump_down then
                self.body:setLinearVelocity(x, 0)
            end
        end

        -- Resets jumps left when on ground
        if self.on_ground then
            self.jumps_left = self.max_jumps
            self.dashes_left = self.max_dashes

            -- Jumps again if jump key is down
            if self.jump_down then
                beholder.trigger('JUMP PRESSED' .. self.id)
            end
        end
    end
}
