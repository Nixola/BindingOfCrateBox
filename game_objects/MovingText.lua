MovingText = class('MovingText', Entity)
MovingText.UID = 0
MovingText:include(Collector)

function MovingText:initialize(parent_id, x, y, text, r)
    Entity.initialize(self, x, y)
    self:collectorInit()
    if not text then text = 0 end
    self.w = GAME_FONT:getWidth(tostring(text))
    self.h = GAME_FONT:getHeight()
    self.r = r
    self.parent_id = parent_id
    self.attached_to = nil
    self.text = text
    self.alpha = 255
    self.type = nil

    self:collectorAddMessage(beholder.observe('ANGLE MOVE TEXT' .. self.parent_id, function(x, y)
        self.p = Vector(x, y)
        self:collectorAddTween(main_tween(1, self.p, {x = x - math.random(64, 108)*math.cos(self.r or 0)}, 'outCirc'))
        self:collectorAddTween(main_tween(1, self.p, {y = y - math.random(64, 108)*math.sin(self.r or 0)}, 'outCirc'))
        self:collectorAddTimer(main_chrono:after(0.4, function() beholder.trigger('REMOVE' .. current_level_id, self) end))
    end))

    self:collectorAddMessage(beholder.observe('ITEMGET MOVE TEXT BIG' .. self.parent_id, function(x, y)
        self.type = 'ItemgetBig'
        self.p = Vector(x, y)
        self:collectorAddTween(main_tween(4, self.p, {y = y - 64}, 'linear'))
        self:collectorAddTimer(main_chrono:after(3, function() self:collectorAddTween(main_tween(1, self, {alpha = 0}, 'linear'))
        end):after(1, function() beholder.trigger('REMOVE' .. current_level_id, self) end))
    end))

    self:collectorAddMessage(beholder.observe('ITEMGET MOVE TEXT SMALL' .. self.parent_id, function(x, y)
        self.type = 'ItemgetSmall'
        self.p = Vector(x, y)
        self:collectorAddTween(main_tween(4, self.p, {y = y - 64}, 'linear'))
        self:collectorAddTimer(main_chrono:after(3, function() self:collectorAddTween(main_tween(1, self, {alpha = 0}, 'linear'))
        end):after(1, function() beholder.trigger('REMOVE' .. current_level_id, self) end))
    end))

    self:collectorAddMessage(beholder.observe('DAMAGE MOVE TEXT' .. self.parent_id, function(x, y)
        self.p = Vector(x, y)
        self:collectorAddTween(main_tween(1, self.p, {y = y - 32}, 'outElastic'))
        self:collectorAddTimer(main_chrono:after(0.5, function() beholder.trigger('REMOVE' .. current_level_id, self) end))
    end))

    self:collectorAddMessage(beholder.observe('CONDITION MOVE TEXT' .. self.parent_id, function(x, y)
        self.p = Vector(x, y)
        self:collectorAddTween(main_tween(1, self.p, {y = y - 16}, 'outCirc'))
        self:collectorAddTimer(main_chrono:after(0.5, function() beholder.trigger('REMOVE' .. current_level_id, self) end))
    end))
end

function MovingText:update(dt)
    if self.attached_to then
        self.p.x = self.attached_to.p.x
    end
end

function MovingText:draw()
    if self.type == 'ItemgetBig' then
        love.graphics.setFont(UI_TEXT_FONT_24)
        self.w = UI_TEXT_FONT_24:getWidth(tostring(text))
        self.h = UI_TEXT_FONT_24:getHeight()
        love.graphics.setColor(0, 0, 0, self.alpha)
        love.graphics.print(tostring(self.text), (self.p.x - self.w/2), (self.p.y - self.h))
    elseif self.type == 'ItemgetSmall' then
        love.graphics.setFont(UI_TEXT_FONT_16)
        self.w = UI_TEXT_FONT_16:getWidth(tostring(text))
        self.h = UI_TEXT_FONT_16:getHeight()
        love.graphics.setColor(255, 255, 255, self.alpha)
        love.graphics.print(tostring(self.text), (self.p.x - self.w/2)+1, (self.p.y - self.h)+1)
        love.graphics.print(tostring(self.text), (self.p.x - self.w/2)+1, (self.p.y - self.h)-1)
        love.graphics.print(tostring(self.text), (self.p.x - self.w/2)-1, (self.p.y - self.h)+1)
        love.graphics.print(tostring(self.text), (self.p.x - self.w/2)-1, (self.p.y - self.h)-1)
        love.graphics.setColor(0, 0, 0, self.alpha)
        love.graphics.print(tostring(self.text), (self.p.x - self.w/2), (self.p.y - self.h))
    end
    love.graphics.setColor(255, 255, 255, 255)
end


