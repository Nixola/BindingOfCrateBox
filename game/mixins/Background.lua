Background = {
    backgroundInit = function(self)
        local background_types = {'sun', 'drops', 'stripes'}

        self.bg_type = background_types[math.random(1, #background_types)]
        if self.bg_type == 'sun' then
            local ray = struct('angle', 'spread', 'color')
            local square = struct('p', 's', 'r', 'dr', 'v', 'angle', 'color')
            self.sun_point = Vector(math.random(-200, -100), math.random(-200, -100))
            self.n_rays = math.random(12, 40)
            self.rays = {}
            self.squares = {}
            local prev_angle = 0
            for i = 1, self.n_rays do
                local r = math.prandom(prev_angle+math.pi/24, prev_angle+math.pi/4)
                self.rays[i] = ray(r, math.prandom(math.pi/48, math.pi/4), math.random(216, 232)/256)
                prev_angle = r
            end
            if dice(0.5) then
                self.sun_type = 1
                self:collectorAddTimer(main_chrono:every(math.prandom(0.5, 2), function()
                    if string.match(self.name, 'tutorial') then
                        table.insert(self.squares, square(Vector(0, -48), math.prandom(0.03125, 0.125), math.prandom(-2*math.pi, 2*math.pi), 
                                                          math.prandom(-math.pi/2, math.pi/2), math.random(5, 25), math.prandom(0, math.pi/2), math.random(216, 232)/256))
                    else
                        table.insert(self.squares, square(Vector(0, 120), math.prandom(0.03125, 0.125), math.prandom(-2*math.pi, 2*math.pi), 
                                                          math.prandom(-math.pi/2, math.pi/2), math.random(5, 25), math.prandom(0, math.pi/2), math.random(216, 232)/256))
                    end
                end))
            else
                self.sun_type = 2
                self:collectorAddTimer(main_chrono:every(math.prandom(0.5, 2), function()
                    table.insert(self.squares, square(Vector(math.random(0, 800), 700), math.prandom(0.03125, 0.125), math.prandom(-2*math.pi, 2*math.pi), 
                                                      math.prandom(-math.pi/2, math.pi/2), math.random(5, 25), -math.pi/2, math.random(216, 232)/256))
                end))
            end

        elseif self.bg_type == 'drops' then
            local line = struct('x', 'width', 'color')
            local square = struct('p', 's', 'r', 'dr', 'v', 'angle', 'color')
            self.bg_lines = {}
            self.squares = {}
            self.n_lines = 10
            for i = 1, self.n_lines+1 do
                if i % 2 == 0 then
                    self.bg_lines[i] = line((i-1)*(800/self.n_lines), 64, math.random(216, 232))
                    self:collectorAddTimer(main_chrono:every(math.prandom(5, 10), function()
                        if string.match(self.name, 'tutorial') then
                            table.insert(self.squares, square(Vector((i-1)*(800/self.n_lines) + math.random(-16, 16), 688),
                                                              math.prandom(0.03125, 0.125), math.prandom(-2*math.pi, 2*math.pi),
                                                              math.prandom(-math.pi/8, math.pi/8), math.random(3, 20), -math.pi/2, math.random(216, 232)/256))
                        else
                            table.insert(self.squares, square(Vector((i-1)*(800/self.n_lines) + math.random(-16, 16), 648),
                                                              math.prandom(0.03125, 0.125), math.prandom(-2*math.pi, 2*math.pi),
                                                              math.prandom(-math.pi/8, math.pi/8), math.random(3, 20), -math.pi/2, math.random(216, 232)/256))
                        end
                             
                    end))
                else
                    self.bg_lines[i] = line((i-1)*(800/self.n_lines), 64, math.random(216, 232)/256)
                    self:collectorAddTimer(main_chrono:every(math.prandom(5, 10), function()
                        if string.match(self.name, 'tutorial') then
                            table.insert(self.squares, square(Vector((i-1)*(800/self.n_lines) + math.random(-16, 16), -48),
                                                              math.prandom(0.03125, 0.125), math.prandom(-2*math.pi, 2*math.pi),
                                                              math.prandom(-math.pi/8, math.pi/8), math.random(3, 20), math.pi/2, math.random(216, 232)/256))
                        else
                            table.insert(self.squares, square(Vector((i-1)*(800/self.n_lines) + math.random(-16, 16), 120),
                                                              math.prandom(0.03125, 0.125), math.prandom(-2*math.pi, 2*math.pi),
                                                              math.prandom(-math.pi/8, math.pi/8), math.random(3, 20), math.pi/2, math.random(216, 232)/256))
                        end
                    end))
                end
            end

        elseif self.bg_type == 'stripes' then
            local line = struct('y', 'width', 'color')
            local square = struct('p', 's', 'r', 'dr', 'v', 'angle', 'color')
            self.bg_lines = {}
            self.squares = {}
            self.n_lines = 10
            for i = 1, self.n_lines+1 do
                if i % 2 == 0 then
                    self.bg_lines[i] = line((i-1)*(640/self.n_lines), 48, math.random(216, 232)/256)
                    self:collectorAddTimer(main_chrono:every(math.prandom(5, 10), function()
                        table.insert(self.squares, square(Vector(-8, (i-1)*(640/self.n_lines) + math.random(-16, 16)), math.prandom(0.03125, 0.125),
                                                          math.prandom(-2*math.pi, 2*math.pi), math.prandom(-math.pi/8, math.pi/8), math.random(3, 20), 0,
                                                          math.random(216, 232)/256))

                    end))
                else
                    self.bg_lines[i] = line((i-1)*(640/self.n_lines), 48, math.random(216, 232)/256)
                    self:collectorAddTimer(main_chrono:every(math.prandom(5, 10), function()
                        table.insert(self.squares, square(Vector(808, (i-1)*(640/self.n_lines) + math.random(-16, 16)), math.prandom(0.03125, 0.125),
                                                          math.prandom(-2*math.pi, 2*math.pi), math.prandom(-math.pi/8, math.pi/8), math.random(3, 20), math.pi,
                                                          math.random(216, 232)/256))

                    end))
                end
            end
        end
    end,

    backgroundUpdate = function(self, dt)
        if self.bg_type == 'sun' then
            for _, ray in ipairs(self.rays) do
                ray.angle = ray.angle + (math.pi/math.random(256, 1024))*dt
            end
            for _, square in ipairs(self.squares) do
                square.r = square.r + (square.dr)*dt
                square.p.x = square.p.x + math.cos(square.angle)*square.v*dt
                square.p.y = square.p.y + math.sin(square.angle)*square.v*dt
            end
            if self.sun_type == 1 then
                for i = #self.squares, 1, -1 do
                    if self.squares[i].p.y > 700 then
                        table.remove(self.squares, i)
                    end
                end
            else 
                for i = #self.squares, 1, -1 do
                    if self.squares[i].p.y < 0 then
                        table.remove(self.squares, i)
                    end
                end
            end

        elseif self.bg_type == 'drops' then
            for _, square in ipairs(self.squares) do
                square.r = square.r + (square.dr)*dt
                square.p.x = square.p.x + math.cos(square.angle)*square.v*dt
                square.p.y = square.p.y + math.sin(square.angle)*square.v*dt
            end
            for i = #self.squares, 1, -1 do
                if self.squares[i].p.y > 740 or self.squares[i].p.y < -100 then
                    table.remove(self.squares, i)
                end
            end

        elseif self.bg_type == 'stripes' then
            for _, square in ipairs(self.squares) do
                square.r = square.r + (square.dr)*dt
                square.p.x = square.p.x + math.cos(square.angle)*square.v*dt
                square.p.y = square.p.y + math.sin(square.angle)*square.v*dt
            end
            for i = #self.squares, 1, -1 do
                if self.squares[i].p.x > 820 or self.squares[i].p.y < -20 then
                    table.remove(self.squares, i)
                end
            end
        end
    end,

    backgroundDraw = function(self)
        love.graphics.draw(maps[self.name].bg, maps[self.name].offset.x, maps[self.name].offset.y)
        if self.bg_type == 'sun' then
            for _, ray in ipairs(self.rays) do
                love.graphics.setColor(ray.color, ray.color, ray.color, 23/64)
                love.graphics.polygon('fill', {self.sun_point.x, self.sun_point.y, math.cos(ray.angle)*1000, math.sin(ray.angle)*1000,
                                               math.cos(ray.angle+ray.spread)*1000, math.sin(ray.angle+ray.spread)*1000})
                love.graphics.setColor(ray.color, ray.color, ray.color, 1/2)
                love.graphics.polygon('fill', {self.sun_point.x, self.sun_point.y, math.cos(ray.angle+ray.spread)*1000, math.sin(ray.angle+ray.spread)*1000,
                                               math.cos(ray.angle+ray.spread+math.pi/96)*1000, math.sin(ray.angle+ray.spread+math.pi/96)*1000})
            end
            for _, square in ipairs(self.squares) do
                love.graphics.setColor(square.color, square.color, square.color, 41/64)
                love.graphics.push()
                love.graphics.translate(square.p.x, square.p.y)
                love.graphics.rotate(square.r)
                love.graphics.translate(-square.p.x, -square.p.y)
                love.graphics.draw(bg_square, square.p.x-(64*square.s), square.p.y-(64*square.s), 0, square.s, square.s)
                love.graphics.pop()
            end
            love.graphics.setColor(colors.white)

        elseif self.bg_type == 'drops' then
            for _, line in ipairs(self.bg_lines) do
                love.graphics.setLineWidth(line.width)
                love.graphics.setColor(line.color, line.color, line.color, 23/64)
                love.graphics.line(line.x, -50, line.x, 700) 
                love.graphics.setLineWidth(16)
                love.graphics.setColor(line.color, line.color, line.color, 1/2)
                love.graphics.line(line.x-40, -50, line.x-40, 700) 
                love.graphics.setLineWidth(1)
            end
            for _, square in ipairs(self.squares) do
                love.graphics.setColor(square.color, square.color, square.color, 41/64)
                love.graphics.push()
                love.graphics.translate(square.p.x, square.p.y)
                love.graphics.rotate(square.r)
                love.graphics.translate(-square.p.x, -square.p.y)
                love.graphics.draw(bg_square, square.p.x-(64*square.s), square.p.y-(64*square.s), 0, square.s, square.s)
                love.graphics.pop()
            end
            love.graphics.setColor(colors.white)

        elseif self.bg_type == 'stripes' then
            for _, line in ipairs(self.bg_lines) do
                love.graphics.setLineWidth(line.width)
                love.graphics.setColor(line.color, line.color, line.color, 23/64)
                love.graphics.line(-50, line.y, 850, line.y) 
                love.graphics.setLineWidth(16)
                love.graphics.setColor(line.color, line.color, line.color, 1/2)
                love.graphics.line(-50, line.y-32, 850, line.y-32) 
                love.graphics.setLineWidth(1)
            end
            for _, square in ipairs(self.squares) do
                love.graphics.setColor(square.color, square.color, square.color, 41/64)
                love.graphics.push()
                love.graphics.translate(square.p.x, square.p.y)
                love.graphics.rotate(square.r)
                love.graphics.translate(-square.p.x, -square.p.y)
                love.graphics.draw(bg_square, square.p.x-(64*square.s), square.p.y-(64*square.s), 0, square.s, square.s)
                love.graphics.pop()
            end
            love.graphics.setColor(colors.white)
        end
    end
}
