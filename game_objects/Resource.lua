Resource = class('Resource', Entity)
Resource:include(Collector)
Resource:include(PhysicsRectangle)

function Resource:initialize(world, type, x, y, api_type, api_name, marketed, no_impulse)
    Entity.initialize(self, x, y)
    self.type = type
    self.no_impulse = no_impulse
    self.marketed = marketed
    if self.marketed then
        self.cost = math.random(cost_tiers[resources[api_name].tier][1], cost_tiers[resources[api_name].tier][2])
    end
    self.api_type = api_type
    self.api_name = api_name
    self.api_color = {128, 128, 128, 255}
    self:collectorInit()
    if self.type ~= 'API' then
        self:physicsRectangleInit(world, 'dynamic', resources[type].w, resources[type].h)
    else
        self:physicsRectangleInit(world, 'dynamic', resources[api_name].w, resources[api_name].h)
    end
    self.fixture:setRestitution(0.5)

    self.creation_time = love.timer.getTime()
    self.inv_time_resource = 0.5
    self.inv_time_api = 1

    -- Visual
    if self.type == 'Chest' then 
        self.chest_opened = false 
        self.visual = resources[type].visual
    end
    if self.type == 'Heart' or self.type == 'HalfHeart' or self.type == 'Mask' or self.type == 'HalfMask' or self.type == 'Surprise' or self.type == 'Bomb' then 
        self.visual = resources[type].visual 
    end
    if self.type == 'BronzeCoin' then
        self.coin_wh = 18
        self.visual = newAnimation(resources[type].visual, 18, 18, 0.1, 0)
        self.visual:setMode("bounce")
    end

    self.tween_api_up = true
    if self.type == 'API' then 
        self.visual = resources[api_name].visual 
        self:collectorAddTimer(main_chrono:every(0.5, function()
            if self.tween_api_up then
                self:collectorAddTween(main_tween(0.5, self,
                {api_color = {222, 222, 222, 255}}, 'linear'))
            else
                self:collectorAddTween(main_tween(0.5, self, 
                {api_color = {128, 128, 128, 255}}, 'linear'))
            end
            self.tween_api_up = not self.tween_api_up
        end))
    end
    
    if not self.no_impulse then
        -- Physics
        if self.type == 'Heart' or self.type == 'HalfHeart' or self.type == 'Mask' or self.type == 'HalfMask' or self.type == 'API' or self.type == 'Surprise' or self.type == 'Bomb' then
            self.body:setFixedRotation(false)
            local directions = {'left', 'right'}
            local direction = directions[math.random(1, 2)]
            local angle = 0
            if direction == 'left' then
                angle = math.prandom(-math.pi/2, -math.pi/12)
                self.body:setLinearVelocity(math.cos(angle)*math.random(100, 300), math.sin(angle)*math.random(100, 300))
                self.body:setAngularVelocity(2*math.pi)
            else 
                angle = math.prandom(-math.pi+math.pi/12, -math.pi/2)
                self.body:setLinearVelocity(math.cos(angle)*math.random(100, 300), math.sin(angle)*math.random(100, 300))
                self.body:setAngularVelocity(-2*math.pi)
            end
            -- self.body:setAngle(angle)

        elseif self.type == 'BronzeCoin' or self.type == 'Chest' then
            self.body:setFixedRotation(true)
            self.body:setGravityScale(2)
            self.fixture:setRestitution(0.25)
            local directions = {'left', 'right'}
            local direction = directions[math.random(1, 2)]
            if direction == 'left' then
                angle = math.prandom(-math.pi/2, -math.pi/12)
                self.body:setLinearVelocity(math.cos(angle)*math.random(100, 300), math.sin(angle)*math.random(100, 300))
            else 
                angle = math.prandom(-math.pi+math.pi/12, -math.pi/2)
                self.body:setLinearVelocity(math.cos(angle)*math.random(100, 300), math.sin(angle)*math.random(100, 300))
            end
        end
    end
end

