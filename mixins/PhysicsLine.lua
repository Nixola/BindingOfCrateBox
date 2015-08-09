PhysicsLine = {
    physicsLineInit = function(self, world, body_type, x1, y1, x2, y2)
        self.body = love.physics.newBody(world, self.p.x, self.p.y, body_type)
        self.body:setGravityScale(0)
        self.shape = love.physics.newEdgeShape(x1, y1, x2, y2)

        self.fixture = love.physics.newFixture(self.body, self.shape)
        self.fixture:setCategory(unpack(collision_masks[self.class.name].categories))
        self.fixture:setMask(unpack(collision_masks[self.class.name].masks))
        self.fixture:setUserData(self)

        self.sensor = love.physics.newFixture(self.body, self.shape)
        self.sensor:setSensor(true)
        self.sensor:setUserData(self)
    end
}
