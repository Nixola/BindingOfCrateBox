Spawner = class('Spawner', Entity)
Spawner:include(Collector)

function Spawner:initialize(name, x, y)
    Entity.initialize(self, x, y)
    self.name = name
    self:collectorInit()

    self.d1_normal_t = 0
    self.d1_next_normal_t = math.prandom(2, 4)
    self.d1_hard_t = 0
    self.d1_next_hard_t = math.prandom(4, 8)
    self.d2_normal_t = 0
    self.d2_next_normal_t = math.prandom(2, 4)
    self.d2_hard_t = 0
    self.d2_next_hard_t = math.prandom(4, 8)
    self.d3_normal_t = 0
    self.d3_next_normal_t = math.prandom(1.8, 3.5)
    self.d3_hard_t = 0
    self.d3_next_hard_t = math.prandom(3.6, 7.2)
    self.d4_normal_t = 0
    self.d4_next_normal_t = math.prandom(1.8, 3.5)
    self.d4_hard_t = 0
    self.d4_next_hard_t = math.prandom(3.6, 7.2)
    self.d5_normal_t = 0
    self.d5_next_normal_t = math.prandom(1.6, 3)
    self.d5_hard_t = 0
    self.d5_next_hard_t = math.prandom(3.2, 6.4)
    self.d6_normal_t = 0
    self.d6_next_normal_t = math.prandom(1.6, 3)
    self.d6_hard_t = 0
    self.d6_next_hard_t = math.prandom(3.2, 6.4)
    self.d7_normal_t = 0
    self.d7_next_normal_t = math.prandom(1.4, 2.5)
    self.d7_hard_t = 0
    self.d7_next_hard_t = math.prandom(2.8, 5.6)
    self.d8_normal_t = 0
    self.d8_next_normal_t = math.prandom(1.4, 2.5)
    self.d8_hard_t = 0
    self.d8_next_hard_t = math.prandom(2.8, 5.6)

    -- Make it harder later maybe
    self.d9_normal_t = 0
    self.d9_next_normal_t = math.prandom(1.2, 2)
    self.d9_hard_t = 0
    self.d9_next_hard_t = math.prandom(2.4, 4.8)
    self.d10_normal_t = 0
    self.d10_next_normal_t = math.prandom(1, 1.5)
    self.d10_hard_t = 0
    self.d10_next_hard_t = math.prandom(2, 4)

    self.dfinal_normal_t = 0
    self.dfinal_next_normal_t = math.prandom(1, 1.5)
    self.dfinal_hard_t = 0
    self.dfinal_next_hard_t = math.prandom(1, 2)

    self.positions = {}
    for i = 1, 25 do 
        table.insert(self.positions, Vector((i-1)*32, -64))
        table.insert(self.positions, Vector((i-1)*32, 684))
    end
    for i = 1, 20 do
        table.insert(self.positions, Vector(-64, (i-1)*32))
        table.insert(self.positions, Vector(864, (i-1)*32))
    end

    self.enemies_list = nil
    self:collectorAddMessage(beholder.observe('ENEMIES LIST REPLY', function(enemies)
        self.enemies_list = enemies
    end))
end

