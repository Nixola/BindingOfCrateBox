ItemBox = class('ItemBox', Entity)
ItemBox:include(Collector)
ItemBox:include(PhysicsRectangle)
ItemBox:include(Movable)
ItemBox:include(Logic)

function ItemBox:initialize(world, x, y, box_type)
    print('ItemBox')
    Entity.initialize(self, x, y)
    self:collectorInit()
    self:physicsRectangleInit(world, 'dynamic', ITEMBOXW, ITEMBOXH)
    self:movableInit(ITEMBOXA, ITEMBOX_MAX_VELOCITY, ITEMBOX_GRAVITY_SCALE)
    self:logicInit(1)
    self.box_type = box_type
end

function ItemBox:update(dt)
    self:movableUpdate(dt)
    self:logicUpdate(dt)
end

function ItemBox:draw()
    love.graphics.draw(itembox, self.p.x*scale-self.w*scale/2, self.p.y*scale-self.h*scale/2)
    self:physicsRectangleDraw()
end
