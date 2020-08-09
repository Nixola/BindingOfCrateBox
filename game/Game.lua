require 'game/Level'
require 'game/UI'
require 'game/PausedMenu'
require 'game/Sound'

Game = class('Game')

function Game:initialize()
    self.paused = false
    self.paused_menu = PausedMenu()
    self.current_level = Level(current_map_name)
    self.transitioning = false
    self.transition_alpha = 0

    beholder.observe('UNPAUSE', function()
        self.paused = false
    end)

    beholder.observe('END IT ALL', function()
        self.end_it_all = true
    end)

    beholder.observe('SET PARTICLE RATE', function(n)
        self.current_level.particle:setRate(n)
    end)
    self.music_text = nil
    self.music_color = {colors.white(0)}
    self.music_color2 = {colors.black(0)}
    beholder.observe('MUSIC UI TEXT', function(text)
        self.music_text = text
        main_tween(2, self, {music_color = {colors.white(1)}}, 'linear')
        main_tween(2, self, {music_color2 = {colors.black(1)}}, 'linear')
        over_chrono:after(6, function() 
            main_chrono:after(2, function() self.music_text = nil end)
            main_tween(2, self, {music_color = {colors.white(0)}}, 'linear')
            main_tween(2, self, {music_color2 = {colors.black(0)}}, 'linear')
        end)
    end)

    self.death = false
    self.death_overlay = {colors.gray_mid(0)}
    self.retry_alpha = 0
    self.retry = false
    self.retry_pointer = 1
    beholder.observe('DEAD', function()
        self.death = true 
        beholder.trigger('DISABLE INPUT' .. self.current_level.player.id, 1)
        over_chrono:after(0.5, function()
            self.retry = true
            main_tween(0.5, self, {retry_alpha = 1}, 'linear')
        end)
    end)

    beholder.observe('TRANSITION TO', function(name) 
        self.transitioning = true 
        main_chrono:after(0.3, function()
            if self.transitioning then
                self.transitioning = false
                player_passives = table.copy(self.current_level.player.passives)
                if self.current_level.player.current_item then
                    player_item = table.copy(self.current_level.player.current_item)
                end
                if self.current_level.player.current_attack then
                    player_attack = table.copy(attacks[self.current_level.player.current_attack.name])
                end
                p_familiars = {}
                p_buffs = {}
                for _, f in ipairs(self.current_level.familiars) do
                    if not f.kill_after then
                        table.insert(p_familiars, f.f_type)
                    end
                end
                for _, b in ipairs(self.current_level.player.buffs) do
                    table.insert(p_buffs, b)
                end
                self.current_level:collectorDestroy()
                self.current_level:destroy()
                beholder = nil
                self.current_level = nil
                beholder = require 'libraries/beholder/beholder'
                if string.match(current_map_name, 'tutorial') then n_levels = 0 end
                current_map_name = name
                if name ~= 'market' and not string.match(name, 'tutorial') and not string.match(name, 'item') then n_levels = n_levels + 1 end
                self.current_level = Level(name)
                beholder.trigger('SET PARTICLE RATE REQUEST')
            end
        end)
    end)

    self.tutorial_texts = {"WASD to move", "QE or SHIFT to dash", "ESC for options", "J to attack", "K to use items", "L to use bombs", "You can also use a controller"}
    self.tutorial_positions = {{x = 200, y = 64}, {x = 200, y = 128}, {x = 200, y = 192}, {x = 600, y = 64}, {x = 600, y = 128}, {x = 600, y = 192}, {x = 400, y = 256}}

    self.ui = UI(Vector(0, 0))
    self.sound = Sound()
end

function Game:update(dt)
    if self.current_level then
        self.current_level:update(dt) 
        self.ui:update(dt)
    end
    if self.paused then
        self.paused_menu:update(dt)
    end
end

