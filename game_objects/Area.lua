Area = class('Area', Entity)
Area:include(Collector)
Area:include(PhysicsRectangle)
Area:include(PhysicsCircle)
Area:include(MovableAreaProjectile)
Area:include(Logic)
Area:include(LogicArea)

function Area:initialize(world, parent, x, y, area_logic_type, area_logic_subtype, area_modifier, check_size_flag, dont_spawn_particles)
    Entity.initialize(self, x, y)    
    self:collectorInit()
    self:physicsCircleInit(world, 'dynamic', areas_logic[area_logic_type][area_logic_subtype].r_i)
    self:logicAreaInit(parent, area_logic_type, area_logic_subtype, area_modifier, check_size_flag, dont_spawn_particles)
    self:logicInit(1)
end

function Area:update(dt)
    self:logicAreaUpdate(dt)
end

function Area:draw()
    if self.area_modifier.name ~= "Anivia's R" then
        local x, y = self.body:getPosition()
        local s = self.radius/256
        love.graphics.setColor(unpack(self.area_color))
        love.graphics.draw(area, x - self.radius, y - self.radius, 0, s, s)
        love.graphics.setColor(colors.white)
        -- self:physicsCircleDraw()
    end
end