function Resource:update(dt)
    local x, y = self.body:getPosition()
    if current_map_name == 'scb_red' or current_map_name == 'scb_pink' or current_map_name == 'scb_green' or current_map_name == 'scb_other_red' then
        if x >= 832 then self.body:setX(400); self.body:setY(16) end
        if y >= 544 then
            self.body:setY(16)
            self.body:setX(400)
        elseif y <= -16 then
            self.body:setY(554)
            self.body:setX(chooseWithProb({154, 800-154}, {0.5, 0.5}))
        end
    else
        if x >= 832 then self.body:setX(400); self.body:setY(16) end
        if y >= 544 then
            self.body:setY(16)
        elseif y <= -16 then
            self.body:setY(554)
        end
    end

    if self.type == 'BronzeCoin' then self.visual:update(dt) end
end

function Resource:draw()
    self:physicsRectangleDraw()
    local x, y = self.body:getPosition()
    local angle = self.body:getAngle()
    local sx, sy = 1, 1
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(angle)
    love.graphics.translate(-x, -y)
    local w, h = nil, nil
    if self.type ~= 'BronzeCoin' then
        if self.visual then
            w, h = self.visual:getWidth(), self.visual:getHeight()
        end
    else
        if self.visual then
            w, h = self.coin_wh, self.coin_wh
        end
    end
    x, y = x - w/2, y - h/2
    if self.type == 'Heart' or self.type == 'Mask' or self.type == 'HalfHeart' or 
       self.type == 'HalfMask' or self.type == 'API' or self.type == 'Surprise' or self.type == 'Bomb' then
        if self.type == 'API' then
            love.graphics.setColorMode('combine')
            love.graphics.setColor(unpack(self.api_color))
        end
        love.graphics.draw(self.visual, x, y)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.setColorMode('modulate')
    elseif self.type == 'BronzeCoin' then
        self.visual:draw(x, y)
    elseif self.type == 'Chest' then
        if self.chest_opened then
            love.graphics.draw(chest_open, x, y)
        else
            love.graphics.draw(chest_closed, x, y)
        end
    end
    if self.marketed then
        local ww = UI_TEXT_FONT_24:getWidth('$' .. self.cost)
        x, y = x + w/2 - ww/2, y - 32
        love.graphics.setFont(UI_TEXT_FONT_24)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print('$' .. self.cost, x-1, y-1)
        love.graphics.print('$' .. self.cost, x-1, y+1)
        love.graphics.print('$' .. self.cost, x+1, y-1)
        love.graphics.print('$' .. self.cost, x+1, y+1)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print('$' .. self.cost, x, y)
    end
    love.graphics.pop()
end

