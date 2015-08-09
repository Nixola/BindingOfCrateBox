Particle = class('Particle')
local ParticleSystem = struct('creation_time', 'name', 'id', 'x', 'y', 'ps', 'follow', 'follow_offset')

function Particle:initialize()
    self.templates = loadstring("return " .. love.filesystem.read(main_pso))()
    self.particle_systems = {}
    self.to_be_removed = {}
    self.uid = 0
    self.rate = 1
end

function Particle:spawn(name, settings)
    self.uid = self.uid + 1
    local ps = self:createPS(self:findTemplateByName(name))
    table.insert(self.particle_systems, ParticleSystem(love.timer.getTime(), name, self.uid, nil, nil, ps))
    self:set(self.uid, settings)
end

function Particle:spawnFollow(name, settings)
    self.uid = self.uid + 1
    local ps = self:createPS(self:findTemplateByName(name))
    -- This PS will follow settings.position + settings.offset (offset should be set on PARTICLE SPAWN FOLLOW
    -- call, either a random number (for random offsets) or nil)
    table.insert(self.particle_systems, ParticleSystem(love.timer.getTime(), name, self.uid, nil, nil, ps, 
                                                       settings.position, settings.offset))
    self:set(self.uid, settings)
end


function Particle:findTemplateByName(name)
    for k, v in ipairs(self.templates) do
        if v.name == name then return v.template end
    end
end

function Particle:set(id, settings)
    local ps = self.particle_systems[findIndexByID(self.particle_systems, id)]
    if not ps then return end
    if settings then
        for k, v in pairs(settings) do
            -- if k == 'rotation' then self.particle_systems[findIndexByID(..., id)].ps:setRotation(settings.rotation) end
            -- add particle parameters as needed
            if k == 'position' then 
                ps.x = v.x
                ps.y = v.y
                
            elseif k == 'direction' then
                ps.ps:setDirection(v)

            elseif k == 'colors' then
                ps.ps:setColors(unpack(v))
            end
        end

        -- Player's attack flash particles
        -- Depending on the player's direction the position should be slightly adjusted
        if settings.dir then
            if settings.dir == 'right' then
                ps.x = ps.x - settings.wh.w
            elseif settings.dir == 'left' then
                ps.x = ps.x + settings.wh.w/2
            end
        end
        
        -- Enemy's, player's, decoy's body particles
        -- Depending on the direction should be slightly adjusted, since visuals aren't super centered
        if settings.dir2 then
            if settings.dir2 == 'left' then
                ps.x = ps.x + settings.wh.w
            elseif settings.dir2 == 'right' then
                ps.x = ps.x - settings.wh.w/2
            end
        end
    end
end

function Particle:createPS(template)
    local ps = love.graphics.newParticleSystem(square, template.buffer_size)
    ps:setBufferSize(template.buffer_size)
    local colors = {}
    for i = 1, 8 do
        if template.colors[i] then
            table.insert(colors, template.colors[i][1])
            table.insert(colors, template.colors[i][2])
            table.insert(colors, template.colors[i][3])
            table.insert(colors, template.colors[i][4])
        end
    end
    ps:setColors(unpack(colors))
    ps:setDirection(degToRad(template.direction))
    ps:setEmissionRate(template.emission_rate * self.rate)
    ps:setLinearAcceleration(0, template.gravity[1], 0, template.gravity[2])
    ps:setEmitterLifetime(template.lifetime)
    ps:setOffset(template.offset[1], template.offset[2])
    ps:setParticleLifetime(template.particle_life[1], template.particle_life[2])
    ps:setRadialAcceleration(template.radial_acc[1], template.radial_acc[2])
    ps:setRotation(degToRad(template.rotation[1]), degToRad(template.rotation[2]))
    ps:setSizeVariation(template.size_variation)
    ps:setSizes(unpack(template.sizes))
    ps:setSpeed(template.speed[1], template.speed[2])
    ps:setSpin(degToRad(template.spin[1]), degToRad(template.spin[2]))
    ps:setSpinVariation(template.spin_variation)
    ps:setSpread(degToRad(template.spread))
    ps:setTangentialAcceleration(template.tangent_acc[1], template.tangent_acc[2])
    return ps
end

function Particle:remove(id)
    local i = findIndexByID(self.particle_systems, id)
    if i then table.remove(self.particle_systems, i) end
end

-- Safe remove so no tables are changed while they're being iterated upon
function Particle:removePostUpdate()
    for _, id in ipairs(self.to_be_removed) do
        self:remove(id)
    end
    self.to_be_removed = {}
end

function Particle:update(dt)
    for i, p in ipairs(self.particle_systems) do
        p.ps:update(dt)

        -- Rotation correction
        p.ps:setOffset(10, 10)

        if p.follow then
            if p.follow.dead then table.insert(self.to_be_removed, p.id) end
            -- Follow enemy: (-6 = direction fix, should be changed in case of scaling/bigger enemies)
            if instanceOf(Enemy, p.follow) or instanceOf(FlyingEnemy, p.follow) then
                if p.follow.direction == 'left' then
                    p.x = p.follow.p.x + p.follow_offset.x - 6
                else p.x = p.follow.p.x - p.follow_offset.x end
                p.y = p.follow.p.y + p.follow_offset.y
            -- Follow projectile
            elseif instanceOf(Projectile, p.follow) then
                p.x = p.follow.p.x + p.follow_offset.x 
                p.y = p.follow.p.y + p.follow_offset.y
            end
        end
    
        if p.ps:getCount() == 0 then
            table.insert(self.to_be_removed, p.id)
        end
    end
    self:removePostUpdate()
end

function Particle:draw()
    if Particle.rate == 0 then return end
    for _, p in ipairs(self.particle_systems) do 
        if p.x and p.y then
            love.graphics.draw(p.ps, p.x*scale, p.y*scale, 0, scale, scale)
        end
    end
end

function Particle:setRate(newRate)
    self.rate = newRate
end

function Particle:getRate()
    print(self, self.rate)
end