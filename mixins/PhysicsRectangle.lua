PhysicsRectangle = {
    physicsRectangleInit = function(self, world, body_type, w, h)
        self.w = w
        self.h = h
        self.body = love.physics.newBody(world, self.p.x, self.p.y, body_type)
        self.shape = love.physics.newRectangleShape(w, h)

        self.fixture = love.physics.newFixture(self.body, self.shape)
        self.fixture:setCategory(unpack(collision_masks[self.class.name].categories))
        self.fixture:setMask(unpack(collision_masks[self.class.name].masks))
        self.fixture:setUserData(self)

        self.sensor = love.physics.newFixture(self.body, self.shape)
        self.sensor:setSensor(true)
        self.sensor:setUserData(self)
    end,

    physicsRectangleDraw = function(self)
        if debug_draw then
            love.graphics.setLineWidth(2)
            love.graphics.setColor(160, 160, 192)
            love.graphics.polygon('line', unpack(table.map({self.body:getWorldPoints(self.shape:getPoints())},
                function(point) return point*scale end)))
            love.graphics.setColor(255, 255, 255)
        end
    end
}
