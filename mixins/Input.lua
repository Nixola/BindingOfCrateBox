Input = {
    inputInit = function(self, in_action_keys)
        self.key_action = {}
        self.key_action.down = {}
        self.key_action.press = {}
        self.key_action.release = {}
        self:updateActionKeys(in_action_keys)
        self.input_disabled = false

        self:collectorAddMessage(beholder.observe('DISABLE INPUT' .. self.id, function(d)
            self.input_disabled = true
            self:collectorAddTimer(main_chrono:after(d, function() self.input_disabled = false end))
        end))
    end,

    updateActionKeys = function(self, in_action_keys)
        for _, map_key in ipairs(in_action_keys) do
            for _, key in ipairs(map_key.keys) do
                self.key_action[map_key.type][key] = map_key.action
            end
        end
    end,

    inputUpdate = function(self, dt)
        if self.input_disabled then return end
        for key, action in pairs(self.key_action.down) do
            if controller then
                if controller.Dpad[key] then
                    beholder.trigger(action .. self.id, 'down')
                    for _, familiar in ipairs(self.familiars) do
                        beholder.trigger(action .. familiar.id, 'down')
                    end
                end
                if controller.Buttons[key] then
                    beholder.trigger(action .. self.id, 'down')
                    for _, familiar in ipairs(self.familiars) do
                        beholder.trigger(action .. familiar.id, 'down')
                    end
                end
            end
            if love.keyboard.isDown(key) then
                beholder.trigger(action .. self.id, 'down')
                for _, familiar in ipairs(self.familiars) do
                    beholder.trigger(action .. familiar.id, 'down')
                end
            end
        end
    end,

    inputKeypressed = function(self, in_key)
        if self.input_disabled then return end
        for key, action in pairs(self.key_action.press) do
            if key == in_key then 
                beholder.trigger(action .. self.id, 'press') 
                for _, familiar in ipairs(self.familiars) do
                    beholder.trigger(action .. familiar.id, 'press') 
                end
            end
        end
    end,

    inputKeyreleased = function(self, in_key)
        if self.input_disabled then return end
        for key, action in pairs(self.key_action.release) do
            if key == in_key then 
                beholder.trigger(action .. self.id, 'release') 
                for _, familiar in ipairs(self.familiars) do
                    beholder.trigger(action .. familiar.id, 'release') 
                end
            end
        end
    end
}
