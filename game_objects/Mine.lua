Mine = class('Mine', Entity)
Mine:include(Collector)
Mine:include(PhysicsRectangle)
Mine:include(Movable)
Mine:include(Logic)

function Mine:initialize(world, x, y, mine_type)
    Entity.initialize(self, x, y)
    self.mine = mines[mine_type]
    self:collectorInit()
    self:physicsRectangleInit(world, 'dynamic', self.mine.width, self.mine.height)
    self:movableInit(MINEA, MINE_MAX_VELOCITY, MINE_GRAVITY_SCALE)   
    self:logicInit(1)
    
    -- Fix later; create mine logic and add mine types that are triggered by different things:
    -- time based, enemy proximity based, player proximity based, ...
    if self.mine.name == 'Salamanca' then
        self.tick_c = love.timer.getTime()
        self.tick_timer = self.mine.ti/3
        self.tick_rgb = {128, 128, 128}
        self.tick_cid = nil
        self.tick_tid = nil

        beholder.observe('ADD TICK TIMER' .. self.id, function()
            if self.tick_cid then main_chrono:cancel(self.tick_cid) end
            local id = main_chrono:every(self.tick_timer, function()
                self.tick_rgb = {236, 236, 236}
                if self.tick_tid then main_tween.stop(self.tick_tid) end
                local id = main_tween(0.5, self, {tick_rgb = {128, 128, 128}}, 'linear')
                self:collectorAddTween(id)
                self.tick_tid = id
                if self.tick_timer > 0.01 then
                    beholder.trigger('ADD TICK TIMER' .. self.id)
                end
            end)
            self:collectorAddTimer(id)
            self.tick_cid = id.id
            self.tick_timer = self.tick_timer/1.5
            beholder.trigger('ANGLE TEXT POP' .. current_level_id, 'Ding!', self.p.x, self.p.y, math.prandom(math.pi/2-math.pi/4, math.pi/2+math.pi/4))
        end)

        beholder.trigger('ADD TICK TIMER' .. self.id)
    end
end

function Mine:update(dt)
    self:movableUpdate(dt)
    self:logicUpdate(dt) 

    if self.mine.name == 'Salamanca' then
        if love.timer.getTime()-self.tick_c > 3 then 
            self.dead = true 
            beholder.trigger('SHAKE' .. current_level_id, 3, 0.5)
            beholder.trigger('CREATE AREA' .. current_level_id, self.p.x, self.p.y, 'exploding', 'salamanca', {instant = instant(5, 0.5)})
        end
    end
end

function Mine:draw()
    if self.mine.name == 'Salamanca' then
        love.graphics.setColor(255, 255, 255)
        local t = love.timer.getTime()-self.tick_c
        love.graphics.rectangle('line', (self.p.x-self.w-2), (self.p.y-self.h/2-16), 2*self.w, 8) 
        love.graphics.rectangle('fill', (self.p.x-self.w-2), (self.p.y-self.h/2-16), (2*self.w-(t*2*self.w/self.mine.ti)), 8) 
        love.graphics.setColorMode('combine')
        love.graphics.setColor(unpack(self.tick_rgb))
        love.graphics.draw(self.mine.image, (self.p.x - self.w/2), (self.p.y - self.h/2))
        love.graphics.setColorMode('modulate')
        love.graphics.setColor(255, 255, 255)
    end
    self:physicsRectangleDraw()
end
