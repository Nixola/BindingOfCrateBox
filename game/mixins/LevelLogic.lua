LevelLogic = {
    levelLogicInit = function(self)
        self.n_enemies = 0
        self.enemy_limit = 0
        self.over = false
        self.boss = false
        self.last_room = false
        self.end_game = false
        if self.name == 'market' or string.match(self.name, 'item') or string.match(self.name, 'tutorial') then
            self.over = true
        elseif self.name == current_map_name then
            if difficulty == 1 then self.enemy_limit = math.floor(15*r_diff_mult) end
            if difficulty == 2 then self.enemy_limit = math.floor(20*r_diff_mult) end
            if difficulty == 3 then self.enemy_limit = math.floor(25*r_diff_mult) end
            if difficulty == 4 then self.enemy_limit = math.floor(30*r_diff_mult) end
            if difficulty == 5 then self.enemy_limit = math.floor(30*r_diff_mult) end
            if difficulty == 6 then self.enemy_limit = math.floor(35*r_diff_mult) end
            if difficulty == 7 then self.enemy_limit = math.floor(35*r_diff_mult) end
            if difficulty == 8 then self.enemy_limit = math.floor(40*r_diff_mult) end
            if difficulty == 9 then self.enemy_limit = math.floor(40*r_diff_mult) end
            if difficulty == 10 then self.enemy_limit = math.floor(50*r_diff_mult) end
            if difficulty > 10 then self.enemy_limit = math.floor(60*r_diff_mult); beholder.trigger('FINAL ROOM'); self.last_room = true end
        end
        beholder.observe('ENEMY DEAD' .. self.id, function() 
            self.n_enemies = self.n_enemies + 1 
            if self.n_enemies > self.enemy_limit then
                self.over = true
            end
        end)
    end,

    levelLogicUpdate = function(self, dt)
        if self.over and not self.boss then
            for _, wall_door in ipairs(self.wall_doors) do
                if wall_door.p.x > 400 then
                    wall_door.dead = true
                    local x, y = wall_door.p.x, wall_door.p.y
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y+8, {170, 105, 51, 255, 170, 105, 51, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y+8, {170, 105, 51, 255, 170, 105, 51, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y+8, {142, 88, 43, 255, 142, 88, 43, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y+8, {88, 54, 27, 255, 88, 54, 27, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y-32+8, {170, 105, 51, 255, 170, 105, 51, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y-32+8, {170, 105, 51, 255, 170, 105, 51, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y-32+8, {142, 88, 43, 255, 142, 88, 43, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y-32+8, {88, 54, 27, 255, 88, 54, 27, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y+32+8, {170, 105, 51, 255, 170, 105, 51, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y+32+8, {170, 105, 51, 255, 170, 105, 51, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet', x, y+32+8, {142, 88, 43, 255, 142, 88, 43, 0})
                    beholder.trigger('PARTICLE SPAWN' .. current_level_id, 'ResourceGet2', x, y+32+8, {88, 54, 27, 255, 88, 54, 27, 0})
                end
            end
            if self.spawner then self.spawner:collectorDestroy() end
            self.spawner = nil

            if self.player.p.x > 800 then
                if self.name == 'market' or string.match(self.name, 'item') or string.match(self.name, 'tutorial') then
                    name = maps_list[math.random(1, #maps_list)]
                    if name == 'scb_green' or name == 'scb_other_Red' or name == 'scb_red' or name == 'scb_blue' then 
                        if dice(0.5) then
                            if dice(0.5) then
                                name = 'scb_gray'
                            else name = 'scb_pink' end
                        end
                    end
                    beholder.trigger('TRANSITION TO', name)
                elseif self.name == 'end' then

                else
                    if self.last_room then
                        current_map_name = 'end'
                        beholder.trigger('TRANSITION TO', 'end')
                    else
                        if dice(0.75) then
                            current_map_name = 'market'
                            beholder.trigger('TRANSITION TO', 'market')
                        else
                            current_map_name = items_mlist[math.random(1, #items_mlist)]
                            beholder.trigger('TRANSITION TO', current_map_name)
                        end
                    end
                end
            end
        end
    end
}
