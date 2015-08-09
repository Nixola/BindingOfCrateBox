Entity = class('Entity')

function Entity:initialize(x, y)
    self.id = getUID()
    self.p = Vector(x or 0, y or 0)
    self.dead = false
end
