LogicActivation = {
    logicActivationInit = function(self)
        self.can_attack_press = true
        self.can_attack_down = true
        self.can_item_press = true
        self.can_item_down = true
        self.attacking = false
        self.activated = false
        self.activated_cid = nil

        self:collectorAddMessage(beholder.observe('ATTACK PRESSED' .. self.id, function() 
            if self.current_attack then
                if self.can_attack_press then
                    self:attack('press')
                    self.can_attack_press = false
                    self:collectorAddTimer(main_chrono:after(self.current_attack.cooldown, function() 
                        self.can_attack_press = true 
                    end))
                end
            end
        end))

        self:collectorAddMessage(beholder.observe('ATTACK' .. self.id, function()
           if self.current_attack then
                if self.current_attack.activation_delay then
                    if not self.activated then
                        self.activated = true
                        self.can_attack_down = false
                        local id = main_chrono:after(self.current_attack.activation_delay, function()
                            self.can_attack_down = true 
                        end)
                        self:collectorAddTimer(id)
                        self.activated_cid = id.id
                    end
                end

                if self.can_attack_down then
                    self:attack('down')
                    self.can_attack_down = false
                    self.attacking = true
                    self:collectorAddTimer(main_chrono:after(self.current_attack.cooldown, function() 
                        self.can_attack_down = true 
                        self.attacking = false
                    end))
                end
            end
        end))

        self:collectorAddMessage(beholder.observe('ATTACK RELEASED' .. self.id, function()
            if self.current_attack then
                self:attack('release')
                if self.current_attack.activation_delay then
                    self.activated = false
                    if self.activated_cid then main_chrono:cancel(self.activated_cid) end
                end
            end
        end))

        self:collectorAddMessage(beholder.observe('USE PRESSED' .. self.id, function()
            if self.current_item then
                if self.can_item_press then
                    self:useActiveItem('press')
                    self.can_item_press = false
                    self:collectorAddTimer( main_chrono:after(self.current_item.cooldown or 0, function()
                        self.can_item_press = true
                    end))
                end
            end
        end))

        self:collectorAddMessage(beholder.observe('USE' .. self.id, function()
            if self.current_item then
                if self.can_item_down then
                    self:useActiveItem('down')
                    self.can_item_down = false
                    self:collectorAddTimer(main_chrono:after(self.current_item.cooldown or 0, function()
                        self.can_item_down = true
                    end))
                end
            end
        end))
    end
}