function Spawner:update(dt)
    --[[
    local direction = table.choose({'RIGHT', 'LEFT'})
    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
    ]]--

    if self.name == current_map_name then
        if current_map_name == 'scb_gray' or current_map_name == 'scb_red' or current_map_name == 'scb_blue' or 
           current_map_name == 'scb_pink' or current_map_name == 'scb_green' or current_map_name == 'scb_other_red' then
            if difficulty == 1 then
                self.d1_normal_t = self.d1_normal_t + dt
                self.d1_hard_t = self.d1_hard_t + dt
                beholder.trigger('ENEMIES LIST REQUEST' .. current_level_id)
                if self.d1_normal_t > self.d1_next_normal_t then
                    self.d1_normal_t = 0
                    self.d1_next_normal_t = math.prandom(2, 4)
                    if #self.enemies_list <= math.floor(4*r_diff_mult) then
                        self:spawn('blue')
                    end
                end

                if self.d1_hard_t > self.d1_next_hard_t then
                    self.d1_hard_t = 0
                    self.d1_next_hard_t = math.prandom(4, 8)
                    if #self.enemies_list <= math.floor(4*r_diff_mult) then
                        self:spawn('blue hard')
                    end
                end
                self.enemies_list = nil

            elseif difficulty == 2 then
                self.d2_normal_t = self.d2_normal_t + dt
                self.d2_hard_t = self.d2_hard_t + dt
                beholder.trigger('ENEMIES LIST REQUEST' .. current_level_id)
                if self.d2_normal_t > self.d2_next_normal_t then
                    self.d2_normal_t = 0
                    self.d2_next_normal_t = math.prandom(1.75, 3.75)
                    if #self.enemies_list <= math.floor(4*r_diff_mult) then
                        self:spawn(chooseWithProb({'blue', 'blue red 1', 'blue red 2', 'blue red 3'}, {0.5, 0.15, 0.15, 0.2}))
                    end
                end

                if self.d2_hard_t > self.d2_next_hard_t then
                    self.d2_hard_t = 0
                    self.d2_next_hard_t = math.prandom(4, 8)
                    if #self.enemies_list <= math.floor(4*r_diff_mult) then
                        self:spawn(chooseWithProb({'blue hard', 'blue red hard'}, {0.5, 0.5}))
                    end
                end
                self.enemies_list = nil

            elseif difficulty == 3 then
                self.d3_normal_t = self.d3_normal_t + dt
                self.d3_hard_t = self.d3_hard_t + dt
                beholder.trigger('ENEMIES LIST REQUEST' .. current_level_id)
                if self.d3_normal_t > self.d3_next_normal_t then
                    self.d3_normal_t = 0
                    self.d3_next_normal_t = math.prandom(1.5, 3.5)
                    if #self.enemies_list <= math.floor(6*r_diff_mult) then
                        self:spawn(chooseWithProb({'blue', 'red', 'blue red 1', 'blue red 2', 'blue red 3'}, {0.25, 0.25, 0.15, 0.15, 0.2}))
                    end
                end

                if self.d3_hard_t > self.d3_next_hard_t then
                    self.d3_hard_t = 0
                    self.d3_next_hard_t = math.prandom(3.6, 7.2)
                    if #self.enemies_list <= math.floor(6*r_diff_mult) then
                        self:spawn(chooseWithProb({'blue hard', 'red hard', 'blue red hard'}, {0.25, 0.25, 0.5}))
                    end
                end
                self.enemies_list = nil

            elseif difficulty == 4 then
                self.d4_normal_t = self.d4_normal_t + dt
                self.d4_hard_t = self.d4_hard_t + dt
                beholder.trigger('ENEMIES LIST REQUEST' .. current_level_id)
                if self.d4_normal_t > self.d4_next_normal_t then
                    self.d4_normal_t = 0
                    self.d4_next_normal_t = math.prandom(1.5, 3.5)
                    if #self.enemies_list <= math.floor(8*r_diff_mult) then
                        self:spawn(chooseWithProb({'blue', 'red', 'blue red 1', 'blue red 2', 'blue red 3'}, {0.15, 0.35, 0.15, 0.15, 0.2}))
                    end
                end

                if self.d4_hard_t > self.d4_next_hard_t then
                    self.d4_hard_t = 0
                    self.d4_next_hard_t = math.prandom(3.6, 7.2)
                    if #self.enemies_list <= math.floor(8*r_diff_mult) then
                        self:spawn(chooseWithProb({'blue hard', 'red hard', 'blue red hard'}, {0.25, 0.5, 0.25}))
                    end
                end
                self.enemies_list = nil

            elseif difficulty == 5 then
                self.d5_normal_t = self.d5_normal_t + dt
                self.d5_hard_t = self.d5_hard_t + dt
                beholder.trigger('ENEMIES LIST REQUEST' .. current_level_id)
                if self.d5_normal_t > self.d5_next_normal_t then
                    self.d5_normal_t = 0
                    self.d5_next_normal_t = math.prandom(1.25, 3)
                    if #self.enemies_list <= math.floor(10*r_diff_mult) then
                        self:spawn(chooseWithProb({'blue', 'red', 'pink', 'blue red 1', 'blue red 2', 'blue red 3', 'red pink 1', 'red pink 2', 'red pink 3'},
                                                  {0.25, 0.2, 0.1, 0.1, 0.1, 0.1, 0.05, 0.05, 0.05}))
                    end
                end

                if self.d5_hard_t > self.d5_next_hard_t then
                    self.d5_hard_t = 0
                    self.d5_next_hard_t = math.prandom(3.2, 6.4)
                    if #self.enemies_list <= math.floor(10*r_diff_mult) then
                        self:spawn(chooseWithProb({'blue hard', 'red hard', 'pink hard', 'blue red hard', 'red pink hard'}, {0.2, 0.15, 0.1, 0.3, 0.25}))
                    end
                end
                self.enemies_list = nil

            elseif difficulty == 6 then
                self.d6_normal_t = self.d6_normal_t + dt
                self.d6_hard_t = self.d6_hard_t + dt
                beholder.trigger('ENEMIES LIST REQUEST' .. current_level_id)
                if self.d6_normal_t > self.d6_next_normal_t then
                    self.d6_normal_t = 0
                    self.d6_next_normal_t = math.prandom(1.25, 3)
                    if #self.enemies_list <= math.floor(10*r_diff_mult) then
                        self:spawn(chooseWithProb({'blue', 'red', 'pink', 'blue red 1', 'blue red 2', 'blue red 3', 'red pink 1', 'red pink 2', 'red pink 3'},
                                                  {0.1, 0.2, 0.25, 0.05, 0.05, 0.05, 0.1, 0.1, 0.1}))
                    end
                end

                if self.d6_hard_t > self.d6_next_hard_t then
                    self.d6_hard_t = 0
                    self.d6_next_hard_t = math.prandom(3.2, 6.4)
                    if #self.enemies_list <= math.floor(10*r_diff_mult) then
                        self:spawn(chooseWithProb({'blue hard', 'red hard', 'pink hard', 'blue red hard', 'red pink hard'}, {0.1, 0.15, 0.25, 0.25, 0.25}))
                    end
                end
                self.enemies_list = nil

            elseif difficulty == 7 then
                self.d7_normal_t = self.d7_normal_t + dt
                self.d7_hard_t = self.d7_hard_t + dt
                beholder.trigger('ENEMIES LIST REQUEST' .. current_level_id)
                if self.d7_normal_t > self.d7_next_normal_t then
                    self.d7_normal_t = 0
                    self.d7_next_normal_t = math.prandom(1, 2.5)
                    if #self.enemies_list <= math.floor(12*r_diff_mult) then
                        self:spawn(chooseWithProb({'red', 'pink', 'red pink 1', 'red pink 2', 'red pink 3'}, {0.1, 0.1, 0.3, 0.3, 0.2}))
                    end
                end

                if self.d7_hard_t > self.d7_next_hard_t then
                    self.d7_hard_t = 0
                    self.d7_next_hard_t = math.prandom(2.8, 5.6)
                    if #self.enemies_list <= math.floor(12*r_diff_mult) then
                        self:spawn(chooseWithProb({'red hard', 'pink hard', 'blue red hard', 'red pink hard'}, {0.1, 0.3, 0.1, 0.5}))
                    end
                end
                self.enemies_list = nil

            elseif difficulty == 8 then
                self.d8_normal_t = self.d8_normal_t + dt
                self.d8_hard_t = self.d8_hard_t + dt
                beholder.trigger('ENEMIES LIST REQUEST' .. current_level_id)
                if self.d8_normal_t > self.d8_next_normal_t then
                    self.d8_normal_t = 0
                    self.d8_next_normal_t = math.prandom(1, 2.5)
                    if #self.enemies_list <= math.floor(14*r_diff_mult) then
                        self:spawn(chooseWithProb({'red', 'pink', 'red pink 1', 'red pink 2', 'red pink 3'}, {0.1, 0.1, 0.3, 0.3, 0.2}))
                    end
                end

                if self.d8_hard_t > self.d8_next_hard_t then
                    self.d8_hard_t = 0
                    self.d8_next_hard_t = math.prandom(2.8, 5.6)
                    if #self.enemies_list <= math.floor(14*r_diff_mult) then
                        self:spawn(chooseWithProb({'red hard', 'pink hard', 'red pink hard'}, {0.2, 0.6, 0.2}))
                    end
                end
                self.enemies_list = nil

            elseif difficulty == 9 then
                self.d9_normal_t = self.d9_normal_t + dt
                self.d9_hard_t = self.d9_hard_t + dt
                beholder.trigger('ENEMIES LIST REQUEST' .. current_level_id)
                if self.d9_normal_t > self.d9_next_normal_t then
                    self.d9_normal_t = 0
                    self.d9_next_normal_t = math.prandom(0.75, 2)
                    if #self.enemies_list <= math.floor(16*r_diff_mult) then
                        self:spawn(chooseWithProb({'red', 'pink', 'red pink 1', 'red pink 2', 'red pink 3'}, {0.1, 0.3, 0.1, 0.3, 0.2}))
                    end
                end

                if self.d9_hard_t > self.d9_next_hard_t then
                    self.d9_hard_t = 0
                    self.d9_next_hard_t = math.prandom(2.4, 4.8)
                    if #self.enemies_list <= math.floor(16*r_diff_mult) then
                        self:spawn(chooseWithProb({'red hard', 'pink hard', 'red pink hard'}, {0.2, 0.6, 0.2}))
                    end
                end
                self.enemies_list = nil

            elseif difficulty == 10 then
                self.d10_normal_t = self.d10_normal_t + dt
                self.d10_hard_t = self.d10_hard_t + dt
                beholder.trigger('ENEMIES LIST REQUEST' .. current_level_id)
                if self.d10_normal_t > self.d10_next_normal_t then
                    self.d10_normal_t = 0
                    self.d10_next_normal_t = math.prandom(0.5, 1.5)
                    if #self.enemies_list <= math.floor(18*r_diff_mult) then
                        self:spawn('pink')
                    end
                end

                if self.d10_hard_t > self.d10_next_hard_t then
                    self.d10_hard_t = 0
                    self.d10_next_hard_t = math.prandom(2, 4)
                    if #self.enemies_list <= math.floor(18*r_diff_mult) then
                        self:spawn('pink hard')
                    end
                end
                self.enemies_list = nil

            elseif difficulty > 10 then
                self.dfinal_normal_t = self.dfinal_normal_t + dt
                self.dfinal_hard_t = self.dfinal_hard_t + dt
                beholder.trigger('ENEMIES LIST REQUEST' .. current_level_id)
                if self.dfinal_normal_t > self.dfinal_next_normal_t then
                    self.dfinal_normal_t = 0
                    self.dfinal_next_normal_t = math.prandom(0.5, 1.5)
                    if #self.enemies_list <= math.floor(20*r_diff_mult) then
                        self:spawn('pink')
                    end
                end

                if self.dfinal_hard_t > self.dfinal_next_hard_t then
                    self.dfinal_hard_t = 0
                    self.dfinal_next_hard_t = math.prandom(1, 2)
                    if #self.enemies_list <= math.floor(20*r_diff_mult) then
                        self:spawn('pink hard')
                    end
                end
            end
        end
    end
