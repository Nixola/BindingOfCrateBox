FlyingEnemy = class('FlyingEnemy', Entity)
FlyingEnemy:include(Collector)
FlyingEnemy:include(PhysicsRectangle)
FlyingEnemy:include(FlyingBehavior)
FlyingEnemy:include(Steerable)
FlyingEnemy:include(Logic)
FlyingEnemy:include(Stats)

function FlyingEnemy:initialize(world, x, y, hard, type)
    Entity.initialize(self, x, y)
    self.enemy_type = type or 'blue'
    self:collectorInit()
    self:physicsRectangleInit(world, 'dynamic', 18, 18)
    self:flyingBehaviorInit()
    if dice(0.25) then self:steerableInit(0, 0, 200, 400); self:setAngry(2)
    else self:steerableInit(0, 0, 200, 200) end
    if hard then
        self.dying_rgb = {128, 128, 128, 255}
    else
        self.dying_rgb = {255, 255, 255, 255}
    end
    self:logicInit()

    self.hard = hard
    if self.enemy_type == 'blue' then
        if self.hard then self:statsInit({hp = 2}) 
        else self:statsInit({hp = 1}) end
        self.visual = {left = skull_blue_left, right = skull_blue_right}
    elseif self.enemy_type == 'red' then
        if self.hard then self:statsInit({hp = 4})
        else self:statsInit({hp = 2}) end
        self.visual = {left = skull_red_left, right = skull_red_right}
    elseif self.enemy_type == 'black' then
        if self.hard then self:statsInit({hp = 8})
        else self:statsInit({hp = 4}) end
        self.visual = {left = skull_black_left, right = skull_black_right}
    end

    -- Hard enemy's trail
    if self.hard then
        self:collectorAddTimer(main_chrono:every(0.15, function()
            if not self.dying then
                if self.direction == 'right' then
                    beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Up', self, {x = math.prandom(-18/2.5, 18/2.5)-4, y = 18/2-math.random(4)}, DARK_BLUE_PS)
                else
                    beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Up', self, {x = math.prandom(-18/2.5, 18/2.5)-2, y = 18/2-math.random(4)}, DARK_BLUE_PS)
                end
            end
        end))
    end
end

function FlyingEnemy:update(dt)
    local x, y = self.body:getPosition()
    self.p.x, self.p.y = x, y

    if not self.dying then
        self:flyingBehaviorUpdate(dt)
        self:steerableUpdate(dt)
    end
    self:logicUpdate(dt)
end

function FlyingEnemy:draw()
    local x, y = self.body:getPosition()
    local angle = self.body:getAngle()
    if self.hard then love.graphics.setColor(128, 128, 128) end
    if self.angry then
        if self.hard then
            love.graphics.setColor(self.angry_rgb[1]/1.8, self.angry_rgb[2]/1.8, self.angry_rgb[3]/1.8)
        else love.graphics.setColor(unpack(self.angry_rgb)) end
    end
    if self.hit_red then love.graphics.setColor(240, 92, 92) end
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(angle)
    love.graphics.translate(-x, -y)
    if self.dying then
        love.graphics.setColor(unpack(self.dying_rgb))
    end
    love.graphics.draw(self.visual[self.direction], x - 16, y - 16)
    love.graphics.pop()
    self:physicsRectangleDraw()
end

function FlyingEnemy:collisionEnemy(enemy)
    if enemy.burning then
        if fire_spreads then
            self:setDot(0.5, 10, 0.1)
            self:setBurn(0.5, 10, 0.1)
        end
    end

    if self.burning then
        if fire_spreads then
            enemy:setDot(0.5, 10, 0.1)
            enemy:setBurn(0.5, 10, 0.1)
        end
    end
end
