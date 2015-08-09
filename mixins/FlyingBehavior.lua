FlyingBehavior = {
    flyingBehaviorInit = function(self)
        self.player_ref = nil
        self:collectorAddMessage(beholder.observe('PLAYER REPLY', function(player)
            self.player_ref = player
        end))
    end,

    flyingBehaviorUpdate = function(self, dt)
        self.current_behavior = 'arrival'
        beholder.trigger('PLAYER REQUEST' .. current_level_id)
        local x, y = self.player_ref.body:getPosition()
        self.target = Vector(x, y)
        self.player_ref = nil
    end
}
