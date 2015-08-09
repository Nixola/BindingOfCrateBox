LevelCreation = {
    levelCreationInit = function(self)
        self.layout_data = {}
        self.width = nil
        self.height = nil
        self.tilew = nil
        self.tileh = nil
        self.offsety = 0
        if string.match(self.name, 'tutorial') then self.offsety = - 128 end
        self:levelCreationLoad()
    end,

    levelCreationLoad = function(self)
        local data = require("resources/" .. self.name)
        self.width = data.layers[1].width
        self.height = data.layers[1].height
        self.tilew = data.tilesets[1].tilewidth
        self.tileh = data.tilesets[1].tileheight
        for _, layer in ipairs(data.layers) do
            if layer.type == "objectgroup" then
                for _, object in ipairs(layer.objects) do
                    if object.type == "Player" then
                        self.player = Player(self.world, object.x, object.y+self.offsety)
                    elseif object.type == "Spawner" then
                        self.spawner = Spawner(self.name, object.x+object.width/2, object.y+object.height/2)
                    end
                end
            end
        end
        local to_be_created_automata = {}
        for _, layer in ipairs(data.layers) do
            if layer.type == "tilelayer" then
                for i = 1, self.height do
                    self.layout_data[i] = {}
                end
                local i, j = 1, 1
                for _, v in ipairs(layer.data) do
                    self.layout_data[i][j] = v
                    j = j + 1
                    if j > self.width then j = 1; i = i + 1 end
                end

            elseif layer.type == "objectgroup" then
                for _, object in ipairs(layer.objects) do
                    if object.type == "Solid" then
                        table.insert(self.solids,
                        Solid(self.world, 
                              object.x+object.width/2, object.y+object.height/2+self.offsety,
                              object.width, object.height))
                    elseif object.type == "WallDoor" then
                        table.insert(self.wall_doors,
                        Solid(self.world,
                              object.x+object.width/2, object.y+object.height/2+self.offsety,
                              object.width, object.height, true))
                    elseif object.type == "Automata" then
                        table.insert(to_be_created_automata, {x = object.x+object.width/2, y = object.y+object.height/2})
                    end
                end
            end
        end
        if #to_be_created_automata > 0 then
            if red_tower then
                local p = table.remove(to_be_created_automata, math.random(1, #to_be_created_automata))
                table.insert(self.automata, Automata('Tiki Trap', p.x, p.y, 'red'))
            end
            if blue_tower then
                local p = table.remove(to_be_created_automata, math.random(1, #to_be_created_automata))
                table.insert(self.automata, Automata('Tiki Trap', p.x, p.y, 'blue'))
            end
            if yellow_tower then
                local p = table.remove(to_be_created_automata, math.random(1, #to_be_created_automata))
                table.insert(self.automata, Automata('Tiki Trap', p.x, p.y, 'yellow'))
            end
            if green_tower then
                local p = table.remove(to_be_created_automata, math.random(1, #to_be_created_automata))
                table.insert(self.automata, Automata('Tiki Trap', p.x, p.y, 'green'))
            end
        end
        to_be_created_automata = nil
    end,
    
    levelCreationDraw = function(self)
        for i = 1, self.height do
            for j = 1, self.width do
                if self.layout_data[i][j] ~= 0 then
                    love.graphics.draw(environment_32[self.layout_data[i][j]],
                                      (j-1)*self.tilew, (i-1)*self.tileh+self.offsety)
                end
            end
        end
    end
}
