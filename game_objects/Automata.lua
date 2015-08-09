Automata = class('Automata', Entity)
Automata:include(Collector)

function Automata:initialize(type, x, y, t_difficulty)
    Entity.initialize(self, x, y)
    self:collectorInit()
    self.type = type
    self.w = 32
    self.h = 32
    self.radius = 40
    self.triggered = false
    self.trigger_color = {128, 128, 128, 255}
    self.attacking_flag = false
    self.difficulty = t_difficulty
    self.r_timer = 0

    if self.type == 'Tiki Trap' then
        if self.difficulty == 'yellow' then
            self.r_timer = math.prandom(2.24, 4.88)
            self:collectorAddTimer(main_chrono:every(0.1, function()
                if self.triggered then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'EnemyHit', x, self.p.y - 24, YELLOW_PS) 
                    beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, self.p.x, self.p.y - 24, math.prandom(-math.pi+math.pi/8, -math.pi/8),
                                     'accelerating', 'slow', {hit_color = YELLOW_PS, color = LIGHT_YELLOW, instant = {damage = 0.25, cooldown = 0.5}, reflecting = 3, pierce = 3})
                end
            end))
        elseif self.difficulty == 'green' then
            self.r_timer = math.prandom(2.77, 4.43)
            self:collectorAddTimer(main_chrono:every(0.05, function()
                if self.triggered then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'EnemyHit', x, self.p.y - 24, R_GREEN_PS) 
                    beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, self.p.x, self.p.y - 24, math.prandom(-math.pi+math.pi/8, -math.pi/8),
                                     'decelerating', 'green', {hit_color = R_GREEN_PS, color = R_GREEN, instant = {damage = 0.5, cooldown = 0.5}})
                end
            end))

        elseif self.difficulty == 'blue' then
            self.r_timer = math.prandom(3.01, 5.02)
            self:collectorAddTimer(main_chrono:every(0.07, function()
                if self.triggered then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'EnemyHit', x, self.p.y - 24, BLUE_PS) 
                    beholder.trigger('CREATE PROJECTILE' .. current_level_id, self, self.p.x, self.p.y - 24, math.prandom(-math.pi/2-math.pi/8, -math.pi/2+math.pi/8),
                                     'boomerang', 'default', {hit_color = BLUE_PS, color = {160, 160, 224, 255}, slow = {percentage = 0.5, duration = 3},
                                                              instant = {damage = 0.1, cooldown = 0.5}, reflecting = 4, gravity = 1.5})
                end
            end))

        elseif self.difficulty == 'red' then
            self.r_timer = math.prandom(5.03, 7.88)
            self:collectorAddTimer(main_chrono:every(0.6, function()
                if self.triggered then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'EnemyHit', x, self.p.y - 24, ENEMY_RED_PS) 
                    beholder.trigger('CREATE PROJECTILE AREA' .. current_level_id, self, self.p.x, self.p.y - 24, math.prandom(-math.pi/2-math.pi/8, -math.pi/2+math.pi/8),
                                     'normal', 'default', {hit_color = ENEMY_RED_PS, color = RED, instant = {damage = 0.5, cooldown = 0.5}, gravity = 2},
                                     'exploding', 'default', {instant = {damage = 5, cooldown = 0.5}})
                end
            end))
        end

        self:collectorAddTimer(main_chrono:every(self.r_timer, function()
            if dice(0.5) then
                if not self.attacking_flag then
                    self.attacking_flag = true
                    -- up
                    if self.difficulty == 'yellow' then
                        self:collectorAddTween(main_tween(1, self, {trigger_color = {255, 255, 182, 255}}, 'outCubic'))
                    elseif self.difficulty == 'green' then
                        self:collectorAddTween(main_tween(1, self, {trigger_color = {182, 255, 182, 255}}, 'outCubic'))
                    elseif self.difficulty == 'blue' then
                        self:collectorAddTween(main_tween(1, self, {trigger_color = {182, 182, 255, 255}}, 'outCubic'))
                    elseif self.difficulty == 'red' then
                        self:collectorAddTween(main_tween(1, self, {trigger_color = {255, 182, 182, 255}}, 'outCubic'))
                    end

                    self:collectorAddTimer(main_chrono:after(1, function()
                        -- on
                        self.triggered = true
                    end):after(1, function() 
                        -- off
                        self.triggered = false
                        -- down
                        self:collectorAddTween(main_tween(1, self, {trigger_color = {128, 128, 128, 255}}, 'outCubic'))
                        self:collectorAddTimer(main_chrono:after(1, function() self.attacking_flag = false end))
                    end))
                end
            end
        end))
    end
end

function Automata:update(dt)
    if self.type == 'Tiki Trap' then

    elseif self.type == 'Sentry' then

    end
end

function Automata:draw()
    if self.type == 'Tiki Trap' then
        --love.graphics.setColorMode('combine')
        love.graphics.setColor(unpack(self.trigger_color))
        love.graphics.draw(environment_32[98], self.p.x - self.w/2, self.p.y - self.h/2)
        --love.graphics.setColorMode('modulate')
        love.graphics.setColor(255, 255, 255, 255)
    elseif self.type == 'Sentry' then
        love.graphics.draw(environment_32[98], self.p.x - self.w/2, self.p.y - self.h/2)
    end
end
