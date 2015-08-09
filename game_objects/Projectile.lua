Projectile = class('Projectile', Entity)
Projectile:include(Collector)
Projectile:include(PhysicsRectangle)
Projectile:include(MovableAreaProjectile)
Projectile:include(LogicProjectile)

function Projectile:initialize(world, parent, x, y, angle, projectile_movement_type, projectile_movement_subtype, 
                               projectile_modifier)
    Entity.initialize(self, x, y)    
    self:collectorInit()
    self:physicsRectangleInit(world, 'dynamic', projectile_modifier.width or 8, projectile_modifier.height or 8)
    self:logicProjectileInit(parent, projectile_modifier)
    self:movableAreaProjectileInit(angle, projectile_movement_type, projectile_movement_subtype)

    if self.projectile_modifier.name == 'Sludge Bomb' then
        self.body:setFixedRotation(false)
        self.body:setAngularVelocity(math.random(-2*math.pi, 2*math.pi))
    end

    self.creation_time = love.timer.getTime()
    self.area_info = nil

    self:collectorAddMessage(beholder.observe('AREA TYPE SUBTYPE MODIFIER REPLY', function(type, subtype, modifier)
        self.area_info = {area_logic_type = type, area_logic_subtype = subtype, area_modifier = modifier}
    end))
end

function Projectile:collisionSolid(solid, nx, ny)
    local dir = nil
    if nx < 0 and ny == 0 then dir = 'left'
    elseif nx > 0 and ny == 0 then dir = 'right'
    elseif ny < 0 and nx == 0 then dir = 'up'
    elseif ny > 0 and nx == 0 then dir = 'down' end

    beholder.trigger('PROJECTILE PARTICLE SPAWN' .. current_level_id, 'ProjWallHit', self, dir, self.projectile_modifier.hit_color)

    if self.projectile_modifier.name ~= 'Egg Bomb Launcher' and self.projectile_modifier.name ~= 'Stickybomb Launcher' then
        beholder.trigger('AREA ON HIT' .. self.id, self.p.x, self.p.y)
    end

    if self.projectile_modifier.name == 'Stickybomb Launcher' then
        self.body:setLinearVelocity(0, 0)
        self.body:setGravityScale(0)
    end

    if self.reflecting then 
        local x, y = self.body:getLinearVelocity()

        local dx, dy = 0.75, 0.75
        if self.projectile_modifier.name == 'Egg Bomb Launcher' then dx = 0.9; dy = 0.5 end

        self.reflecting = self.reflecting - 1
        if dir == 'left' or dir == 'right' then 
            self.r = math.pi - self.r 
            self.body:setLinearVelocity(-x*dx, y*dy)
        elseif dir == 'up' or dir == 'down' then 
            self.r = -self.r 
            self.body:setLinearVelocity(x*dx, -y*dy)
        end
        if self.reflecting <= 0 then self.reflecting = nil end
    end

    if not self.reflecting and self.projectile_modifier.name ~= 'Stickybomb Launcher' then self.dead = true end
end

