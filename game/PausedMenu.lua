PausedMenu = class('PausedMenu')

function PausedMenu:initialize()
    self.pointer = 1
    self.settings_pointer = 1
    self.options = {'resume', 'restart', 'my collection', 'settings', 'how2play', 'controller?', 'about', 'quit'}
    self.how2play_texts = {'this game keeps spawning enemies in each room', 
                           'are you a bad enough dude to kill all of them?',
                           'over all 15 or so rooms?',
                           'while using your money to buy super duper special items?',
                           'that will give you super duper special powers?',
                           "because that's how dad did it?",
                           "and that's how america does it?",
                           "and it's worked out pretty well so far?"}
    self.controller_texts = {'If you have a controller, just plug it in to play!',
                             'A number of joysticks is supported, but if yours isn\'t you can add',
                             'your own mappings creating a file named "user.mappings.list" here:',
                             love.filesystem.getSaveDirectory() .. '/resources/',
                             '(press left to open it automatically',
                             'If you don\'t know how, the following web page, where I got',
                             'the default mappings from, provides some info:',
                             'https://github.com/gabomdq/SDL_GameControllerDB',
                             '(press right to open it automatically)'}
    self.about_texts = {'Created by adnzzzzZ with LÖVE', "also ported to LÖVE 0.9.2 by Nix",
                        'i have no plans on keeping it looking the same',
                        'so you can have any kind of super duper cool art style', 
                        "because that's how dad did it",
                        "and that's how america does it",
                        "and it's worked out pretty well so far",
                        "email adonaac@gmail.com if you're interested."}
    self.settings_options = {'sound volume', 'music volume', 'scale', 'fullscreen'}
    self.settings = false
    self.about = false
    self.collection = false
    self.how2play = false
    self.controller = false
    self.selected_color = {232, 128, 232, 255}
    self.hold_to_jump = true
    beholder.observe('HOLD TO JUMP REQUEST', function()
        beholder.trigger('HOLD TO JUMP REPLY', self.hold_to_jump)
    end)
    beholder.observe('SET HOLD TO JUMP', function(status)
        if status == "true" then
            status = true
        elseif status == "false" then
            status = false
        end
        self.hold_to_jump = status
    end)
    self.particles = 1
    beholder.observe('SET PARTICLE RATE', function(n)
        self.particles = n
    end)
    beholder.observe('SET PARTICLE RATE REQUEST', function() beholder.trigger('SET PARTICLE RATE', self.particles) end)
    self.music_volume = nil
    beholder.observe('MUSIC VOLUME REPLY', function(s) self.music_volume = s end)
    beholder.observe('SET MUSIC VOLUME', function(s) self.music_volume = s end)
    self.game_volume = nil
    beholder.observe('GAME VOLUME REPLY', function(s) self.game_volume = s end)
    beholder.observe('SET GAME VOLUME', function(s) self.game_volume = s end)
end

function PausedMenu:update(dt)
    
end

