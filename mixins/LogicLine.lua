LogicLine = {
    logicLineInit = function(self, world, p1, p2, line_logic_type, line_logic_subtype, line_modifier)
        self.line_logic = lines_logic[line_logic_type][line_logic_subtype]
        self.line_logic_type = line_logic_type
        self.line_logic_subtype = line_logic_subtype
        self.line_modifier = line_modifier
        self.instant = line_modifier.instant
        self.dot = line_modifier.dot
        self.pierce = line_modifier.pierce
        self.slow = line_modifier.slow
        self.stun = line_modifier.stun

        self.world = world
        self.orig_p1 = p1
        self.p1 = p1
        self.orig_p2 = p2
        self.p2 = p2
        self.dir = (p2-p1):angle()
        self.attached = nil
        self.enemies_hit = {}
        self.hit_list = {}
        if self.line_logic.bolt_offset then self:generateBolt(1, self.line_logic.bolt_offset) end
        if self.line_logic.raycast then self:rayCast() end
    end,

    attach = function(self, object)
        self.attached = object
        if self.attached then 
            self.p1.x = self.attached.p.x
            self.p1.y = self.attached.p.y
            self.p2.y = self.attached.p.y
            if self.attached.direction == 'right' then
                self.p1.x = self.orig_p1.x + 3*self.attached.w
                self.p2.x = self.orig_p1.x + 1000
            else 
                self.p1.x = self.orig_p1.x - 3*self.attached.w
                self.p2.x = self.orig_p1.x - 1000 
            end
        end
    end,

    generateBolt = function(self, n, offset)
        self.p_id = 3
        local p1, p2 = id_point(1, self.p1), id_point(2, self.p2)
        self.points = {p1, p2}
        self:generateMidPoints(n, offset, p1, p2)
    end,

    generateMidPoints = function(self, n, offset, p1, p2)
        if n == 0 then return end
        local mid_point = (p1.p+p2.p)/2
        local p3 = id_point(self.p_id, mid_point + (p2.p-p1.p):perpendicular()*math.prandom(-offset, offset))
        self.p_id = self.p_id + 1
        local i = findIndexByID(self.points, p1.id)
        table.insert(self.points, i+1, p3)
        self:generateMidPoints(n-1, offset/2, p1, p3)
        self:generateMidPoints(n-1, offset/2, p3, p2)
    end,

    rayCast = function(self)
        self.hit_list = {}
        if self.p1 and self.p2 then
            self.world:rayCast(self.p1.x, self.p1.y, self.orig_p2.x, self.orig_p2.y, function(fixture, x, y, xn, yn, fraction)
                local hit = {fixture = fixture, x = x, y = y, xn = xn, yn = yn, fraction = fraction}    
                local o = fixture:getUserData()
                table.insert(self.hit_list, hit) 
                return 1
            end)
            self:processHitList()
        end
    end,

    logicLineUpdate = function(self, dt)
        if self.line_logic.raycast then self:rayCast() end
        -- Correct line direction/position based on the attached object
        if self.attached then 
            self.p1.x = self.attached.p.x
            self.p1.y = self.attached.p.y
            self.p2.y = self.attached.p.y
            if self.attached.direction == 'right' then
                self.p1.x = self.orig_p1.x + 3*self.attached.w
                self.p2.x = self.orig_p1.x + 1000
            else 
                self.p1.x = self.orig_p1.x - 3*self.attached.w
                self.p2.x = self.orig_p1.x - 1000 
            end
        end
    end,

    lineLogic = function(self, o, modifiers_only)
        if not modifiers_only then
            if self.line_logic.bolt_offset then self:generateBolt(5, self.line_logic.bolt_offset) end
            if self.line_modifier.name == 'Technology 2' then
                self:collectorAddTimer(main_chrono:after(0.05, function() self.dead = true end)) 
            elseif self.line_modifier.name == 'Technology' or self.line_modifier.name == 'green9090' then
                self:collectorAddTimer(main_chrono:after(0.075, function() self.dead = true end)) 
            elseif self.line_modifier.name == 'Brimstone' then
                self:collectorAddTimer(main_chrono:after(1, function() self.dead = true end)) 
            end
        end

        if instanceOf(Enemy, o) then
            if not table.containse(self.enemies_hit, o) then
                self:addEnemy(o)
                beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'EnemyHit', o.p.x, o.p.y, ENEMY_RED_PS)

                if self.instant then
                    if not self:enemyOnCooldown(o, self.instant.cooldown) then
                        o:dealDamage(self.instant.damage)
                    end
                end
            end
        end
    end,

    processHit = function(self, hit, i)
        if not hit then return end
        local o = hit.fixture:getUserData()

        if instanceOf(Solid, o) then
            if self.line_modifier.name ~= 'Brimstone' then self.p2 = Vector(hit.x, hit.y) end
            self:lineLogic(o)

        elseif instanceOf(Enemy, o) then
            if not self.pierce then self:lineLogic() 
            else
                self.pierce = self.pierce - 1
                if self.pierce >= 0 then
                    local next_hit = self.hit_list[i+2]
                    self:processHit(next_hit, i+2)
                    self:lineLogic(o, true)
                else 
                    self.p2 = Vector(hit.x, hit.y) 
                    self:lineLogic(o) 
                end
            end

        else 
            local next_hit = self.hit_list[i+2]
            self:processHit(next_hit, i+2)
            self:lineLogic() 
        end
    end,

    processHitList = function(self)
        -- Sort hit list based on how close to the initial line point (p1) each hit is on the x axis
        table.sort(self.hit_list, function(a, b)
            local o_a, o_b = a.fixture:getUserData(), b.fixture:getUserData()
            local abs = math.abs
            local p = self.p1.x
            return abs(p-o_a.p.x) < abs(p-o_b.p.x)
        end)

        local hit = self.hit_list[2]
        if hit then self:processHit(hit, 2) end
    end,

    addEnemy = function(self, enemy)
        table.insert(self.enemies_hit, {enemy = enemy, time = -100000000})
    end,

    enemyOnCooldown = function(self, enemy, cooldown)
        for _, e in ipairs(self.enemies_hit) do
            if e.enemy.id == enemy.id then
                if (love.timer.getTime() - e.time) > cooldown then
                    e.time = love.timer.getTime()
                    return false
                else return true end
            end
        end
    end,

    logicLineDraw = function(self)
        -- Draw line
        if self.line_modifier.color then love.graphics.setColor(unpack(self.line_modifier.color))
        else love.graphics.setColor(255, 92, 255) end
        for i = 1, #self.points-1 do
            local p1, p2 = self.points[i].p, self.points[i+1].p
            local m_x, m_y = (p1.x+p2.x)/2, (p1.y+p2.y)/2
            local s_x, s_y = 0, 0
            if self.line_modifier.name == 'Brimstone' then s_x, s_y = (p2-p1):len()/32, self.line_logic.y_scale/128
            else s_x, s_y = (p2-p1):len()/96, self.line_logic.y_scale/128 end
            -- love.graphics.line(p1.x, p1.y, p2.x, p2.y) 
            local r = (p2-p1):angle()
            love.graphics.push()
            love.graphics.translate(m_x, m_y)
            love.graphics.rotate(r)
            love.graphics.translate(-m_x, -m_y)
            love.graphics.draw(light_line, m_x-128*s_x, m_y-64*s_y, 0, s_x, s_y) 
            love.graphics.pop()
        end
        love.graphics.setBlendMode('alpha')
        love.graphics.setColor(255, 255, 255)

        -- Draw hit points
        --[[
        love.graphics.setColor(92, 92, 255)
        love.graphics.circle('line', self.p1.x, self.p1.y, 5)
        for i, hit in ipairs(self.hit_list) do
            love.graphics.circle('line', hit.x, hit.y, 5)
            love.graphics.setColor(255, 255, 255)
        end
        --]]
    end
}
