Line = class('Line', Entity)
Line:include(Collector)
Line:include(PhysicsLine)
Line:include(LogicLine)

function Line:initialize(world, p1, p2, angle, line_logic_type, line_logic_subtype, line_modifier)
    print('Line')
    Entity.initialize(self, 0, 0)
    self:collectorInit()
    self:physicsLineInit(world, 'dynamic', p1.x, p1.y, p2.x, p2.y)
    self:logicLineInit(world, p1, p2, line_logic_type, line_logic_subtype, line_modifier)
end

function Line:update(dt)
    self:logicLineUpdate(dt)
end

function Line:draw()
    self:logicLineDraw()
end
