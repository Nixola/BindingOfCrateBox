DungeonLogic = {
    dungeonLogicInit = function(self)
        self.current_room = nil
        self.last_room = nil

        --[[
        Identify groups in the grid
        A group = vertical or horizontal sequence of tiles
        For each group create one solid only
        Layout data drawn over accordingly
        ]]--
    end,

    dungeonLogicUpdate = function(self, dt)

    end
}