function PausedMenu:draw()
    if self.collection then
        love.graphics.setFont(UI_TEXT_FONT_48)
        local text = '-MY COLLECTION-'
        local w = UI_TEXT_FONT_48:getWidth(text)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print(text, 400 - w/2 - 2, 48 - 2)
        love.graphics.print(text, 400 - w/2 - 2, 48 + 2)
        love.graphics.print(text, 400 - w/2 + 2, 48 - 2)
        love.graphics.print(text, 400 - w/2 + 2, 48 + 2)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print(text, 400 - w/2, 48)

        local i, j = 1, 1
        for k, item in ipairs(collection_list) do
            if k % 15 == 0 then j = j + 1 end
            i = k % 15 
            if table.contains(locked_attacks, item) or table.contains(locked_passives, item) then
                love.graphics.setColor(0, 0, 0, 255)
            end
            love.graphics.draw(resources[item].visual, 64+i*48 - resources[item].visual:getWidth()/2, 96+j*64 - resources[item].visual:getHeight()/2)
            love.graphics.setColor(255, 255, 255, 255)
        end

    elseif self.how2play then
        love.graphics.setFont(UI_TEXT_FONT_48)
        local text = '-HOW2PLAY-'
        local w = UI_TEXT_FONT_48:getWidth(text)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print(text, 400 - w/2 - 2, 48 - 2)
        love.graphics.print(text, 400 - w/2 - 2, 48 + 2)
        love.graphics.print(text, 400 - w/2 + 2, 48 - 2)
        love.graphics.print(text, 400 - w/2 + 2, 48 + 2)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print(text, 400 - w/2, 48)

        for i, text in ipairs(self.how2play_texts) do
            love.graphics.setFont(UI_TEXT_FONT_16)
            w = UI_TEXT_FONT_16:getWidth(text)
            love.graphics.setColor(0, 0, 0, 255)
            love.graphics.print(text, 400 - w/2 - 2, 192+i*32 - 2)
            love.graphics.print(text, 400 - w/2 - 2, 192+i*32 + 2)
            love.graphics.print(text, 400 - w/2 + 2, 192+i*32 - 2)
            love.graphics.print(text, 400 - w/2 + 2, 192+i*32 + 2)
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.print(text, 400 - w/2, 192+i*32)
        end
        love.graphics.setColor(255, 255, 255, 255)

    elseif self.controller then
        love.graphics.setFont(UI_TEXT_FONT_48)
        local text = '-CONTROLLER-'
        local w = UI_TEXT_FONT_48:getWidth(text)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print(text, 400 - w/2 - 2, 48 - 2)
        love.graphics.print(text, 400 - w/2 - 2, 48 + 2)
        love.graphics.print(text, 400 - w/2 + 2, 48 - 2)
        love.graphics.print(text, 400 - w/2 + 2, 48 + 2)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print(text, 400 - w/2, 48)

        for i, text in ipairs(self.controller_texts) do
            love.graphics.setFont(UI_TEXT_FONT_16)
            w = UI_TEXT_FONT_16:getWidth(text)
            love.graphics.setColor(0, 0, 0, 255)
            love.graphics.print(text, 400 - w/2 - 2, 192+i*32 - 2)
            love.graphics.print(text, 400 - w/2 - 2, 192+i*32 + 2)
            love.graphics.print(text, 400 - w/2 + 2, 192+i*32 - 2)
            love.graphics.print(text, 400 - w/2 + 2, 192+i*32 + 2)
            if i%4 == 0 then
                love.graphics.setColor(unpack(self.selected_color))
            else
                love.graphics.setColor(255, 255, 255, 255)
            end
            love.graphics.print(text, 400 - w/2, 192+i*32)
        end
        love.graphics.setColor(255, 255, 255, 255)

    elseif self.settings then
        love.graphics.setFont(UI_TEXT_FONT_48)
        local text = '-SETTINGS-'
        local w = UI_TEXT_FONT_48:getWidth(text)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print(text, 400 - w/2 - 2, 48 - 2)
        love.graphics.print(text, 400 - w/2 - 2, 48 + 2)
        love.graphics.print(text, 400 - w/2 + 2, 48 - 2)
        love.graphics.print(text, 400 - w/2 + 2, 48 + 2)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print(text, 400 - w/2, 48)

        love.graphics.setFont(UI_TEXT_FONT_24)
        text = 'PARTICLES'
        w = UI_TEXT_FONT_24:getWidth(text)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print(text, 200 - w/2 - 2, 304 - 2)
        love.graphics.print(text, 200 - w/2 - 2, 304 + 2)
        love.graphics.print(text, 200 - w/2 + 2, 304 - 2)
        love.graphics.print(text, 200 - w/2 + 2, 304 + 2)
        if self.settings_pointer == 4 then
            love.graphics.setColor(unpack(self.selected_color))
        else
            love.graphics.setColor(255, 255, 255, 255)
        end
        love.graphics.print(text, 200 - w/2, 304)
        if self.particles == 1 then text = 'ON'
        else text = 'OFF (impatcs gameplay)' end
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print(text, 336 - 2, 304 - 2)
        love.graphics.print(text, 336 - 2, 304 + 2)
        love.graphics.print(text, 336 + 2, 304 - 2)
        love.graphics.print(text, 336 + 2, 304 + 2)
        if self.settings_pointer == 4 then
            love.graphics.setColor(unpack(self.selected_color))
        else
            love.graphics.setColor(255, 255, 255, 255)
        end
        love.graphics.print(text, 336, 304)

        love.graphics.setFont(UI_TEXT_FONT_24)
        text = 'HOLD TO JUMP'
        w = UI_TEXT_FONT_24:getWidth(text)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print(text, 200 - w/2 - 2, 256 - 2)
        love.graphics.print(text, 200 - w/2 - 2, 256 + 2)
        love.graphics.print(text, 200 - w/2 + 2, 256 - 2)
        love.graphics.print(text, 200 - w/2 + 2, 256 + 2)
        if self.settings_pointer == 3 then
            love.graphics.setColor(unpack(self.selected_color))
        else
            love.graphics.setColor(255, 255, 255, 255)
        end
        love.graphics.print(text, 200 - w/2, 256)
        if self.hold_to_jump then text = 'ON'
        else text = 'OFF' end
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print(text, 336 - 2, 256 - 2)
        love.graphics.print(text, 336 - 2, 256 + 2)
        love.graphics.print(text, 336 + 2, 256 - 2)
        love.graphics.print(text, 336 + 2, 256 + 2)
        if self.settings_pointer == 3 then
            love.graphics.setColor(unpack(self.selected_color))
        else
            love.graphics.setColor(255, 255, 255, 255)
        end
        love.graphics.print(text, 336, 256)

        love.graphics.setFont(UI_TEXT_FONT_24)
        text = 'GAME VOLUME'
        w = UI_TEXT_FONT_24:getWidth(text)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print(text, 200 - w/2 - 2, 208 - 2)
        love.graphics.print(text, 200 - w/2 - 2, 208 + 2)
        love.graphics.print(text, 200 - w/2 + 2, 208 - 2)
        love.graphics.print(text, 200 - w/2 + 2, 208 + 2)
        if self.settings_pointer == 2 then
            love.graphics.setColor(unpack(self.selected_color))
        else
            love.graphics.setColor(255, 255, 255, 255)
        end
        love.graphics.print(text, 200 - w/2, 208)
        beholder.trigger('GAME VOLUME REQUEST')
        for i = 1, 20 do
            if i <= math.floor(20*self.game_volume) then
                if self.settings_pointer == 2 then
                    love.graphics.setColor(unpack(self.selected_color))
                else
                    love.graphics.setColor(255, 255, 255, 255)
                end
                love.graphics.rectangle('fill', 316 + i*20, 216, 16, 24)
                love.graphics.setColor(0, 0, 0, 255)
                love.graphics.rectangle('line', 316 + i*20, 216, 16, 24)
                love.graphics.setColor(255, 255, 255, 255)
            end
        end
        love.graphics.setColor(255, 255, 255, 255)

        love.graphics.setFont(UI_TEXT_FONT_24)
        text = 'MUSIC VOLUME'
        w = UI_TEXT_FONT_24:getWidth(text)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print(text, 200 - w/2 - 2, 160 - 2)
        love.graphics.print(text, 200 - w/2 - 2, 160 + 2)
        love.graphics.print(text, 200 - w/2 + 2, 160 - 2)
        love.graphics.print(text, 200 - w/2 + 2, 160 + 2)
        if self.settings_pointer == 1 then
            love.graphics.setColor(unpack(self.selected_color))
        else
            love.graphics.setColor(255, 255, 255, 255)
        end
        love.graphics.print(text, 200 - w/2, 160)
        beholder.trigger('MUSIC VOLUME REQUEST')
        for i = 1, 20 do
            if i <= math.floor(20*self.music_volume) then
                if self.settings_pointer == 1 then
                    love.graphics.setColor(unpack(self.selected_color))
                else
                    love.graphics.setColor(255, 255, 255, 255)
                end
                love.graphics.rectangle('fill', 316 + i*20, 168, 16, 24)
                love.graphics.setColor(0, 0, 0, 255)
                love.graphics.rectangle('line', 316 + i*20, 168, 16, 24)
                love.graphics.setColor(255, 255, 255, 255)
            end
        end
        love.graphics.setColor(255, 255, 255, 255)

    elseif self.about then
        love.graphics.setFont(UI_TEXT_FONT_48)
        local text = '-ABOUT-'
        local w = UI_TEXT_FONT_48:getWidth(text)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print(text, 400 - w/2 - 2, 48 - 2)
        love.graphics.print(text, 400 - w/2 - 2, 48 + 2)
        love.graphics.print(text, 400 - w/2 + 2, 48 - 2)
        love.graphics.print(text, 400 - w/2 + 2, 48 + 2)
        if self.settings_pointer == 1 then
            love.graphics.setColor(unpack(self.selected_color))
        else
            love.graphics.setColor(255, 255, 255, 255)
        end
        love.graphics.print(text, 400 - w/2, 48)

        for i, text in ipairs(self.about_texts) do
            local w = 0
            if i > 1 then
                love.graphics.setFont(UI_TEXT_FONT_16)
                w = UI_TEXT_FONT_16:getWidth(text)
                love.graphics.setColor(0, 0, 0, 255)
                love.graphics.print(text, 400 - w/2 - 2, 192+i*32 - 2)
                love.graphics.print(text, 400 - w/2 - 2, 192+i*32 + 2)
                love.graphics.print(text, 400 - w/2 + 2, 192+i*32 - 2)
                love.graphics.print(text, 400 - w/2 + 2, 192+i*32 + 2)
                love.graphics.setColor(255, 255, 255, 255)
                love.graphics.print(text, 400 - w/2, 192+i*32)
            else
                love.graphics.setFont(UI_TEXT_FONT_24)
                w = UI_TEXT_FONT_24:getWidth(text)
                love.graphics.setColor(0, 0, 0, 255)
                love.graphics.print(text, 400 - w/2 - 2, 128+i*48 - 2)
                love.graphics.print(text, 400 - w/2 - 2, 128+i*48 + 2)
                love.graphics.print(text, 400 - w/2 + 2, 128+i*48 - 2)
                love.graphics.print(text, 400 - w/2 + 2, 128+i*48 + 2)
                love.graphics.setColor(255, 255, 255, 255)
                love.graphics.print(text, 400 - w/2, 128+i*48)
            end
        end
        love.graphics.setColor(255, 255, 255, 255)

    else
        love.graphics.setFont(UI_TEXT_FONT_32)
        for i, option in ipairs(self.options) do
            local w = UI_TEXT_FONT_32:getWidth(option)
            love.graphics.setColor(0, 0, 0, 255)
            love.graphics.print(option, 400 - w/2 - 2, i*64 - 2)
            love.graphics.print(option, 400 - w/2 - 2, i*64 + 2)
            love.graphics.print(option, 400 - w/2 + 2, i*64 - 2)
            love.graphics.print(option, 400 - w/2 + 2, i*64 + 2)
            if self.pointer == i then
                love.graphics.setColor(unpack(self.selected_color))
            else
                love.graphics.setColor(255, 255, 255, 255)
            end
            love.graphics.print(option, 400 - w/2, i*64)
        end
        love.graphics.setColor(255, 255, 255, 255)
    end
