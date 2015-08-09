Solid = class('Solid', Entity)
Solid:include(Collector)
Solid:include(PhysicsRectangle)

function Solid:initialize(world, x, y, w, h, wall_door)
    Entity.initialize(self, x, y)
    self:collectorInit()
    self.wall_door = wall_door
    self:physicsRectangleInit(world, 'static', w or TILEW, h or TILEH)
end

function Solid:update(dt)

end

function Solid:draw()
    self:physicsRectangleDraw()
    if self.wall_door then
        love.graphics.draw(wall_door, self.p.x - self.w/2, self.p.y - self.h/2)
    end
end