function Resource:collisionPlayer(player)
    if self.type == 'BronzeCoin' or self.type == 'Heart' or self.type == 'HalfHeart' or self.type == 'Bomb' or
       self.type == 'HalfMask' or self.type == 'Chest' or self.type == 'Mask' or self.type == 'Surprise' then
        if love.timer.getTime() - self.creation_time < self.inv_time_resource then return end
    else
        if love.timer.getTime() - self.creation_time < self.inv_time_api then return end
    end

    local x, y = self.body:getPosition()

    if self.type == 'BronzeCoin' then
        self.dead = true
        beholder.trigger('PLAY SOUND EFFECT', 'coin')
        if money < 99 then money = money + 1 end
        beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {222, 154, 9, 255, 255, 207, 97, 0})
        beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {255, 207, 97, 255, 222, 154, 9, 0})

    elseif self.type == 'Bomb' then
        self.dead = true
        beholder.trigger('PLAY SOUND EFFECT', 'itemget')
        if bombs < 9 then bombs = bombs + 1 end
        beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {232, 232, 232, 255, 232, 232, 232, 0})
        beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {128, 128, 128, 255, 128, 128, 128, 0})
        beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {64, 64, 64, 255, 64, 64, 64, 0})

    elseif self.type == 'HalfHeart' then
        if player.stats.hp < player.stats.max_hp then
            self.dead = true
            beholder.trigger('PLAY SOUND EFFECT', 'itemget')
            player.stats.hp = player.stats.hp + 0.5
            if player.stats.hp > player.stats.max_hp then player.stats.hp = player.stats.max_hp end
            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {222, 29, 29, 255, 196, 24, 24, 0})
            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {196, 24, 24, 255, 222, 29, 29, 0})
        end

    elseif self.type == 'Heart' then
        if player.stats.hp < player.stats.max_hp then
            self.dead = true
            beholder.trigger('PLAY SOUND EFFECT', 'itemget')
            player.stats.hp = player.stats.hp + 1
            if player.stats.hp > player.stats.max_hp then player.stats.hp = player.stats.max_hp end
            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {222, 29, 29, 255, 196, 24, 24, 0})
            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {196, 24, 24, 255, 222, 29, 29, 0})
        end

    elseif self.type == 'HalfMask' then
        if player.stats.mask < 6 then
            self.dead = true
            beholder.trigger('PLAY SOUND EFFECT', 'itemget')
            player.stats.mask = player.stats.mask + 0.5
            if player.stats.mask > 6 then player.stats.mask = 6 end
            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {230, 230, 230, 255, 219, 219, 219, 0})
            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {219, 219, 219, 255, 178, 178, 178, 0})
            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {178, 178, 178, 255, 219, 219, 219, 0})
        end

    elseif self.type == 'Mask' then
        if player.stats.mask < 6 then
            self.dead = true
            beholder.trigger('PLAY SOUND EFFECT', 'itemget')
            player.stats.mask = player.stats.mask + 1
            if player.stats.mask > 6 then player.stats.mask = 6 end
            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {230, 230, 230, 255, 219, 219, 219, 0})
            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {219, 219, 219, 255, 178, 178, 178, 0})
            beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {178, 178, 178, 255, 219, 219, 219, 0})
        end

    elseif self.type == 'Chest' then
        if not self.chest_opened then
            beholder.trigger('PLAY SOUND EFFECT', 'itemget')
            self.chest_opened = true
            drop(self)
        end

    elseif self.type == 'Surprise' then
        if self.marketed then
            if money >= self.cost then
                money = money - self.cost
            else return end
        end
        local item = chooseWithProb({'Chest', 'API', 'Item', ''}, {0.3, 0.3, 0.3, 0.1})
        self.dead = true
        beholder.trigger('PLAY SOUND EFFECT', 'itemget')
        beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {222, 154, 9, 255, 255, 207, 97, 0})
        beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 207, 97, 255, 222, 154, 9, 0})
        beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 255, 255, 255, 255, 255, 255, 0})
        if current_map_name == 'end' then 
            main_chrono:after(5, function()
                beholder.trigger('END IT ALL')
            end)
            unlockItems()
            return 
        end
        if item == 'Chest' then
            beholder.trigger('CREATE RESOURCE' .. current_level_id, 'Chest', x, y)

        elseif item == 'API' then
            local api = pools['Market'][math.random(1, #pools['Market'])]
            beholder.trigger('CREATE RESOURCE' .. current_level_id, 'API', x, y, api[1], api[2])

        elseif item == 'Item' then
            local it = pools['ChestItem'][math.random(1, #pools['ChestItem'])]
            beholder.trigger('CREATE RESOURCE' .. current_level_id, 'API', x, y, it[1], it[2])
        end

    elseif self.type == 'API' then
        if self.marketed then
            if money >= self.cost then
                money = money - self.cost
            else return end
        end
        if self.api_type == 'Familiar' then
            self.dead = true
            beholder.trigger('PLAY SOUND EFFECT', 'passiveget')
            beholder.trigger('CREATE FAMILIAR' .. current_level_id, self.api_name)
            local w = UI_TEXT_FONT_16:getWidth(self.api_name)
            beholder.trigger('CREATE ITEMGET MOVINGTEXT SMALL' .. current_level_id, self.id, self.api_name, x+self.w/2-w/2, y)
            beholder.trigger('UI TEXT', self.api_type, self.api_name)

            if self.api_name == 'Bicurious' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {242, 140, 51, 255, 242, 140, 51, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {245, 214, 61, 255, 245, 214, 61, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {197, 214, 71, 255, 197, 214, 71, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {121, 194, 103, 255, 121, 194, 103, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {120, 197, 214, 255, 120, 197, 214, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {69, 155, 168, 255, 69, 155, 168, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {191, 98, 166, 255, 191, 98, 166, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {232, 104, 162, 255, 232, 104, 162, 0})

            elseif self.api_name == 'A Better Friend' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {153, 78, 78, 255, 84, 44, 44, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {153, 78, 78, 255, 153, 78, 78, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {214, 214, 137, 255, 214, 214, 137, 0})

            elseif self.api_name == 'A Friend' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {78, 153, 84, 255, 45, 86, 48, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {78, 153, 84, 255, 78, 153, 84, 0})

            elseif self.api_name == 'Flaria' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 187, 0, 255, 255, 38, 0, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 38, 0, 255, 255, 136, 0, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 136, 0, 255, 255, 38, 0, 0})
            end

        elseif self.api_type == 'Attack' then
            self.dead = true
            beholder.trigger('PLAY SOUND EFFECT', 'itemget')
            if player.current_attack then
                beholder.trigger('CREATE RESOURCE' .. current_level_id, 'API', x, y - 32, 
                                 'Attack', player.current_attack.name)
            end
            player.current_attack = table.copy(attacks[self.api_name])
            beholder.trigger('ATTACK CHANGE' .. player.id)
            local w = UI_TEXT_FONT_16:getWidth(self.api_name)
            beholder.trigger('CREATE ITEMGET MOVINGTEXT SMALL' .. current_level_id, self.id, self.api_name, x+self.w/2-w/2, y)
            beholder.trigger('UI TEXT', self.api_type, self.api_name)

            if self.api_name == 'Egg Bomb Launcher' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {250, 173, 191, 255, 216, 108, 131, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {216, 108, 131, 255, 250, 173, 191, 0})

            elseif self.api_name == 'Bubblebeam' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {0, 148, 255, 255, 50, 170, 255, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {50, 170, 255, 255, 89, 185, 255, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {89, 185, 255, 255, 153, 212, 255, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {153, 212, 255, 255, 191, 228, 255, 0})

            elseif self.api_name == 'Razor Leaf' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {42, 142, 72, 255, 25, 95, 43, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {0, 170, 88, 255, 42, 142, 72, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {73, 161, 101, 255, 0, 170, 88, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {121, 190, 145, 255, 73, 161, 101, 0})

            elseif self.api_name == 'Rock Throw' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {114, 107, 126, 255, 177, 153, 152, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {177, 153, 152, 255, 196, 181, 159, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {196, 181, 159, 255, 229, 230, 199, 0})

            elseif self.api_name == 'Ember' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {190, 38, 53, 255, 235, 131, 47, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {235, 131, 47, 255, 247, 219, 107, 0})

            elseif self.api_name == 'Mutant Spider' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {204, 153, 153, 255, 204, 153, 53, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {204, 153, 153, 255, 204, 153, 53, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {153, 199, 203, 255, 153, 199, 203, 0})

            elseif self.api_name == 'Resonance Cascade' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 255, 255, 255, 255, 255, 255, 0})

            elseif self.api_name == 'Psyburst' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {64, 56, 96, 255, 104, 80, 184, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {104, 80, 184, 255, 160, 136, 232, 0})

            elseif self.api_name == 'Sludge Bomb' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {64, 56, 96, 255, 104, 80, 184, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {104, 80, 184, 255, 160, 136, 232, 0})
            end

        elseif self.api_type == 'Passive' then
            self.dead = true
            beholder.trigger('PLAY SOUND EFFECT', 'passiveget')
            table.insert(player.passives, self.api_name)
            passives[self.api_name].action(player)
            local w = UI_TEXT_FONT_16:getWidth(self.api_name)
            beholder.trigger('CREATE ITEMGET MOVINGTEXT SMALL' .. current_level_id, self.id, self.api_name, x+self.w/2-w/2, y)
            beholder.trigger('UI TEXT', self.api_type, self.api_name)

            if self.api_name == 'The Scout' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {201, 61, 52, 255, 201, 61, 52, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {61, 55, 53, 255, 61, 55, 53, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {236, 176, 133, 255, 236, 176, 133, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {185, 162, 166, 255, 185, 162, 166, 0})

            elseif self.api_name == 'Apple' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {204, 52, 14, 255, 228, 91, 50, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {228, 91, 50, 255, 234, 135, 112, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {234, 135, 112, 255, 239, 178, 173, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {161, 199, 66, 255, 209, 245, 116, 0})

            elseif self.api_name == 'Banana' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {251, 194, 0, 255, 244, 167, 0, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 255, 0, 255, 251, 194, 0, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {180, 207, 17, 255, 173, 188, 18, 0})

            elseif self.api_name == 'Bread' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {190, 132, 89, 255, 209, 152, 111, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {209, 152, 111, 255, 223, 173, 137, 0})

            elseif self.api_name == 'Carrot' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {233, 166, 106, 255, 215, 137, 79, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {215, 137, 79, 255, 207, 105, 37, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {161, 199, 66, 255, 209, 245, 116, 0})

            elseif self.api_name == 'Cheese' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 216, 0, 255, 236, 162, 6, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 216, 0, 255, 236, 162, 6, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {248, 193, 4, 255, 224, 130, 7, 0})

            elseif self.api_name == 'Egg' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {227, 212, 188, 255, 247, 244, 225, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {255, 198, 2, 255, 255, 198, 2, 0})

            elseif self.api_name == 'Cherry' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {242, 98, 116, 255, 182, 29, 40, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {242, 98, 116, 255, 182, 29, 40, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {161, 199, 66, 255, 209, 245, 116, 0})

            elseif self.api_name == 'Fish' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {194, 142, 111, 255, 151, 107, 80, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {194, 142, 111, 255, 151, 107, 80, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {210, 159, 112, 255, 185, 127, 89, 0})

            elseif self.api_name == 'Meat' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {167, 108, 79, 255, 167, 108, 79, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {216, 176, 105, 255, 216, 176, 105, 0})

            elseif self.api_name == 'Orange' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 192, 0, 255, 240, 153, 2, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {240, 153, 2, 255, 220, 104, 0, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {161, 199, 66, 255, 209, 245, 116, 0})

            elseif self.api_name == 'Pie' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {190, 132, 89, 255, 209, 152, 111, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {190, 132, 89, 255, 209, 152, 111, 0})

            elseif self.api_name == 'Watermelon' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {211, 57, 78, 255, 211, 57, 78, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {211, 57, 78, 255, 211, 57, 78, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {124, 179, 124, 255, 91, 153, 91, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {87, 19, 29, 255, 87, 19, 29, 0})

            elseif self.api_name == "Jack Sparrow's Heart" then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {231, 154, 92, 255, 203, 125, 83, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {231, 154, 92, 255, 203, 125, 83, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {231, 154, 92, 255, 203, 125, 83, 0})

            elseif self.api_name == "Charon's Obol" then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 223, 74, 255, 255, 210, 0, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 223, 74, 255, 255, 242, 184, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {255, 223, 74, 255, 255, 210, 0, 0})

            elseif self.api_name == 'My Reflection' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 216, 0, 255, 255, 171, 15, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {195, 237, 242, 255, 243, 250, 251, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {195, 237, 242, 255, 243, 250, 251, 0})

            elseif self.api_name == 'Ninja Assassin' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {197, 212, 218, 255, 155, 170, 182, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {210, 159, 112, 255, 210, 159, 112, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {183, 217, 101, 255, 236, 255, 188, 0})

            elseif self.api_name == 'Love' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {249, 201, 238, 255, 251, 230, 246, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {249, 201, 238, 255, 251, 230, 246, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {255, 255, 255, 255, 255, 255, 255, 0})

            elseif self.api_name == 'Book #1' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {116, 101, 101, 255, 116, 101, 101, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {116, 101, 101, 255, 116, 101, 101, 0})

            elseif self.api_name == 'Book #2' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {143, 161, 110, 255, 181, 192, 157, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {251, 185, 56, 255, 238, 223, 189, 0})

            elseif self.api_name == 'Book #3' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {162, 147, 148, 255, 127, 92, 94, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {162, 147, 148, 255, 204, 182, 183, 0})

            elseif self.api_name == 'Book #4' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {135, 117, 118, 255, 81, 78, 93, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {135, 117, 118, 255, 153, 153, 161, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {155, 71, 71, 255, 155, 71, 71, 0})

            elseif self.api_name == 'Book #5' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {116, 166, 215, 255, 167, 205, 236, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {201, 117, 99, 255, 201, 117, 99, 0})

            elseif self.api_name == 'Book #6' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {129, 174, 209, 255, 94, 138, 190, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {129, 174, 209, 255, 176, 222, 240, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {199, 192, 213, 255, 143, 136, 157, 0})

            elseif self.api_name == 'Book #7' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {210, 165, 167, 255, 210, 165, 167, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {210, 165, 167, 255, 210, 165, 167, 0})

            elseif self.api_name == 'The Pentagram' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {192, 0, 9, 255, 255, 174, 17, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {121, 0, 6, 255, 252, 38, 3, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {252, 38, 3, 255, 255, 174, 17, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {252, 38, 3, 255, 255, 120, 3, 0})

            elseif self.api_name == "Legolas' Bow" then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {127, 228, 148, 255, 103, 186, 121, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {103, 186, 121, 255, 53, 155, 76, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {157, 157, 157, 255, 157, 157, 157, 0})

            elseif self.api_name == "Marle's Pendant" then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {63, 182, 185, 255, 81, 229, 220, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {81, 229, 220, 255, 63, 182, 185, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {250, 216, 159, 255, 221, 154, 93, 0})

            elseif self.api_name == "Ayla's Necklace" then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {214, 210, 173, 255, 152, 148, 111, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {214, 210, 173, 255, 240, 240, 236, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {221, 163, 154, 255, 221, 163, 154, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {167, 172, 219, 255, 167, 172, 219, 0})

            elseif self.api_name == 'Not Masamune' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {217, 219, 242, 255, 158, 162, 193, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {217, 219, 242, 255, 158, 162, 193, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {158, 162, 193, 255, 93, 97, 129, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {158, 162, 193, 255, 93, 97, 129, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {110, 110, 110, 255, 110, 110, 110, 0})

            elseif self.api_name == 'Waterbending = Healing' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {208, 183, 246, 255, 208, 183, 246, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {208, 183, 246, 255, 208, 183, 246, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {208, 183, 246, 255, 208, 183, 246, 0})

            elseif self.api_name == "Everything's Okay" then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {250, 210, 101, 255, 250, 210, 101, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {206, 42, 38, 255, 206, 42, 38, 0})

            elseif self.api_name == 'Starshooter' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {115, 156, 175, 255, 163, 204, 223, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {236, 208, 76, 255, 217, 157, 61, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {236, 208, 76, 255, 217, 157, 61, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {236, 208, 76, 255, 255, 250, 222, 0})

            elseif self.api_name == 'Equilibrium Spear' then

            elseif self.api_name == 'Rainbow Dash' then

            elseif self.api_name == 'Cannon Barrage' then

            elseif self.api_name == 'Rare Candy' then

            elseif self.api_name == 'Grog Soaked Spear' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {161, 199, 66, 255, 101, 140, 49, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {161, 199, 66, 255, 209, 245, 116, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {159, 153, 171, 255, 159, 153, 171, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {210, 159, 112, 255, 210, 159, 112, 0})

            elseif self.api_name == 'Enchanted Crystal Spear' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {176, 222, 240, 255, 129, 174, 209, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {129, 174, 209, 255, 94, 138, 190, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {207, 201, 219, 255, 207, 201, 219, 0})

            elseif self.api_name == 'Impervius' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {60, 51, 75, 255, 146, 143, 150, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {139, 165, 167, 255, 191, 208, 209, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {139, 165, 167, 255, 69, 97, 100, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {191, 208, 209, 0, 242, 253, 254, 0})

            elseif self.api_name == 'Chronomage' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {233, 199, 160, 255, 199, 162, 126, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {216, 234, 235, 255, 236, 245, 246, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {216, 234, 235, 255, 236, 245, 246, 0})

            elseif self.api_name == 'Water Automaton' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {99, 99, 163, 255, 99, 99, 163, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {117, 117, 181, 255, 117, 117, 181, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {139, 139, 203, 255, 139, 139, 203, 0})

            elseif self.api_name == 'Fire Automaton' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {163, 99, 99, 255, 163, 99, 99, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {181, 117, 117, 255, 181, 117, 117, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {203, 139, 139, 255, 203, 139, 139, 0})

            elseif self.api_name == 'Air Automaton' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {163, 163, 99, 255, 163, 163, 99, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {181, 181, 117, 255, 181, 181, 117, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {203, 203, 139, 255, 203, 203, 139, 0})

            elseif self.api_name == 'Earth Automaton' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {99, 163, 99, 255, 99, 163, 99, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {117, 181, 117, 255, 117, 181, 117, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {139, 203, 139, 255, 139, 203, 139, 0})

            elseif self.api_name == "JUMP'NSHOOTMAN" then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {33, 235, 214, 255, 33, 235, 214, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {13, 105, 255, 255, 13, 105, 255, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {33, 235, 214, 255, 33, 235, 214, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {13, 105, 255, 255, 13, 105, 255, 0})

            elseif self.api_name == "MOV'NSHOOTMAN" then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {33, 235, 214, 255, 33, 235, 214, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {13, 105, 255, 255, 13, 105, 255, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {33, 235, 214, 255, 33, 235, 214, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {13, 105, 255, 255, 13, 105, 255, 0})

            elseif self.api_name == "DASH'NSHOOTMAN" then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {33, 235, 214, 255, 33, 235, 214, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {13, 105, 255, 255, 13, 105, 255, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {33, 235, 214, 255, 33, 235, 214, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {13, 105, 255, 255, 13, 105, 255, 0})

            elseif self.api_name == 'The Tom Cruise' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {37, 34, 27, 255, 37, 34, 27, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {246, 212, 175, 255, 215, 191, 155, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {215, 191, 155, 255, 246, 212, 175, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {246, 212, 175, 255, 215, 191, 155, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {215, 191, 155, 255, 246, 212, 175, 0})

            elseif self.api_name == 'The Michael Bay' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {234, 153, 134, 255, 234, 153, 134, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {148, 105, 0, 255, 221, 176, 121, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {221, 176, 121, 255, 221, 176, 121, 0})

            elseif self.api_name == 'King of Loss' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {206, 78, 0, 255, 158, 49, 0, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {255, 181, 0, 255, 206, 78, 0, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {255, 181, 0, 255, 255, 119, 0, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {255, 245, 129, 255, 255, 181, 0, 0})

            elseif self.api_name == 'Thick Skin' then 
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {81, 81, 81, 255, 127, 127, 127, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {127, 127, 127, 255, 163, 163, 163, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {163, 163, 163, 255, 201, 201, 201, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {201, 201, 201, 255, 201, 201, 201, 0})

            elseif self.api_name == 'Kiri kiri kiri' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {255, 159, 207, 255, 255, 108, 182, 0})

            elseif self.api_name == 'Ricochet' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {49, 138, 255, 255, 49, 138, 255, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 105, 107, 255, 255, 105, 107, 0})

            elseif self.api_name == 'HL3' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 116, 0, 255, 255, 116, 0, 0})

            elseif self.api_name == 'Gun Kata' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 255, 255, 255, 255, 255, 255, 0})

            elseif self.api_name == 'ASPD' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {220, 220, 220, 255, 152, 152, 152, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {255, 255, 255, 255, 255, 255, 255, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {135, 43, 43, 255, 135, 43, 43, 0})

            elseif self.api_name == 'Fitter, Happier' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {240, 172, 171, 255, 221, 126, 122, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {236, 187, 191, 255, 236, 187, 191, 0})

            elseif self.api_name == 'Gentle Giant' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {72, 153, 68, 255, 72, 153, 68, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {177, 170, 77, 255, 177, 170, 77, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {72, 153, 68, 255, 72, 153, 68, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {190, 136, 154, 255, 198, 136, 154, 0})

            elseif self.api_name == 'Genius, Billionaire, Playboy, Philanthropist' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {182, 135, 43, 255, 182, 135, 43, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {182, 135, 43, 255, 182, 135, 43, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {132, 17, 12, 255, 132, 17, 12, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {205, 215, 216, 255, 205, 215, 216, 0})

            elseif self.api_name == 'Wildfire' then
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {190, 38, 53, 255, 235, 131, 47, 0})
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {235, 131, 47, 255, 247, 219, 107, 0})
            end

        elseif self.api_type == 'Item' then
            if player.current_item then
                self.dead = true
                beholder.trigger('PLAY SOUND EFFECT', 'itemget')

                if player.current_item.name ~= 'Empty' then
                    beholder.trigger('CREATE RESOURCE' .. current_level_id, 'API', x, y - 32, 
                                     'Item', player.current_item.name)
                end

                player.current_item = items[self.api_name]
                local w = UI_TEXT_FONT_16:getWidth(self.api_name)
                beholder.trigger('CREATE ITEMGET MOVINGTEXT SMALL' .. current_level_id, self.id, self.api_name, x+self.w/2-w/2, y)
                beholder.trigger('UI TEXT', self.api_type, self.api_name)

                if self.api_name == "Anivia's R" then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {97, 174, 237, 255, 37, 114, 177, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {37, 114, 177, 255, 97, 174, 237, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {111, 153, 255, 255, 111, 153, 255, 0})

                elseif self.api_name == 'The Joker' then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 187, 0, 255, 255, 38, 0, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 38, 0, 255, 255, 136, 0, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 136, 0, 255, 255, 38, 0, 0})

                elseif self.api_name == 'The Dead Ringer' or self.api_name == 'Invis Watch' then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {86, 42, 37, 255, 86, 42, 37, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {139, 81, 70, 255, 139, 81, 70, 0})

                elseif self.api_name == 'Spider Butt' then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {86, 70, 70, 255, 51, 40, 40, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {51, 40, 40, 255, 86, 70, 70, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {121, 18, 18, 255, 121, 18, 18, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {255, 255, 255, 255, 255, 255, 255, 0})

                elseif self.api_name == 'The Salamanca!' then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {206, 184, 168, 255, 206, 184, 168, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {206, 184, 168, 255, 206, 184, 168, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {229, 134, 71, 255, 229, 134, 71, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {242, 220, 121, 255, 242, 220, 121, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {255, 255, 255, 255, 255, 255, 255, 0})

                elseif self.api_name == "Gangplank's Soul" then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 209, 113, 255, 255, 243, 202, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 209, 113, 255, 216, 126, 0, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {183, 217, 101, 255, 137, 173, 49, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {183, 217, 101, 255, 211, 240, 140, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {255, 255, 255, 255, 255, 255, 255, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {210, 159, 112, 255, 210, 159, 112, 0})

                elseif self.api_name == 'Double Damage' then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {243, 234, 194, 255, 251, 186, 56, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {251, 186, 56, 255, 216, 126, 0, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet3', x, y, {255, 148, 94, 255, 231, 102, 12, 0})

                elseif self.api_name == 'Double Defense' then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {251, 248, 240, 255, 176, 222, 240, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {176, 222, 240, 255, 129, 174, 209, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {187, 178, 218, 255, 140, 122, 171, 0})

                elseif self.api_name == 'Through the Fire and Flames' then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {203, 35, 55, 255, 203, 35, 55, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {203, 35, 55, 255, 203, 35, 55, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {186, 182, 170, 255, 239, 235, 227, 0})

                elseif self.api_name == 'Green Potion' then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {118, 196, 98, 255, 86, 164, 66, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {118, 196, 98, 255, 158, 236, 138, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {186, 208, 240, 255, 227, 234, 244, 0})

                elseif self.api_name == 'Blue Potion' then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {123, 162, 255, 255, 80, 132, 255, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {123, 162, 255, 255, 182, 203, 255, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {186, 208, 240, 255, 227, 234, 244, 0})

                elseif self.api_name == 'Pink Potion' then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {216, 117, 255, 255, 196, 76, 242, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {216, 117, 255, 255, 233, 177, 255, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {186, 208, 240, 255, 227, 234, 244, 0})

                elseif self.api_name == 'Orange Potion' then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 127, 64, 255, 231, 94, 27, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {255, 127, 64, 255, 255, 182, 145, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {186, 208, 240, 255, 227, 234, 244, 0})

                elseif self.api_name == 'Red Potion' then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {220, 83, 16, 255, 192, 0, 9, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {220, 83, 16, 255, 255, 143, 86, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {186, 208, 240, 255, 227, 234, 244, 0})

                elseif self.api_name == 'White Potion' then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {213, 213, 213, 255, 191, 191, 191, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {213, 213, 213, 255, 242, 242, 242, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {186, 208, 240, 255, 227, 234, 244, 0})

                elseif self.api_name == 'Yellow Potion' then
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {221, 157, 1, 255, 179, 127, 1, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y, {221, 157, 1, 255, 255, 200, 66, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y, {186, 208, 240, 255, 227, 234, 244, 0})
                end
            end
        end
    end
end
