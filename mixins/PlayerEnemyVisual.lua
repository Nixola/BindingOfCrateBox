PlayerEnemyVisual = {
    visualInit = function(self, animations, w, h, delay)
        self.animations = animations
        self.delay = delay
        self.walk_left = newAnimation(animations.walk_left, w, h, delay, 0)
        self.walk_right = newAnimation(animations.walk_right, w, h, delay, 0)
        if instanceOf(Player, self) then
            self.shoot_left = newAnimation(player_shooting_left, w, h, delay, 0)
            self.shoot_right = newAnimation(player_shooting_right, w, h, delay, 0)
        end
    end,

    visualUpdate = function(self, dt)
        local x, y = self.body:getLinearVelocity()

        -- Velocity based animation speed
        local ratio = math.abs(x/self.init_max_v)
        self.walk_left:setSpeed(ratio)
        self.walk_right:setSpeed(ratio)
        if instanceOf(Player, self) then
            self.shoot_left:setSpeed(ratio)
            self.shoot_right:setSpeed(ratio)
        end

        if x ~= 0 then
            if self.direction == 'left' then self.walk_left:update(dt)
            else self.walk_right:update(dt) end
            if instanceOf(Player, self) then
                if self.attacking then
                    if self.direction == 'left' then self.shoot_left:update(dt)
                    else self.shoot_right:update(dt) end
                end
            end
        else
            if self.direction == 'left' then self.walk_left:seek(1)
            else self.walk_right:seek(1) end
            if instanceOf(Player, self) then
                if self.attacking then
                    if self.direction == 'left' then self.shoot_left:seek(1)
                    else self.shoot_right:seek(1) end
                end
            end
        end
    end,

    visualDraw = function(self)
        local s = 1
        if instanceOf(Enemy, self) then s = 0.75*scale 
        else s = scale end

        local spx, spy = self.p.x*scale, self.p.y*scale
        local sw, sh = self.w*scale/2, self.h*scale/2
        if instanceOf(Enemy, self) then
            if self.direction == 'left' then self.walk_left:draw(spx - sw - 4*scale, spy - sh - 2, 0, s, s)
            else self.walk_right:draw(spx - sw + 4*scale, spy - sh - 2, 0, s, s) end
        else
            local x, y = self.body:getPosition()
            local angle = self.body:getAngle()
            love.graphics.push()
            love.graphics.translate(x, y)
            love.graphics.rotate(angle)
            love.graphics.translate(-x, -y)
            if self.dying then
                love.graphics.setColor(unpack(self.dying_rgb))
            end
            if self.attacking then
                if self.direction == 'left' then self.shoot_left:draw(spx - sw - 4*scale, spy - sh - 2, 0, s, s)
                else self.shoot_right:draw(spx - sw - 6*scale, spy - sh - 2, 0, s, s) end
            else
                if self.direction == 'left' then self.walk_left:draw(spx - sw - 4*scale, spy - sh - 2, 0, s, s)
                else self.walk_right:draw(spx - sw - 6*scale, spy - sh - 2, 0, s, s) end
            end
            love.graphics.pop()
            love.graphics.setColor(255, 255, 255, 255)
        end
    end
}
