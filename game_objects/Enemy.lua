Enemy = class('Enemy', Entity)
Enemy:include(Collector)
Enemy:include(PhysicsRectangle)
Enemy:include(Behavior)
Enemy:include(Movable)
Enemy:include(Logic)
Enemy:include(PlayerEnemyVisual)
Enemy:include(Stats)

function Enemy:initialize(world, x, y, direction, hard, type)
    Entity.initialize(self, x, y)
    self.enemy_type = type or 'blue'
    self:collectorInit()
    self:physicsRectangleInit(world, 'dynamic', 29, 47)
    self:behaviorInit(direction)
    self:movableInit(SMALL_ENEMYA, SMALL_ENEMY_MAX_VELOCITY, SMALL_ENEMY_GRAVITY_SCALE, 1)
    if hard then
        self.dying_rgb = {colors.gray_mid(1)}
    else
        self.dying_rgb = {colors.white(1)}
    end
    self:logicInit()
    if self.enemy_type == 'blue' then
        self:visualInit({walk_left = blue_zombie_left, walk_right = blue_zombie_right}, 29, 47, 0.15)
        if hard then self:statsInit({hp = 3}) else self:statsInit({hp = 1}) end
    elseif self.enemy_type == 'red' then
        self:visualInit({walk_left = red_zombie_left, walk_right = red_zombie_right}, 29, 47, 0.15)
        if hard then self:statsInit({hp = 5}) else self:statsInit({hp = 2}) end
    elseif self.enemy_type == 'pink' then
        self:visualInit({walk_left = pink_zombie_left, walk_right = pink_zombie_right}, 29, 47, 0.15)
        if hard then self:statsInit({hp = 7}) else self:statsInit({hp = 3}) end
    end

    self.hard = hard
    -- Hard enemy's trail
    if self.hard then
        self:collectorAddTimer(main_chrono:every(0.15, function()
            if not self.dying then
                if self.direction == 'right' then
                    beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Up', self, {x = math.prandom(-SMALL_ENEMYW/2.5, SMALL_ENEMYW/2.5)-4, y = SMALL_ENEMYH/2-math.random(4)}, DARK_BLUE_PS)
                else
                    beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Up', self, {x = math.prandom(-SMALL_ENEMYW/2.5, SMALL_ENEMYW/2.5)-2, y = SMALL_ENEMYH/2-math.random(4)}, DARK_BLUE_PS)
                end
            end
        end))
    end
end

function Enemy:update(dt)
    if not self.dying then
        self:behaviorUpdate(dt)
        self:movableUpdate(dt)
    end
    self:logicUpdate(dt)
    self:visualUpdate(dt)
end

function Enemy:draw()
    local x, y = self.body:getPosition()
    local angle = self.body:getAngle()
    if self.hard then love.graphics.setColor(colors.gray_mid) end
    if self.angry then 
        if self.hard then
            love.graphics.setColor(self.angry_rgb[1]/1.8, self.angry_rgb[2]/1.8, self.angry_rgb[3]/1.8) 
        else love.graphics.setColor(unpack(self.angry_rgb)) end
    end
    if self.hit_red then love.graphics.setColor(colors.enemy.hit_red) end
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(angle)
    love.graphics.translate(-x, -y)
    if self.dying then
        love.graphics.setColor(unpack(self.dying_rgb))
    end
    x, y = x - self.w/2, y - self.h/2
    if self.direction == 'left' then self.walk_left:draw(x, y)
    else self.walk_right:draw(x, y) end
    love.graphics.pop()
    love.graphics.setColor(colors.white)
    self:physicsRectangleDraw()
end

function Enemy:collisionSolid(solid, nx, ny)
    local dir = nil
    if nx < 0 and ny == 0 then dir = 'left'
    elseif nx > 0 and ny == 0 then dir = 'right'
    elseif ny < 0 and nx == 0 then dir = 'up'
    elseif ny > 0 and nx == 0 then dir = 'down' end

    if dir == 'right' and self.behavior_direction == 'LEFT' then
        beholder.trigger('CHANGE DIRECTION' .. self.id)
    elseif dir == 'left' and self.behavior_direction == 'RIGHT' then
        beholder.trigger('CHANGE DIRECTION' .. self.id)
    end
end

function Enemy:collisionEnemy(enemy)
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
