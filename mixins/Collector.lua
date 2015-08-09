-- This mixin exists to destroy tweens, timers and messages created to the tween, chrono and beholder libraries,
-- respectively. All those libraries are currently globals that use some sort of hash map with a register/trigger
-- event system. Since they are globals, objects can freely register __ into those functions but when they
-- get destroyed those __ wouldn't and would take up a lot of memory. 

-- Adding this mixin to every object that makes use of those libraries and calling collectorDestroy before the 
-- object gets destroyed should take care of that.
Collector = {
    collectorInit = function(self)
        self.messages = {}
        self.timers = {}
        self.tweens = {}
    end,

    collectorAddMessage = function(self, message_id)
        table.insert(self.messages, message_id)
    end,

    collectorAddTimer = function(self, timer_id)
        table.insert(self.timers, timer_id.id)
    end,

    collectorAddTween = function(self, tween_id)
        table.insert(self.tweens, tween_id)
    end,

    collectorDestroy = function(self)
        for _, m in ipairs(self.messages) do beholder.stopObserving(m) end
        for _, t in ipairs(self.timers) do main_chrono:cancel(t) end
        for _, t in ipairs(self.tweens) do main_tween.stop(t) end
    end
}