end

function PausedMenu:keypressed(key)
    beholder.trigger('PLAY SOUND EFFECT', 'select')

    if key == 'k' or key == 'B' then
        self.settings = false
        self.about = false
        self.collection = false
        self.how2play = false
        self.controller = false
    end

    if key == 'up' or key == 'Up' or key == 'w' then
        if self.settings then
            self.settings_pointer = self.settings_pointer - 1
            if self.settings_pointer <= 0 then self.settings_pointer = 4 end
        else
            self.pointer = self.pointer - 1
            if self.pointer <= 0 then self.pointer = #self.options end
        end
    end

    if key == 'down' or key == 'Down' or key == 's' then
        if self.settings then
            self.settings_pointer = self.settings_pointer + 1
            if self.settings_pointer > 4 then self.settings_pointer = 1 end
        else
            self.pointer = self.pointer + 1
            if self.pointer > #self.options then self.pointer = 1 end
        end
    end

    if key == 'left' or key == 'Left' or key == 'a' then
        if self.settings then
            if self.settings_pointer == 1 then
                self.music_volume = self.music_volume - 0.05
                if self.music_volume < 0 then self.music_volume = 0 end
                beholder.trigger('SET MUSIC VOLUME', self.music_volume)
            elseif self.settings_pointer == 2 then
                self.game_volume = self.game_volume - 0.05
                if self.game_volume < 0 then self.game_volume = 0 end
                beholder.trigger('SET GAME VOLUME', self.game_volume)
            elseif self.settings_pointer == 3 then
                self.hold_to_jump = not self.hold_to_jump
            elseif self.settings_pointer == 4 then
                self.particles = self.particles - 1
                if self.particles < 0 then
                    self.particles = 1
                end
                beholder.trigger('SET PARTICLE RATE', self.particles)
            end
        elseif self.controller then
            love.system.openURL("file://" .. self.controller_texts[4])
        end
    end

    if key == 'right' or key == 'Right' or key == 'd' then
        if self.settings then
            if self.settings_pointer == 1 then
                self.music_volume = self.music_volume + 0.05
                if self.music_volume > 1 then self.music_volume = 1 end
                beholder.trigger('SET MUSIC VOLUME', self.music_volume)
            elseif self.settings_pointer == 2 then
                self.game_volume = self.game_volume + 0.05
                if self.game_volume > 1 then self.game_volume = 1 end
                beholder.trigger('SET GAME VOLUME', self.game_volume)
            elseif self.settings_pointer == 3 then
                self.hold_to_jump = not self.hold_to_jump
            elseif self.settings_pointer == 4 then
                self.particles = self.particles + 1
                if self.particles > 1 then
                    self.particles = 0
                end
                beholder.trigger('SET PARTICLE RATE', self.particles)
            end
        elseif self.controller then
            love.system.openURL(self.controller_texts[8])
        end
    end

    if key == 'return' or key == 'space' or key == 'j' or key == 'A' or key == 'X' then
        if not self.settings and not self.how2play and not self.controller and not self.about and not self.collection then
            if self.options[self.pointer] == 'resume' then
                beholder.trigger('UNPAUSE')
                beholder.trigger('CHANGE MUSIC VOLUME', 1)
                beholder.trigger('CHANGE GAME VOLUME', 1)

            elseif self.options[self.pointer] == 'restart' then
                beholder.trigger('UNPAUSE')
                beholder.trigger('CHANGE MUSIC VOLUME', 1)
                beholder.trigger('CHANGE GAME VOLUME', 1)
                beholder.trigger('END IT ALL')

            elseif self.options[self.pointer] == 'my collection' then
                self.collection = true

            elseif self.options[self.pointer] == 'settings' then
                self.settings = true

            elseif self.options[self.pointer] == 'about' then
                self.about = true

            elseif self.options[self.pointer] == 'how2play' then
                self.how2play = true

            elseif self.options[self.pointer] == 'controller?' then
                self.controller = true

            elseif self.options[self.pointer] == 'quit' then
                love.event.push('quit')
            end
        end
    end
end
