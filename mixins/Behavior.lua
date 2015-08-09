Behavior = {
    behaviorInit = function(self, direction)
        self.behavior_direction = direction
        self.can_move = true

        self:collectorAddMessage(beholder.observe('CHANGE DIRECTION' .. self.id, function() 
            if self.behavior_direction == 'RIGHT' then self.behavior_direction = 'LEFT'
            else self.behavior_direction = 'RIGHT' end
        end))
    end,

    behaviorUpdate = function(self, dt)
        if self.can_move then
            beholder.trigger('MOVE ' .. self.behavior_direction .. self.id)
            if self.p.x >= ENEMY_WALL_RIGHT then self.behavior_direction = 'LEFT' end
            if self.p.x <= ENEMY_WALL_LEFT then self.behavior_direction = 'RIGHT' end
        end
    end
}
