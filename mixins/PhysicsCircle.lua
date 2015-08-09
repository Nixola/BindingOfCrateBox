PhysicsCircle = {
    physicsCircleInit = function(self, world, body_type, r)
        self.radius = r
        self.body = love.physics.newBody(world, self.p.x, self.p.y, body_type)
        self.shape = love.physics.newCircleShape(r)

        self.fixture = love.physics.newFixture(self.body, self.shape)
        self.fixture:setCategory(unpack(collision_masks[self.class.name].categories))
        self.fixture:setMask(unpack(collision_masks[self.class.name].masks))
        self.fixture:setUserData(self)

        self.sensor = love.physics.newFixture(self.body, self.shape)
        self.sensor:setSensor(true)
        self.sensor:setUserData(self)
    end,

    physicsCircleDraw = function(self)
        love.graphics.setColor(128, 128, 160)
        local x, y = self.body:getPosition()
        love.graphics.circle('line', x*scale, y*scale, self.shape:getRadius()*scale)
        love.graphics.setColor(255, 255, 255)
    end
}