function Projectile:collisionEnemy(enemy)
    if enemy.dying then return end
    if not table.containse(self.enemies_hit, enemy) then

        -- Player projectile effects
        if self.parent then
            if instanceOf(Player, self.parent) then
                if gangplanks_soul then
                    local x, y = enemy.body:getPosition()
                    if dice(item_specific["Gangplank's Soul"].chance*(luck)) then
                        if dice(0.9) then
                            beholder.trigger('CREATE RESOURCE' .. current_level_id, 'BronzeCoin', x, y)
                        else
                            if dice(0.5) then
                                local n = math.random(2, 5)
                                for i = 1, n do
                                    beholder.trigger('CREATE RESOURCE' .. current_level_id, 'BronzeCoin', x, y)
                                end
                            else
                                beholder.trigger('CREATE RESOURCE' .. current_level_id, 'Chest', x, y)
                            end
                        end
                    end
                end

                if vampirism then
                    if self.projectile_modifier then
                        if self.projectile_modifier.instant then
                            vampirism_counter = vampirism_counter + self.projectile_modifier.instant.damage
                            if vampirism_counter > vampirism_limit then
                                vampirism_counter = 0
                                vampirism_limit = math.random(10, 30)
                                local x, y = self.body:getPosition()
                                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {222, 29, 29, 255, 196, 24, 24, 0})
                                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {196, 24, 24, 255, 222, 29, 29, 0})
                                if dice(0.7) then beholder.trigger('CREATE RESOURCE' .. current_level_id, 'HalfHeart', x, y)
                                else beholder.trigger('CREATE RESOURCE' .. current_level_id, 'Heart', x, y) end
                            end
                        end
                    end
                end
            end
        end

        self:addEnemy(enemy)

        beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'EnemyHit', self.p.x, self.p.y, self.projectile_modifier.hit_color)

        if instanceOf(FlyingEnemy, enemy) then
            enemy:applyForce(math.cos(self.r)*self.projectile_modifier.instant.damage*2000, math.sin(self.r)*self.projectile_modifier.instant.damage*2000)
        end

        if self.projectile_modifier.name ~= 'Stickybomb Launcher' then
            beholder.trigger('ENEMY ON HIT' .. self.id, enemy.p.x, enemy.p.y)
        end

        if self.instant then
            if not self:enemyOnCooldown(enemy, self.instant.cooldown) then
                if double_damage then
                    enemy:dealDamage(self.instant.damage*2)
                else enemy:dealDamage(self.instant.damage) end
            end
        end

        if self.dot then
            enemy:setDot(self.dot.interval, self.dot.times, self.dot.damage)
            if self.projectile_modifier.name == 'Ember' or self.projectile_modifier.name == 'Flamethrower' then
                enemy:setBurn(self.dot.interval, self.dot.times, self.dot.damage)
            elseif poison_damage then
                enemy:setPoison(self.dot.interval, self.dot.times, self.dot.damage)
            end
        end

        if self.pierce then
            self.pierce = self.pierce - 1
            if self.pierce <= 0 then self.pierce = nil end
        end

        if self.slow then
            if not enemy.slowed then
                enemy:setSlow(self.slow.percentage, self.slow.duration)
            end
        end

        if self.stun then
            if not enemy.stunned then
                enemy:setStun(self.stun)
            end
        end

        if self.fork then
            local n = self.fork
            local angle = self.r
            beholder.trigger('AREA TYPE SUBTYPE MODIFIER REQUEST' .. self.id)

            if not self.area_info then
                if self.fork == 'up' then
                    local xh, yh = enemy.p.x + math.cos(angle)*enemy.w, enemy.p.y + math.sin(angle)*enemy.h 
                    --[[
                    if not self.pierce then
                        beholder.trigger('CREATE PROJECTILE', self.parent, xh, yh, angle,
                                         self.movement_type, self.movement_subtype, table.keyRemove(self.projectile_modifier, 'fork'))
                    end
                    ]]--
                    if angleToDirection(angle) == 'right' then angle = angle-math.pi/2
                    elseif angleToDirection(angle) == 'left' then angle = angle+math.pi/2 end
                    local xu, yu = enemy.p.x, enemy.p.y + math.sin(angle)*enemy.h
                    beholder.trigger('CREATE PROJECTILE' .. current_level_id, self.parent, xu, yu, angle,
                                     self.movement_type, self.movement_subtype, table.keyRemove(self.projectile_modifier, 'fork'))

                elseif self.fork == 'horizontal' then
                    local x, y = enemy.p.x + math.cos(angle)*enemy.w, enemy.p.y + math.sin(angle)*enemy.h
                    beholder.trigger('CREATE PROJECTILE' .. current_level_id, self.parent, x, y, angle-SPREAD_ANGLE*2,
                                     self.movement_type, self.movement_subtype, table.keyRemove(self.projectile_modifier, 'fork'))
                    beholder.trigger('CREATE PROJECTILE' .. current_level_id, self.parent, x, y, angle+SPREAD_ANGLE*2,
                                     self.movement_type, self.movement_subtype, table.keyRemove(self.projectile_modifier, 'fork'))
                end

            else
                if self.fork == 'up' then
                    local xh, yh = enemy.p.x + math.cos(angle)*enemy.w, enemy.p.y + math.sin(angle)*enemy.h 
                    --[[
                    if not self.pierce then
                        beholder.trigger('CREATE PROJECTILE AREA', self.parent, xh, yh, angle,
                                         self.movement_type, self.movement_subtype, table.keyRemove(self.projectile_modifier, 'fork'),
                                         self.area_info.area_logic_type, self.area_info.area_logic_subtype, self.area_info.area_modifier)
                    end
                    ]]--
                    if angleToDirection(angle) == 'right' then angle = angle-math.pi/2
                    elseif angleToDirection(angle) == 'left' then angle = angle+math.pi/2 end
                    local xu, yu = enemy.p.x, enemy.p.y + math.sin(angle)*enemy.h
                    beholder.trigger('CREATE PROJECTILE AREA' .. current_level_id, self.parent, xu, yu, angle,
                                     self.movement_type, self.movement_subtype, table.keyRemove(self.projectile_modifier, 'fork'),
                                     self.area_info.area_logic_type, self.area_info.area_logic_subtype, self.area_info.area_modifier)

                elseif self.fork == 'horizontal' then
                    local x, y = enemy.p.x + math.cos(angle)*enemy.w, enemy.p.y + math.sin(angle)*enemy.h
                    beholder.trigger('CREATE PROJECTILE AREA' .. current_level_id, self.parent, x, y, angle-SPREAD_ANGLE*2,
                                     self.movement_type, self.movement_subtype, table.keyRemove(self.projectile_modifier, 'fork'),
                                     self.area_info.area_logic_type, self.area_info.area_logic_subtype, self.area_info.area_modifier)
                    beholder.trigger('CREATE PROJECTILE AREA' .. current_level_id, self.parent, x, y, angle+SPREAD_ANGLE*2,
                                     self.movement_type, self.movement_subtype, table.keyRemove(self.projectile_modifier, 'fork'),
                                     self.area_info.area_logic_type, self.area_info.area_logic_subtype, self.area_info.area_modifier)
                end
            end

            self.area_info = nil
        end

        if not self.pierce then self.dead = true end
    end
