Boss = class('Boss', Entity)
Boss:include(Collector)
Boss:include(PhysicsRectangle)
Boss:include(Logic)
Boss:include(Steerable)
Boss:include(Stats)

function Boss:initialize(world, x, y, type, level)
    Entity.initialize(self, x, y)
    self.boss_type = type
    self.level = level
    self:collectorInit()
    if self.boss_type == 'beholder' then
        self.dead_once = false
        if level == 1 then
            self:physicsRectangleInit(world, 'dynamic', 96, 96)
            self:statsInit({hp = 50})
            self.visual = newAnimation(beholder_boss_128, 136, 128, 0.2, 0)
            self.v = 200
            local angles = {math.pi/4, 3*math.pi/4, -math.pi/4, -3*math.pi/4}
            self.angle = angles[math.random(1, #angles)]
        elseif level == 2 then
            self:physicsRectangleInit(world, 'dynamic', 48, 48)
            self:statsInit({hp = 25})
            self.visual = newAnimation(beholder_boss_64, 68, 64, 0.2, 0)
            self.v = math.random(200, 300)
            local angles = {math.pi/4, 3*math.pi/4, -math.pi/4, -3*math.pi/4}
            self.angle = angles[math.random(1, #angles)]
        elseif level == 3 then
            self:physicsRectangleInit(world, 'dynamic', 24, 24)
            self:statsInit({hp = 15})
            self.visual = newAnimation(beholder_boss_32, 36, 32, 0.2, 0)
            self.v = math.random(250, 400)
            local angles = {math.pi/4, 3*math.pi/4, -math.pi/4, -3*math.pi/4}
            self.angle = angles[math.random(1, #angles)]
        end
    elseif self.boss_type == 'boss_2' then
        self:statsInit({hp = 400})
    elseif self.boss_type == 'boss_3' then
        self:statsInit({hp = 600})
    elseif self.boss_type == 'boss_final' then
        self:statsInit({hp = 1000})
    end
    self.body:setGravityScale(0)
    self:logicInit()
    self.dying_rgb = {255, 255, 255, 255}
end

function Boss:update(dt)
    self:logicUpdate(dt)

    if self.boss_type == 'beholder' then
        self.visual:update(dt)
        local x, y = self.body:getPosition()
        local a, b = self.v*math.cos(self.angle), self.v*math.sin(self.angle)
        local c, d = x + a*dt, y + b*dt
        if c <= 32 or c >= 768 then self.angle = math.pi - self.angle end
        if d <= 32 or d >= 496 then self.angle = -self.angle end
        self.body:setPosition(c, d)
        if self.dying and self.level == 1 and not self.dead_once then 
            self.dead_once = true
            beholder.trigger('CREATE BEHOLDER' .. current_level_id, x + math.random(-32, 32), y + math.random(-32, 32), 2)
            beholder.trigger('CREATE BEHOLDER' .. current_level_id, x + math.random(-32, 32), y + math.random(-32, 32), 2)
            beholder.trigger('CREATE BEHOLDER' .. current_level_id, x + math.random(-32, 32), y + math.random(-32, 32), 2)

        elseif self.dying and self.level == 2 and not self.dead_once then
            self.dead_once = true
            beholder.trigger('CREATE BEHOLDER' .. current_level_id, x + math.random(-32, 32), y + math.random(-32, 32), 3)
            beholder.trigger('CREATE BEHOLDER' .. current_level_id, x + math.random(-32, 32), y + math.random(-32, 32), 3)
            beholder.trigger('CREATE BEHOLDER' .. current_level_id, x + math.random(-32, 32), y + math.random(-32, 32), 3)
        end
    end
end

function Boss:draw()
    if self.boss_type == 'beholder' then 
        local x, y = self.body:getPosition()
        local angle = self.body:getAngle()
        local w, h = 0, 0
        if self.level == 1 then w, h = 136/2, 128/2
        elseif self.level == 2 then w, h = 68/2, 64/2
        elseif self.level == 3 then w, h = 36/2, 32/2 end
        if self.hit_red then love.graphics.setColor(240, 92, 92) end
        love.graphics.push()
        love.graphics.translate(x, y)
        love.graphics.rotate(angle)
        love.graphics.translate(-x, -y)
        if self.dying then
            love.graphics.setColor(unpack(self.dying_rgb))
        end
        self.visual:draw(x - w, y - h)
        love.graphics.pop()
        love.graphics.setColor(255, 255, 255)
        self:physicsRectangleDraw()
    end
end
