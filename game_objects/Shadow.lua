Shadow = class('Shadow', Entity)
Shadow:include(Collector)
    
function Shadow:initialize(type, x, y, w, h, direction, longer_fadeout, angled)
    Entity.initialize(self, x, y)
    self:collectorInit()
    self.w = w
    self.h = h
    self.type = type
    self.direction = direction or 'right'
    self.longer_fadeout = longer_fadeout
    self.angled = angled

    if self.type == 'Player' then
        if direction == 'left' then
            self.visual = player_left_shadow
        else
            self.visual = player_right_shadow
        end
    end

    self.dying_rgb = {128, 128, 128, 128}
    local r = 0
    if self.longer_fadeout then
        r = math.prandom(1, 1.2) 
    else r = math.prandom(0.4, 0.6) end
    self:collectorAddTween(main_tween(r, self, {dying_rgb = {255, 255, 255, 0}}, 'linear'))
    if self.angled then
        self.angle = math.prandom(math.pi/4, 3*math.pi/4)
    else self.angle = 0 end
end

function Shadow:update(dt)
    
end

function Shadow:draw()
    love.graphics.push()
    love.graphics.translate(self.p.x, self.p.y)
    love.graphics.rotate(self.angle)
    love.graphics.translate(-self.p.x, -self.p.y)
    love.graphics.setColor(unpack(self.dying_rgb))
    love.graphics.draw(self.visual, self.p.x - self.w/2, self.p.y - self.h/2)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.pop()
end