end

function Projectile:collisionPlayer(player)

end

function Projectile:update(dt)
    self:movableAreaProjectileUpdate(dt)
    -- self:logicUpdate(dt)
    --
    if self.projectile_modifier.name == 'Sludge Bomb' then
        -- self.r = self.body:getAngle()
    end

    if self.projectile_modifier.duration then
        if love.timer.getTime()-self.creation_time >= self.projectile_modifier.duration then
            if self.projectile_modifier.name == 'Egg Bomb Launcher' then
                beholder.trigger('AREA ON HIT' .. self.id, self.p.x, self.p.y)
            end
            self.dead = true
        end
    end

    local x, y = self.body:getPosition()
    if current_map_name == 'scb_red' then
        if y >= 544 then
            self.body:setY(16)
            self.body:setX(400)
        elseif y <= -16 then
            self.body:setY(554)
            self.body:setX(chooseWithProb({154, 800-154}, {0.5, 0.5}))
        end
    elseif current_map_name == 'scb_pink'  or current_map_name == 'scb_green' then
        if y >= 544 then
            self.body:setY(16)
            self.body:setX(400)
        elseif y <= -16 then
            self.body:setY(534)
            self.body:setX(chooseWithProb({96, 800-96}, {0.5, 0.5}))
        end
    else
        if y >= 544 then 
            self.body:setY(16)
        elseif y <= -16 then 
            self.body:setY(544)
        end
    end
end

function Projectile:draw()
    if self.projectile_modifier.color then love.graphics.setColor(self.projectile_modifier.color) end
    local x, y = self.body:getPosition()
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(self.r)
    love.graphics.translate(-x, -y)
    love.graphics.draw(proj, (x-self.w/2)*scale, (y-self.h/2)*scale, 0, 1+((self.w*scale/4)-2)*0.5, 1+((self.h*scale/4)-2)*0.5) 
    love.graphics.pop()
    love.graphics.setColor(255, 255, 255, 255)
    self:physicsRectangleDraw()
end
