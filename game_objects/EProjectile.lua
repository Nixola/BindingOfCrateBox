EProjectile = class('EProjectile', Entity)
EProjectile:include(Collector)
EProjectile:include(PhysicsRectangle)
EProjectile:include(Steerable)
EProjectile:include(EProjectileVisual)

function EProjectile:initialize(world, owner, type, x, y, angle)
    Entity.initialize(self, x, y)
    self.owner = owner
    self.type = type
    self:collectorInit()
    self:physicsRectangleInit(world, 'dynamic', eprojectiles[type].w, eprojectiles[type].h)
    self:steerableInit(angle, eprojectiles[type].max_v, eprojectiles[type].max_f)
    self:eProjectileVisualInit()
end

function EProjectile:update(dt)
    self:steerableUpdate(dt)
end

function EProjectile:draw()
    self:eProjectileVisualDraw()
end