function Game:draw()
    if self.current_level then
        if not self.transitioning then
            self.current_level:draw()
            if not string.match(self.current_level.name, 'tutorial') then
                self.ui:draw()
            else
                love.graphics.setFont(UI_TEXT_FONT_24)
                for i, text in ipairs(self.tutorial_texts) do
                    local w = UI_TEXT_FONT_24:getWidth(text)
                    love.graphics.setColor(colors.black)
                    love.graphics.print(text, self.tutorial_positions[i].x - w/2 - 1, self.tutorial_positions[i].y - 1)
                    love.graphics.print(text, self.tutorial_positions[i].x - w/2 - 1, self.tutorial_positions[i].y + 1)
                    love.graphics.print(text, self.tutorial_positions[i].x - w/2 + 1, self.tutorial_positions[i].y - 1)
                    love.graphics.print(text, self.tutorial_positions[i].x - w/2 + 1, self.tutorial_positions[i].y + 1)
                    love.graphics.setColor(colors.white)
                    love.graphics.print(text, self.tutorial_positions[i].x - w/2, self.tutorial_positions[i].y)
                end

                love.graphics.setFont(UI_TEXT_FONT_16)
                local t = "Plug one in/out now or during the game!"
                local w = UI_TEXT_FONT_16:getWidth(t)
                love.graphics.setColor(colors.black)
                love.graphics.print(t, 400 - w/2 - 1, 288 - 1)
                love.graphics.print(t, 400 - w/2 - 1, 288 + 1)
                love.graphics.print(t, 400 - w/2 + 1, 288 - 1)
                love.graphics.print(t, 400 - w/2 + 1, 288 + 1)
                love.graphics.setColor(colors.white)
                love.graphics.print(t, 400 - w/2, 288)

                love.graphics.setFont(UI_TEXT_FONT_48)
                t = "OR ELSE"
                w = UI_TEXT_FONT_48:getWidth(t)
                love.graphics.setColor(colors.black)
                love.graphics.print(t, 400 - w/2 - 1, 310 - 1)
                love.graphics.print(t, 400 - w/2 - 1, 310 + 1)
                love.graphics.print(t, 400 - w/2 + 1, 310 - 1)
                love.graphics.print(t, 400 - w/2 + 1, 310 + 1)
                love.graphics.setColor(colors.white)
                love.graphics.print(t, 400 - w/2, 310)
            end
        end
    end
    if self.paused then
        love.graphics.draw(paused_overlay, 0, 0)
        self.paused_menu:draw()
    end
    if self.retry then
        love.graphics.setFont(UI_TEXT_FONT_48)
        local text = 'you died'
        local w = UI_TEXT_FONT_48:getWidth(text)
        love.graphics.setColor(colors.black(self.retry_alpha))
        love.graphics.print(text, 400 - w/2 - 2, 160 - 2)
        love.graphics.print(text, 400 - w/2 - 2, 160 + 2)
        love.graphics.print(text, 400 - w/2 + 2, 160 - 2)
        love.graphics.print(text, 400 - w/2 + 2, 160 + 2)
        love.graphics.setColor(colors.white(self.retry_alpha))
        love.graphics.print(text, 400 - w/2, 160)

        love.graphics.setFont(UI_TEXT_FONT_40)
        local text = 'retry'
        local w = UI_TEXT_FONT_40:getWidth(text)
        love.graphics.setColor(colors.black(self.retry_alpha))
        love.graphics.print(text, 400 - w/2 - 2, 316 - 2)
        love.graphics.print(text, 400 - w/2 - 2, 316 + 2)
        love.graphics.print(text, 400 - w/2 + 2, 316 - 2)
        love.graphics.print(text, 400 - w/2 + 2, 316 + 2)
        if self.retry_pointer == 1 then 
            love.graphics.setColor(colors.pink29(self.retry_alpha))
        else
            love.graphics.setColor(colors.white)
        end
        love.graphics.print(text, 400 - w/2, 316)

        love.graphics.setFont(UI_TEXT_FONT_40)
        local text = 'quit'
        local w = UI_TEXT_FONT_40:getWidth(text)
        love.graphics.setColor(colors.black(self.retry_alpha))
        love.graphics.print(text, 400 - w/2 - 2, 380 - 2)
        love.graphics.print(text, 400 - w/2 - 2, 380 + 2)
        love.graphics.print(text, 400 - w/2 + 2, 380 - 2)
        love.graphics.print(text, 400 - w/2 + 2, 380 + 2)
        if self.retry_pointer == 2 then 
            love.graphics.setColor(colors.pink29(self.retry_alpha))
        else
            love.graphics.setColor(colors.white(self.retry_alpha))
        end
        love.graphics.print(text, 400 - w/2, 380)
        love.graphics.setColor(colors.white)
    end
    if self.music_text then
        love.graphics.setColor(colors.white)
        love.graphics.setFont(UI_TEXT_FONT_16)
        local t = self.music_text
        local w = UI_TEXT_FONT_16:getWidth(t)
        love.graphics.setColor(unpack(self.music_color2))
        love.graphics.print(t, 400 - w/2 - 1, 612 - 1)
        love.graphics.print(t, 400 - w/2 - 1, 612 + 1)
        love.graphics.print(t, 400 - w/2 + 1, 612 - 1)
        love.graphics.print(t, 400 - w/2 + 1, 612 + 1)
        love.graphics.setColor(unpack(self.music_color))
        love.graphics.print(t, 400 - w/2, 612)
        love.graphics.setColor(colors.white)
    end
end

function Game:keypressed(key)
    if self.death and not self.retry then return end
    if not self.paused then 
        if self.current_level then
            self.current_level:keypressed(key) 
        end
    else
        self.paused_menu:keypressed(key)
    end
    if self.death then
        if key == 'up' or key == 'Up' or key == 'w' then
            self.retry_pointer = self.retry_pointer - 1
            if self.retry_pointer <= 0 then self.retry_pointer = 2 end
        end
        if key == 'down' or key == 'Down' or key == 's' then
            self.retry_pointer = self.retry_pointer + 1
            if self.retry_pointer > 2 then self.retry_pointer = 1 end
        end
        if key == 'j' or key == 'A' or key == 'X' or key == 'space' or key == 'return' then
            if self.retry_pointer == 1 then
                self.end_it_all = true
                
            elseif self.retry_pointer == 2 then
                love.event.push('quit')
            end
        end
    end
    if key == 'escape' or key == 'Start' then 
        if not self.paused then beholder.trigger('CHANGE MUSIC VOLUME', 0.5)
        else beholder.trigger('CHANGE MUSIC VOLUME', 1); beholder.trigger('CHANGE GAME VOLUME', 1) end
        self.paused = not self.paused 
        self.paused_menu.settings = false
        self.paused_menu.about = false
        self.paused_menu.collection = false
        self.paused_menu.how2play = false
        self.paused_menu.controller = false
    end
end

function Game:keyreleased(key)
    if not self.paused then 
        if self.current_level then
            self.current_level:keyreleased(key) 
        end
    end
end
