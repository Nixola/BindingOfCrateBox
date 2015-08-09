Familiar = class('Familiar', Entity)
Familiar:include(Collector)
Familiar:include(PhysicsRectangle)
Familiar:include(Steerable)
Familiar:include(FamiliarVisual)
Familiar:include(LogicActivation)
Familiar:include(Attacker)

function Familiar:initialize(world, parent, type, x, y, kill_after)
    Entity.initialize(self, x, y)
    self.f_type = type
    self.parent = parent
    self.kill_after = kill_after
    self:collectorInit()
    self:physicsRectangleInit(world, 'dynamic', FAMILIARW, FAMILIARH)
    self:steerableInit(0, 0, math.random(200, 600), 5000)
    self:attackerInit()
    self:logicActivationInit()
    self:familiarVisualInit(familiars[type].visual)

    self.duration = duration
    self.last_t = love.timer.getTime()
    self.stopped_duration = math.prandom(0.27, 1.23)
    self.current_attack = table.copy(attacks[familiars[type].attack])
    self.current_behavior = 'arrival'
    self.body:setGravityScale(0)
    self.random_x = math.random(-25, 25)
    self.random_y = math.random(-100, 0)
end

function Familiar:update(dt)
    local x, y = self.body:getPosition()
    self.p = Vector(x, y)
    local vx, vy = self.parent.body:getLinearVelocity()
    if vx ~= 0 then 
        self.current_behavior = 'arrival' 
        self.random_x = math.random(-25, 25)
        self.random_y = math.random(-100, 0)
        self.last_t = love.timer.getTime()
    else
        self.current_behavior = 'arrival' 
        if love.timer.getTime() - self.last_t > self.stopped_duration then
            self.random_x = math.random(-25, 25)
            self.random_y = math.random(-100, 0)
            self.last_t = love.timer.getTime()
        end
    end
    local x_, y_ = self.parent.body:getPosition()
    self.target = Vector(x_ + self.random_x, y_ + self.random_y)
    self:steerableUpdate(dt)
    self.direction = self.parent.direction
end

function Familiar:draw()
    self:familiarVisualDraw()
    self:physicsRectangleDraw()
end

function Familiar:spawnParticleEffectsItem(proj)
    if self.current_item then
        if self.current_item.name == "Anivia's R" then
            beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Blizzard', proj, {x = 0, y = 0}, BLIZZARD_BLUE)
            beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Blizzard', proj, {x = 0, y = 0}, BLIZZARD_GRAY) 
            beholder.trigger('PARTICLE SPAWN FOLLOW' .. current_level_id, 'Blizzard', proj, {x = 0, y = 0}, BLIZZARD_WHITE)
            self.current_item = items['Empty']
        end
    end
end

-- Spawn attack specific particles... Fix this function later!
-- This is here and not on Projectile because I need to access the player's current attack.
-- I could move it there but... :3c 
function Familiar:spawnParticleEffects(proj)
    if self.current_attack then
        if self.current_attack.p_effect then
            -- p_follow = true -> should follow parent, in this case parent = proj
            if self.current_attack.p_follow then
                -- p_interval = 0 -> continuous particle effect
                if self.current_attack.p_interval == 0 then

                -- p_interval != -> particle effect spawned every p_interval seconds
                else
                    if self.current_attack.p_effect == 'Flamethrower' then
                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval*2, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGunTrail', proj.p.x, proj.p.y, FLARE_RED_PS)
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGunTrail', proj.p.x-math.random(4), proj.p.y-math.random(4), FLARE_RED_PS)
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGunTrail', proj.p.x+math.random(4), proj.p.y+math.random(4), FLARE_RED_PS)
                        end))

                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGun', proj.p.x, proj.p.y, FLARE_RED_PS)
                        end))
                    end
                end

            -- p_follow = false -> shouldn't follow parent, just spawn particles in its current position (proj.p.x, .p.y)
            else
                if self.current_attack.p_interval == 0 then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, self.current_attack.p_effect, proj.p.x, proj.p.y, self.current_attack.p_color)
                else
                    if self.current_attack.p_effect == 'Rocket Launcher' then
                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'RocketLauncher1', proj.p.x, proj.p.y, BLIZZARD_BLUE)
                        end))

                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval*2, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'RocketLauncher2', proj.p.x, proj.p.y, BLIZZARD_GRAY)
                        end))

                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval*3, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'RocketLauncher3', proj.p.x, proj.p.y, BLIZZARD_WHITE)
                        end))
                    
                    elseif self.current_attack.p_effect == 'Ember' then
                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval*2, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGunTrail', proj.p.x, proj.p.y, FLARE_RED_PS)
                        end))

                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGun', proj.p.x, proj.p.y, FLARE_RED_PS)
                        end))

                    elseif self.current_attack.p_effect == 'Sludge Bomb' then
                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval*2, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGunTrail', proj.p.x, proj.p.y, IPECAC_PS)
                        end))

                        proj:collectorAddTimer(main_chrono:every(self.current_attack.p_interval, function()
                            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'FlareGun', proj.p.x, proj.p.y, IPECAC_PS)
                        end))
                    end
                end
            end
        end
    end
end

function Familiar:randomize(proj)
    if self.current_attack then
        if self.current_attack.projectile_modifiers then
            if self.current_attack.projectile_modifiers.randomize_v then
                if self.current_attack.name == 'Psyburst' then
                    proj.v = math.prandom(proj.v_i-100, proj.v_i+100)
                    proj.a = math.prandom(proj.a-75, proj.a+75)
                end
            end
        end
    end
end