end

--[[
function Spawner:flySpawn(type)
    local v = self.positions[math.random(1, #self.positions)]
    local x, y = v.x, v.y

    if type == 'blue' then
        beholder.trigger('CREATE FLYING ENEMY' .. current_level_id, x, y, false, 'blue')

    elseif type == 'blue hard' then
        beholder.trigger('CREATE FLYING ENEMY' .. current_level_id, x, y, true, 'blue')

    elseif type == 'red' then
        beholder.trigger('CREATE FLYING ENEMY' .. current_level_id, x, y, false, 'red')

    elseif type == 'red hard' then
        beholder.trigger('CREATE FLYING ENEMY' .. current_level_id, x, y, true, 'red')

    elseif type == 'black' then
        beholder.trigger('CREATE FLYING ENEMY' .. current_level_id, x, y, false, 'black')

    elseif type == 'black hard' then
        beholder.trigger('CREATE FLYING ENEMY' .. current_level_id, x, y, true, 'black')
    end
end
]]--

-- blue, blue hard, red, red hard, blue red 1-2-3, blue red hard, pink, pink hard, red pink 1-2-3, red pink hard, blue red pink

function Spawner:spawn(type)
    if type == 'blue' then
        if dice(0.5) then
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}))

        elseif dice(0.5) then
            local direction = table.choose({'RIGHT', 'LEFT'})
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
            self:collectorAddTimer(main_chrono:after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
            end))

        elseif dice(0.5) then
            local direction = table.choose({'RIGHT', 'LEFT'})
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
            self:collectorAddTimer(main_chrono:after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
            end):after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
            end))

        elseif dice(0.5) then
            local direction = table.choose({'RIGHT', 'LEFT'})
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
            self:collectorAddTimer(main_chrono:after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
            end):after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
            end):after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
            end))
        end

    elseif type == 'blue hard' then
        if dice(0.5) then
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), true)
        end

    elseif type == 'red' then
        if dice(0.5) then
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), false, 'red')

        elseif dice(0.5) then
            local direction = table.choose({'RIGHT', 'LEFT'})
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
            self:collectorAddTimer(main_chrono:after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
            end))

        elseif dice(0.5) then
            local direction = table.choose({'RIGHT', 'LEFT'})
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
            self:collectorAddTimer(main_chrono:after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
            end):after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
            end))

        elseif dice(0.5) then
            local direction = table.choose({'RIGHT', 'LEFT'})
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
            self:collectorAddTimer(main_chrono:after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
            end):after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
            end):after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
            end))
        end

    elseif type == 'red hard' then
        if dice(0.5) then
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), true, 'red')
        end

    elseif type == 'blue red 1' then
        if dice(0.5) then
            if dice(0.5) then
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}))
            else
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), false, 'red')
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end))
            end
        end

    elseif type == 'blue red 2' then
        if dice(0.5) then
            if dice(0.5) then
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}))
            else
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), false, 'red')
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                end))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                end))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction)
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end))
            end
        end

    elseif type == 'blue red 3' then
        if dice(0.5) then
            if dice(0.5) then
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
            else
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                end))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                end))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'blue'}, {0.5, 0.5}))
                end))
            end
        end

    elseif type == 'blue red hard' then
        if dice(0.5) then
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), true)
        else
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), true, 'red')
        end

    elseif type == 'pink' then
        if dice(0.5) then
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), false, 'pink')

        elseif dice(0.5) then
            local direction = table.choose({'RIGHT', 'LEFT'})
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
            self:collectorAddTimer(main_chrono:after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
            end))

        elseif dice(0.5) then
            local direction = table.choose({'RIGHT', 'LEFT'})
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
            self:collectorAddTimer(main_chrono:after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
            end):after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
            end))

        elseif dice(0.5) then
            local direction = table.choose({'RIGHT', 'LEFT'})
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
            self:collectorAddTimer(main_chrono:after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
            end):after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
            end):after(0.2, function()
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
            end))
        end

    elseif type == 'pink hard' then
        if dice(0.5) then
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), true, 'pink')
        end 

    elseif type == 'red pink 1' then
        if dice(0.5) then
            if dice(0.5) then
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), false, 'red')
            else
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), false, 'pink')
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                end))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                end))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                end))
            end
        end

    elseif type == 'red pink 2' then
        if dice(0.5) then
            if dice(0.5) then
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), false, 'red')
            else
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), false, 'pink')
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'red')
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, 'pink')
                end))
            end
        end

    elseif type == 'red pink 3' then
        if dice(0.5) then
            if dice(0.5) then
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
            else
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                end))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                end))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'red', 'pink'}, {0.5, 0.5}))
                end))
            end
        end

    elseif type == 'red pink hard' then
        if dice(0.5) then
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), true, 'red')
        else
            beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), true, 'pink')
        end
    
    elseif type == 'blue red pink' then
        if dice(0.5) then
            if dice(0.5) then
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
            else
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, table.choose({'RIGHT', 'LEFT'}), false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                end))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                end))
            end

        elseif dice(0.5) then
            if dice(0.5) then
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                end))
            else
                local direction = table.choose({'RIGHT', 'LEFT'})
                beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                self:collectorAddTimer(main_chrono:after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                end):after(0.2, function()
                    beholder.trigger('CREATE ENEMY' .. current_level_id, self.p.x, self.p.y, direction, false, chooseWithProb({'blue', 'red', 'pink'}, {0.34, 0.33, 0.33}))
                end))
            end
        end
    end
end
