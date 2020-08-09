UI = class('UI')

function UI:initialize(p)
    self.p = p
    
    self.player_ref = nil
    beholder.observe('PLAYER REPLY', function(player) self.player_ref = player end)

    self.ui_text_name = nil
    self.ui_text_desc = nil
    self.ui_text_other = nil
    self.ui_text_flag = false
    self.td_px = -100
    self.td_py = 640-28
    self.td_tid = nil
    self.td_cid = nil
    self.final_room = false
    beholder.observe('FINAL ROOM', function()
        self.final_room = true
        main_chrono:every(0.4, 10, function()
            self.final_room = not self.final_room
        end)
        main_chrono:after(4.6, function() self.final_room = false end)
    end)
    self.unlock_texts = {}
    self.unlock_colors1 = 0
    self.unlock_colors2 = 0
    self.unlock_colors3 = 0
    beholder.observe('UNLOCK TEXT', function(text)
        table.insert(self.unlock_texts, text)
        local i = #self.unlock_texts
        if i == 1 then main_tween(1, self, {unlock_colors1 = 1}, 'linear')
        elseif i == 2 then main_tween(1, self, {unlock_colors2 = 1}, 'linear')
        elseif i == 3 then main_tween(1, self, {unlock_colors3 = 1}, 'linear'); end
    end)
    beholder.observe('UI TEXT', function(api_type, api_name) 
        if api_type == 'Passive' or api_type == 'Item' then
            local list = nil
            if api_type == 'Passive' then list = passives end
            if api_type == 'Item' then list = items end
            if not self.ui_text_flag then
                self.ui_text_flag = true
                self.ui_text_name = api_name
                self.ui_text_desc = list[api_name].desc_text or ''
                if #list[api_name].other_text > 0 then
                    self.ui_text_other = list[api_name].other_text[math.random(1, #list[api_name].other_text)]
                else self.ui_text_other = '' end
                self.td_tid = main_tween(0.5, self, {td_px = 6}, 'outBack')
                self.td_cid = main_chrono:after(4, function()
                    local w = UI_TEXT_FONT_16:getWidth(self.ui_text_desc)
                    local w2 = UI_TEXT_FONT_16:getWidth(self.ui_text_other)
                    if w2 > w then w = w2 end
                    self.td_tid = main_tween(0.5, self, {td_px = -w - 32}, 'inBack')
                end):after(1, function() self.ui_text_flag = false end)
            else
                main_chrono:cancel(self.td_cid.id)
                main_tween.stop(self.td_tid)
                self.ui_text_flag = true
                self.ui_text_name = api_name
                self.ui_text_desc = list[api_name].desc_text or ''
                if #list[api_name].other_text > 0 then
                    self.ui_text_other = list[api_name].other_text[math.random(1, #list[api_name].other_text)]
                else self.ui_text_other = '' end
                self.td_tid = main_tween(0.5, self, {td_px = 6}, 'outBack')
                self.td_cid = main_chrono:after(4, function()
                    local w = UI_TEXT_FONT_16:getWidth(self.ui_text_desc)
                    local w2 = UI_TEXT_FONT_16:getWidth(self.ui_text_other)
                    if w2 > w then w = w2 end
                    self.td_tid = main_tween(0.5, self, {td_px = -w - 32}, 'inBack')
                end):after(1, function() self.ui_text_flag = false end)
            end
        end
    end)
end

function UI:update(dt)

end

function UI:draw()
    if current_map_name == 'end' then 
        love.graphics.setColor(colors.white)
        love.graphics.setFont(UI_TEXT_FONT_32)
        for i, text in ipairs(self.unlock_texts) do
            local t = ("unlocked " .. text .. "!")
            local w = UI_TEXT_FONT_32:getWidth(t)
            if i == 1 then love.graphics.setColor(colors.black(self.unlock_colors1))
            elseif i == 2 then love.graphics.setColor(colors.black(self.unlock_colors2))
            elseif i == 3 then love.graphics.setColor(colors.black(self.unlock_colors3)) end
            love.graphics.print(t, 400 - w/2 - 1, 128 + 48*(i-1) - 1)
            love.graphics.print(t, 400 - w/2 - 1, 128 + 48*(i-1) + 1)
            love.graphics.print(t, 400 - w/2 + 1, 128 + 48*(i-1) - 1)
            love.graphics.print(t, 400 - w/2 + 1, 128 + 48*(i-1) + 1)
            if i == 1 then love.graphics.setColor(colors.white(self.unlock_colors1))
            elseif i == 2 then love.graphics.setColor(colors.white(self.unlock_colors2))
            elseif i == 3 then love.graphics.setColor(colors.white(self.unlock_colors3)) end
            love.graphics.print(t, 400 - w/2, 128 + 48*(i-1))
            love.graphics.setColor(colors.white)
        end
        return 
    end
    love.graphics.draw(ui_bg, self.p.x, self.p.y)
    love.graphics.draw(ui_separator, self.p.x + 200, self.p.y)
    love.graphics.draw(ui_separator, self.p.x + 800-208, self.p.y)
    love.graphics.draw(ui_separator_2, self.p.x + 800-200-4, self.p.y + 80)
    local px, py = 0, 0

    if self.final_room then
        love.graphics.setColor(colors.white)
        love.graphics.setFont(UI_TEXT_FONT_48)
        local t = 'FINAL ROOM!!1!'
        local w = UI_TEXT_FONT_48:getWidth(t)
        love.graphics.setColor(colors.black)
        love.graphics.print(t, 400 - w/2 - 1, 96 - 1)
        love.graphics.print(t, 400 - w/2 - 1, 96 + 1)
        love.graphics.print(t, 400 - w/2 + 1, 96 - 1)
        love.graphics.print(t, 400 - w/2 + 1, 96 + 1)
        love.graphics.setColor(colors.white)
        love.graphics.print(t, 400 - w/2, 96)
        t = 'DANGER, DANGER, DANGER!!!!!!1111111!!'
        w = UI_TEXT_FONT_48:getWidth(t)
        love.graphics.setColor(colors.black)
        love.graphics.print(t, 400 - w/2 - 1, 160 - 1)
        love.graphics.print(t, 400 - w/2 - 1, 160 + 1)
        love.graphics.print(t, 400 - w/2 + 1, 160 - 1)
        love.graphics.print(t, 400 - w/2 + 1, 160 + 1)
        love.graphics.setColor(colors.white)
        love.graphics.print(t, 400 - w/2, 160)
    end


    if self.ui_text_flag then
        local w = UI_TEXT_FONT_16:getWidth(self.ui_text_desc)
        love.graphics.setFont(UI_TEXT_FONT_16)
        love.graphics.setColor(colors.black)
        love.graphics.print(self.ui_text_desc, self.td_px-1, self.td_py-1)
        love.graphics.print(self.ui_text_desc, self.td_px-1, self.td_py+1)
        love.graphics.print(self.ui_text_desc, self.td_px+1, self.td_py+1)
        love.graphics.print(self.ui_text_desc, self.td_px+1, self.td_py-1)
        love.graphics.setColor(colors.white)
        love.graphics.print(self.ui_text_desc, self.td_px, self.td_py)
        
        w = UI_TEXT_FONT_16:getWidth(self.ui_text_other)
        px, py = 800 - self.td_px - w, self.td_py
        love.graphics.setFont(UI_TEXT_FONT_16)
        love.graphics.setColor(colors.black)
        love.graphics.print(self.ui_text_other, px-1, py-1)
        love.graphics.print(self.ui_text_other, px-1, py+1)
        love.graphics.print(self.ui_text_other, px+1, py+1)
        love.graphics.print(self.ui_text_other, px+1, py-1)
        love.graphics.setColor(colors.white)
        love.graphics.print(self.ui_text_other, px, py)
    end

    beholder.trigger('PLAYER REQUEST' .. current_level_id)

    love.graphics.setFont(UI_TEXT_FONT_24)
    love.graphics.draw(coin, 800-200+12, self.p.y + 98)
    px, py = self.p.x + 800-200+32, self.p.y + 86
    love.graphics.setColor(colors.black)
    love.graphics.print("x" .. money, px-1, py-1)
    love.graphics.print("x" .. money, px-1, py+1)
    love.graphics.print("x" .. money, px+1, py+1)
    love.graphics.print("x" .. money, px+1, py-1)
    love.graphics.setColor(colors.white)
    love.graphics.print("x" .. money, px, py)

    love.graphics.setFont(UI_TEXT_FONT_24)
    love.graphics.draw(bomb, 800-100-4, self.p.y + 90)
    px, py = self.p.x + 800-100+32, self.p.y + 86
    love.graphics.setColor(colors.black)
    love.graphics.print("x" .. bombs, px-1, py-1)
    love.graphics.print("x" .. bombs, px-1, py+1)
    love.graphics.print("x" .. bombs, px+1, py+1)
    love.graphics.print("x" .. bombs, px+1, py-1)
    love.graphics.setColor(colors.white)
    love.graphics.print("x" .. bombs, px, py)

    -- BUFFS
    love.graphics.setFont(UI_TEXT_FONT_16)
    for i, buff in ipairs(self.player_ref.buffs) do
        love.graphics.draw(resources[buff.name].visual, 8+(i-1)*32, 128+8)
        if item_specific[buff.name] then
            local t = item_specific[buff.name].duration*effect_duration_multiplier - (love.timer.getTime() - buff.t)
            t = math.round(t, 0)
            local wb = UI_TEXT_FONT_16:getWidth(tostring(t))
            local image = resources[buff.name].visual
            local w, h = image:getWidth(), image:getHeight()
            px, py = 8+(i-1)*32+w/2-wb/2, 128+8+h
            love.graphics.setColor(colors.black)
            love.graphics.print(tostring(t), px-1, py-1)
            love.graphics.print(tostring(t), px+1, py+1)
            love.graphics.print(tostring(t), px-1, py+1)
            love.graphics.print(tostring(t), px+1, py-1)
            love.graphics.setColor(colors.white)
            love.graphics.print(tostring(t), px, py)
        end
    end

    -- ITEMS
    local wa = UI_TEXT_FONT_16:getWidth("attack")
    local wi = UI_TEXT_FONT_16:getWidth("item")
    love.graphics.setFont(UI_TEXT_FONT_16)
    px, py = self.p.x + 800-200+50-wa/2, self.p.y + 12
    love.graphics.setColor(colors.black)
    love.graphics.print("attack", px-1, py-1)
    love.graphics.print("attack", px+1, py+1)
    love.graphics.print("attack", px-1, py+1)
    love.graphics.print("attack", px+1, py-1)
    love.graphics.setColor(colors.white)
    love.graphics.print("attack", px, py)
    if self.player_ref.current_attack then
        local image = resources[self.player_ref.current_attack.name].visual
        local w, h = image:getWidth(), image:getHeight()
        px, py = self.p.x + 800-200+50-w/2, self.p.y + 48-h/2
        love.graphics.draw(image, px, py + 6)
    end

    px, py = self.p.x + 800-100+50-wi/2, self.p.y + 12
    love.graphics.setColor(colors.black)
    love.graphics.print("item", px-1, py-1)
    love.graphics.print("item", px+1, py+1)
    love.graphics.print("item", px-1, py+1)
    love.graphics.print("item", px+1, py-1)
    love.graphics.setColor(colors.white)
    love.graphics.print("item", px, py)
    if self.player_ref.current_item then
        if self.player_ref.current_item.name ~= 'Empty' then
            local image = resources[self.player_ref.current_item.name].visual
            local w, h = image:getWidth(), image:getHeight()
            px, py = self.p.x + 800-100+50-w/2, self.p.y + 48-h/2
            love.graphics.draw(image, px, py + 6)
        end
    end

    -- ICONS
    love.graphics.setFont(UI_TEXT_FONT_16)
    wi = UI_TEXT_FONT_16:getWidth("passives")
    px, py = self.p.x + 400-wi/2, self.p.y + 12
    love.graphics.setColor(colors.black)
    love.graphics.print("passives", px-1, py-1)
    love.graphics.print("passives", px+1, py+1)
    love.graphics.print("passives", px-1, py+1)
    love.graphics.print("passives", px+1, py-1)
    love.graphics.setColor(colors.white)
    love.graphics.print("passives", px, py)
    local n_px, n_py = 1, 1
    for _, passive in ipairs(self.player_ref.passives) do
        local image = resources[passive].visual
        local w, h = image:getWidth(), image:getHeight()
        love.graphics.draw(resources[passive].visual, 212+(n_px-1)*32+16-w/2, 8+n_py*26+16-h/2)
        n_px = n_px + 1
        if n_px > 12 then
            n_px = 1
            n_py = n_py + 1
        end
    end

    -- HEALTH
    local y = 38
    -- Draw life text
    local wh = UI_TEXT_FONT_16:getWidth("health")
    px, py = self.p.x + 5+93-wh/2, self.p.y + 12
    love.graphics.setColor(colors.black)
    love.graphics.print("health", px-1, py-1)
    love.graphics.print("health", px+1, py+1)
    love.graphics.print("health", px-1, py+1)
    love.graphics.print("health", px+1, py-1)
    love.graphics.setColor(colors.white)
    love.graphics.print("health", px, py)
    -- Draw hearts
    for i = 1, self.player_ref.stats.max_hp do
        if i <= 6 then
            love.graphics.draw(empty_heart_32, self.p.x + 32*(i-1) + 5, self.p.y + y)
        else
            love.graphics.draw(plus, self.p.x + 32*6 - 5, self.p.y + y - 5)
        end
    end
    if self.player_ref.stats.hp > 0 and self.player_ref.stats.hp < 1 then
        love.graphics.draw(half_heart_32, self.p.x + 32*(0) + 5, self.p.y + y)
    else
        for i = 1, self.player_ref.stats.hp do
            if i <= 6 then
                love.graphics.draw(heart_32, self.p.x + 32*(i-1) + 5, self.p.y + y)
                local d = self.player_ref.stats.hp - i
                if i ~= 6 then
                    if d > 0 and d < 1 then
                        local r = self.player_ref.stats.hp % 1
                        if r >= 0.5 then
                            love.graphics.draw(half_heart_32, self.p.x + 32*(i) + 5, self.p.y + y)
                        end
                    end
                end
            else
                love.graphics.draw(plus, self.p.x + 32*6 - 5, self.p.y + y - 5)
            end
        end
    end
    -- Draw masks
    if self.player_ref.stats.mask > 0 and self.player_ref.stats.mask < 1 then
        love.graphics.draw(half_mask_32, self.p.x + 32*(0) + 5, self.p.y + 2*y + 3)
    else
        for i = 1, self.player_ref.stats.mask do
            if i <= 6 then
                love.graphics.draw(mask_32, self.p.x + 32*(i-1) + 5, self.p.y + 2*y + 3)
                local d = self.player_ref.stats.mask - i
                if i ~= 6 then
                    if d > 0 and d < 1 then
                        local r = self.player_ref.stats.mask % 1
                        if r >= 0.5 then
                            love.graphics.draw(half_mask_32, self.p.x + 32*(i) + 5, self.p.y + 2*y + 3)
                        end
                    end
                end
            else
                love.graphics.draw(plus, self.p.x + 32*6 - 5, self.p.y + 2*y - 5 + 3)
            end
        end
    end

    self.player_ref = nil
end
