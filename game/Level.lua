require 'systems/Collision'
require 'systems/Spawner'
require 'systems/CameraShake'
require 'systems/Particle'
require 'game/mixins/LevelCreation'
require 'game/mixins/LevelLogic'
require 'game/mixins/Background'

Level = class('Level')
Level:include(Collector)
Level:include(LevelCreation)
Level:include(LevelLogic)
Level:include(Background)

-- This is where all systems and game objects get updated/draw.
-- Different level layouts, enemy spawns, game logic, etc, are loaded from the 'definitions'
-- folder to their appropriate systems or game objects.

function Level:initialize(name)
    self.name = name
    self.id = getUID()
    current_level_id = self.id

    self:collectorInit()

    -- Systems
    self.collision = Collision()
    self.spawner = nil
    self.camera = Camera(GAME_WIDTH/2, 320-128)
    self.camera_shake = CameraShake(self.camera)
    self.particle = Particle()
    
    -- Physics
    love.physics.setMeter(PHYSICS_METER)
    self.world = love.physics.newWorld(0, PHYSICS_METER*PHYSICS_GRAVITY, true)
    self.world:setCallbacks(self.collision.onEnter, self.collision.onExit) 

    -- Game objects
    self.player = nil
    self.itembox = nil
    self.all_objects = {}
    self.solids = {}
    self.projectiles = {}
    self.eprojectiles = {}
    self.enemies = {}
    self.flying_enemies = {}
    self.areas = {}
    self.lines = {}
    self.texts = {}
    self.mines = {}
    self.familiars = {}
    self.wall_doors = {}
    self.automata = {}
    self.projectiles_areas_bind = {}
    self.resources = {}
    self.shadows = {}
    -- self.player = Player(self.world, 400, 256)
    self:levelCreationInit()
    if n_levels < #self.player.passives + #self.player.familiars then n_levels = #self.player.passives + #self.player.familiars + added_difficulty end
    difficulty = math.max(math.floor(n_levels/1.5), math.floor((#self.player.passives + #self.player.familiars)/1.5))+1+added_difficulty
    print(self.id, difficulty)
    self:levelLogicInit()

    self.next_familiar_parent = nil
    self.next_familiar_parent = self.player

    if self.name ~= 'end' then self:backgroundInit() end

    -- Aux
    self.to_be_created = {}

    -- Messages
    self:collectorAddMessage(beholder.observe('REMOVE' .. self.id, function(object) self:remove(object) end))

    self:collectorAddMessage(beholder.observe('CREATE PLAYER SHADOW' .. self.id, function(x, y, direction, longer_fadeout, angled)
        table.insert(self.shadows, Shadow('Player', x, y, 36, 42, direction, longer_fadeout, angled))
    end))

    self:collectorAddMessage(beholder.observe('CREATE AUTOMATA' .. self.id, function(name, x, y, t_diff)
        table.insert(self.automata, Automata(name, x, y, t_diff))
    end))

    self:collectorAddMessage(beholder.observe('CREATE RESOURCE' .. self.id, function(name, x, y, api_type, api_name, marketed, no_impulse) 
        table.insert(self.to_be_created, {type = 'Resource', values = {name, x, y, api_type, api_name, marketed, no_impulse}})
    end))

    self:collectorAddMessage(beholder.observe('CREATE FAMILIAR' .. self.id, function(name, kill_after)
        table.insert(self.to_be_created, {type = 'Familiar', values = {self.player, name, kill_after}})
    end))

    self:collectorAddMessage(beholder.observe('CREATE LINE' .. self.id, function(p1, p2, angle, line_logic_type, line_logic_subtype, line_modifier)
        table.insert(self.to_be_created, {type = 'Line', values = {p1, p2, angle,
        line_logic_type, line_logic_subtype, line_modifier}})
    end))

    self:collectorAddMessage(beholder.observe('CREATE PROJECTILE' .. self.id, function(parent, x, y, angle, 
        projectile_movement_type, projectile_movement_subtype, projectile_modifier)
        table.insert(self.to_be_created, {type = 'Projectile', values = {parent, x, y, angle, 
        projectile_movement_type, projectile_movement_subtype, projectile_modifier}})
    end))

    self:collectorAddMessage(beholder.observe('CREATE AREA' .. self.id, function(x, y, area_logic_type, area_logic_subtype, area_modifier, check_size_flag, dont_spawn_particles)
        table.insert(self.to_be_created, {type = 'Area', values = {x, y,
        area_logic_type, area_logic_subtype, area_modifier, check_size_flag, dont_spawn_particles}})
    end))

    self:collectorAddMessage(beholder.observe('CREATE PROJECTILE AREA' .. self.id, function(parent, x, y, angle,
        projectile_movement_type, projectile_movement_subtype, projectile_modifier,
        area_logic_type, area_logic_subtype, area_modifier)
        table.insert(self.to_be_created, {type = 'ProjectileArea', values = {parent, x, y, angle, 
        projectile_movement_type, projectile_movement_subtype, projectile_modifier,
        area_logic_type, area_logic_subtype, area_modifier}})
    end))

    self:collectorAddMessage(beholder.observe('CREATE FLYING ENEMY' .. self.id, function(x, y, hard, type)
        table.insert(self.enemies, FlyingEnemy(self.world, x, y, hard, type))
    end))

    self:collectorAddMessage(beholder.observe('CREATE ENEMY' .. self.id, function(x, y, direction, hard, type)
        table.insert(self.enemies, Enemy(self.world, x, y, direction, hard, type))
    end))

    self:collectorAddMessage(beholder.observe('CREATE BEHOLDER' .. self.id, function(x, y, level)
        table.insert(self.enemies, Boss(self.world, x, y, 'beholder', level))
    end))

    self:collectorAddMessage(beholder.observe('CREATE MINE' .. self.id, function(x, y, mine_type)
        table.insert(self.to_be_created, {type = 'Mine', values = {x, y, mine_type}})
    end))

    self:collectorAddMessage(beholder.observe('ANGLE TEXT POP' .. self.id, function(text, x, y, r)
        MovingText.UID = MovingText.UID + 1
        table.insert(self.texts, MovingText(MovingText.UID, x, y, text, r))
        beholder.trigger('ANGLE MOVE TEXT' .. MovingText.UID, x, y)
    end))

    self:collectorAddMessage(beholder.observe('DAMAGE POP' .. self.id, function(x, y, damage)
        MovingText.UID = MovingText.UID + 1
        table.insert(self.texts, MovingText(MovingText.UID, x, y, damage))
        beholder.trigger('DAMAGE MOVE TEXT' .. MovingText.UID, x, y)
    end))

    self:collectorAddMessage(beholder.observe('CONDITION POP' .. self.id, function(attached_entity, x, y, text)
        MovingText.UID = MovingText.UID + 1
        local moving_text = MovingText(MovingText.UID, x, y, text)
        moving_text.attached_to = attached_entity
        table.insert(self.texts, moving_text)
        beholder.trigger('CONDITION MOVE TEXT' .. MovingText.UID, x, y)
    end))

    self:collectorAddMessage(beholder.observe('CREATE ITEMBOX' .. self.id, function(box_type)
        local getItemboxId = function() if self.itembox then return self.itembox.id else return nil end end
        local id = getItemboxId()
        local x, y = math.random(64, 736), table.choose(ITEMBOX_POSSIBLE_Y)
        self.itembox.body:destroy()
        self.itembox = nil
        table.insert(self.to_be_created, {type = 'ItemBox', values = {box_type, x, y}})
        table.insert(self.texts, MovingText(id, x, y, box_type))
    end))

    self:collectorAddMessage(beholder.observe('CREATE ITEMGET MOVINGTEXT BIG' .. self.id, function(id, text, x, y)
        table.insert(self.texts, MovingText(id, x, y, text))
        beholder.trigger('ITEMGET MOVE TEXT BIG' .. id, x, y)
    end))

    self:collectorAddMessage(beholder.observe('CREATE ITEMGET MOVINGTEXT SMALL' .. self.id, function(id, text, x, y)
        table.insert(self.texts, MovingText(id, x, y, text))
        beholder.trigger('ITEMGET MOVE TEXT SMALL' .. id, x, y)
    end))

    self:collectorAddMessage(beholder.observe('SHAKE' .. self.id, function(intensity, duration)
        self.camera_shake:add(intensity, duration)
    end))

    -- Wall hit,
    self:collectorAddMessage(beholder.observe('PROJECTILE PARTICLE SPAWN' .. self.id, function(name, proj, dir, colors)
        self.particle:spawn(name, {position = {x = proj.p.x, y = proj.p.y}, 
                                   direction = math.pi-proj.r,
                                   dir = dir,
                                   colors = colors,
                                   wh = {w = proj.w, h = proj.h}})
    end))

    -- Enemy hit,
    self:collectorAddMessage(beholder.observe('DIRECTIONAL PARTICLE SPAWN' .. self.id, function(name, x, y, dir, colors)
        self.particle:spawn(name, {position = {x = x, y = y},
                                   dir2 = dir,
                                   colors = colors,
                                   wh = {w = 8}})
    end))

    self:collectorAddMessage(beholder.observe('PARTICLE SPAWN' .. self.id, function(name, x, y, colors)
        self.particle:spawn(name, {position = {x = x, y = y}, colors = colors})
    end))

    -- Particle follows p; gets destroyed if p dies
    self:collectorAddMessage(beholder.observe('PARTICLE SPAWN FOLLOW' .. self.id, function(name, p, offset, colors) 
        self.particle:spawnFollow(name, {position = p, offset = offset, colors = colors})
    end))

    self:collectorAddMessage(beholder.observe('ENEMIES LIST REQUEST' .. self.id, function()
        beholder.trigger('ENEMIES LIST REPLY', self.enemies)
    end))

    self:collectorAddMessage(beholder.observe('PROJECTILES LIST REQUEST' .. self.id, function() 
        beholder.trigger('PROJECTILES LIST REPLY', self.projectiles) 
    end))

    self:collectorAddMessage(beholder.observe('AREA QUERY REQUEST' .. self.id, function(area_type, object_type, ...)
        beholder.trigger('AREA QUERY REPLY', self:queryArea(area_type, object_type, ...))
    end))

    self:collectorAddMessage(beholder.observe('PLAYER REQUEST' .. self.id, function()
        beholder.trigger('PLAYER REPLY', self.player)
    end))

    self:collectorAddMessage(beholder.observe('RESOURCE REQUEST' .. self.id, function()
        beholder.trigger('RESOURCE REPLY', self.resources)
    end))

    self.death = false
    self:collectorAddMessage(beholder.observe('DEAD', function()
        self.death = true
    end))
    for _, familiar in ipairs(p_familiars) do
        beholder.trigger('CREATE FAMILIAR' .. self.id, familiar)
    end

    updatePools(self.player)

    if self.name == 'market' then
        local positions = {
            {x = 400, y = 140}, {x = 256, y = 140}, {x = 544, y = 140}, 
            {x = 400, y = 440}, {x = 256, y = 440}, {x = 544, y = 440}
        }
        local items = {}
        local sori = dice(0.5)
        for i = 1, 6 do
            local flag = true
            while flag do
                if i <= 3 then
                    local api = pools['Market'][math.random(1, #pools['Market'])]
                    if not table.contains(items, api[2]) then
                        beholder.trigger('CREATE RESOURCE' .. self.id, 'API', positions[i].x, positions[i].y, api[1], api[2], true, true)
                        table.insert(items, api[2])
                        flag = false
                    end
                else
                    if sori then
                        beholder.trigger('CREATE RESOURCE' .. self.id, 'Surprise', positions[i].x, positions[i].y, 'Surprise', 'Surprise', true, true)
                        flag = false
                    else
                        local item = pools['ChestItem'][math.random(1, #pools['ChestItem'])]
                        if not table.contains(items, item[2]) then
                            beholder.trigger('CREATE RESOURCE' .. self.id, 'API', positions[i].x, positions[i].y, item[1], item[2], true, true)
                            table.insert(items, item[2])
                            flag = false
                        end
                    end
                end
            end
        end

    elseif string.match(self.name, 'item') then
        local items = {}
        local positions = {{x = 336, y = 340}, {x = 464, y = 340}}
        if dice(0.75) then
            local api = pools['Market'][math.random(1, #pools['Market'])]
            beholder.trigger('CREATE RESOURCE' .. self.id, 'API', 400, 340, api[1], api[2], false, true)
        else 
            for i = 1, 2 do
                local flag = true
                while flag do
                    local api = pools['Market'][math.random(1, #pools['Market'])]
                    if not table.contains(items, api[2]) then
                        beholder.trigger('CREATE RESOURCE' .. self.id, 'API', positions[i].x, positions[i].y, api[1], api[2], false, true)
                        table.insert(items, api[2])
                        flag = false
                    end
                end
            end
        end
        --[[
        else
            beholder.trigger('CREATE BEHOLDER' .. self.id, 400, 120, 1)
            self.boss = true
        end
        ]]--

    elseif string.match(self.name, 'tutorial') then
        for i, attack in ipairs(pools['Tutorial']) do
            beholder.trigger('CREATE RESOURCE' .. self.id, 'API', 400+math.random(-200, 200), 320+math.random(-520, 0), attack[1], attack[2], false, true)
        end

    elseif self.name == 'end' then
        beholder.trigger('CREATE RESOURCE' .. self.id, 'Surprise', 400, 256, 'Surprise', 'Surprise', false, true)
    end

    local run_file = love.filesystem.newFile('run')
    run_file:open('r')
    run_difficulty = run_file:read() + 1
    if run_difficulty > 7 then run_difficulty = 7 end
    r_diff_mult = math.round(0.0833333*run_difficulty + 0.916667, 1)
    print(run_difficulty)
end

function Level:update(dt)
    if self.destroyed then return end
    current_level_id = self.id
    -- updatePools(self.player)
    self.player:update(dt)
    if self.spawner then self.spawner:update(dt) end
    self.camera_shake:update(dt)
    self.particle:update(dt)
    if self.itembox then self.itembox:update(dt) end
    for _, projectile in ipairs(self.projectiles) do projectile:update(dt) end
    for _, area in ipairs(self.areas) do area:update(dt) end
    for _, line in ipairs(self.lines) do line:update(dt) end
    for _, enemy in ipairs(self.enemies) do enemy:update(dt) end
    for _, fenemy in ipairs(self.flying_enemies) do fenemy:update(dt) end
    for _, text in ipairs(self.texts) do text:update(dt) end
    for _, mine in ipairs(self.mines) do mine:update(dt) end
    for _, wall_door in ipairs(self.wall_doors) do wall_door:update(dt) end
    for _, automata in ipairs(self.automata) do automata:update(dt) end
    for _, familiar in ipairs(self.familiars) do familiar:update(dt) end
    for _, resource in ipairs(self.resources) do resource:update(dt) end
    for i = #self.shadows, 1, -1 do
        if self.shadows[i].dead then table.remove(self.shadows, i)
        else self.shadows[i]:update(dt) end
    end
    self:levelLogicUpdate(dt)
    if self.name ~= 'end' then self:backgroundUpdate(dt) end

    self.world:update(dt)
    self:safeRemoveGroup('projectiles')
    self:safeRemoveGroup('areas')
    self:safeRemoveGroup('lines')
    self:safeRemoveGroup('enemies')
    self:safeRemoveGroup('flying_enemies')
    self:safeRemoveGroup('mines')
    self:safeRemoveGroup('resources')
    self:safeRemoveGroup('wall_doors')
    self:safeRemoveGroup('solids')
    self:createObjectsPostWorldStep()
    if self.destroyed then self.world:destroy() end
end

function Level:draw()
    if self.name ~= 'end' then self:backgroundDraw() end
    if self.destroyed then return end
    self.camera:attach()
    self:levelCreationDraw()
    for _, solid in ipairs(self.solids) do solid:draw() end
    for _, wall_door in ipairs(self.wall_doors) do wall_door:draw() end
    for _, automata in ipairs(self.automata) do automata:draw() end
    for _, shadow in ipairs(self.shadows) do shadow:draw() end
    if self.itembox then self.itembox:draw() end
    for _, projectile in ipairs(self.projectiles) do projectile:draw() end
    for _, enemy in ipairs(self.enemies) do enemy:draw() end
    for _, fenemy in ipairs(self.flying_enemies) do fenemy:draw() end
    for _, mine in ipairs(self.mines) do mine:draw() end
    for _, familiar in ipairs(self.familiars) do familiar:draw() end
    self.player:draw()
    for _, resource in ipairs(self.resources) do resource:draw() end
    for _, line in ipairs(self.lines) do line:draw() end
    self.particle:draw()
    for _, area in ipairs(self.areas) do area:draw() end
    for _, text in ipairs(self.texts) do text:draw() end
    self.camera:detach()
end

function Level:queryArea(area_type, object_type, ...)
    local values = {...}
    local result = {}
    if area_type == 'circle' then
        -- Fetches all objects inside area with center (values[1], values[2]) and radius values[3]
        for _, object in ipairs(self[object_type]) do
            local dx, dy = math.abs(object.p.x - values[1]), math.abs(object.p.y - values[2])
            if math.sqrt(dx*dx + dy*dy) < values[3] then
                table.insert(result, object)
            end
        end
        local x, y = self.player.body:getPosition()
        local dx, dy = math.abs(x - values[1]), math.abs(y - values[2])
        if math.sqrt(dx*dx + dy*dy) < values[3] then
            table.insert(result, self.player)
        end
    end

    return result
end

-- Objects need to be created after the physics world has been updated otherwise bugs may occur. 
-- values[n] are passed from the 'CREATE object_type' messages (as seen in this class' constructor).
function Level:createObjectsPostWorldStep()
    -- Objects that were created should be removed from the to_be_created list
    local to_be_removed = {}

    for i, object in ipairs(self.to_be_created) do
        if object.type == 'Projectile' then
            local proj = Projectile(self.world, object.values[1], 
                                    object.values[2], object.values[3], object.values[4],
                                    object.values[5], object.values[6], object.values[7])
            table.insert(self.projectiles, proj)
            -- Projectile specific particle effects are initialized here (and in the ProjectileArea
            -- object.type too) because they need a reference to the projectile object and this
            -- is the only place where I can get that reference as the object is created.
            if object.values[1].spawnParticleEffects then
                object.values[1]:spawnParticleEffects(proj) 
            end
            if object.values[1].randomize then
                object.values[1]:randomize(proj)
            end

        elseif object.type == 'Area' then
            table.insert(self.areas, Area(self.world, nil,
                         object.values[1], object.values[2], object.values[3],
                         object.values[4], object.values[5], object.values[6], object.values[7]))

        elseif object.type == 'ProjectileArea' then
            local proj = Projectile(self.world, 
                         object.values[1], object.values[2], object.values[3],
                         object.values[4], object.values[5], object.values[6], object.values[7])
            table.insert(self.projectiles, proj)
            local area = Area(self.world, proj,
                         object.values[2], object.values[3],
                         object.values[8], object.values[9], object.values[10])
            table.insert(self.areas, area)
            if object.values[7].name ~= "Anivia's R" then
                if object.values[1].spawnParticleEffects then
                    object.values[1]:spawnParticleEffects(proj) 
                end
            else 
                if object.values[1].spawnParticleEffectsItem then
                    object.values[1]:spawnParticleEffectsItem(proj) 
                end
            end
            if object.values[1].randomize then
                object.values[1]:randomize(proj)
            end

        elseif object.type == 'Familiar' then
            local x, y = object.values[1].body:getPosition()
            local familiar = Familiar(self.world, object.values[1], object.values[2], x, y, object.values[3])
            table.insert(self.player.familiars, familiar)
            table.insert(self.familiars, familiar)
        
        elseif object.type == 'Resource' then
            local resource = Resource(self.world, object.values[1], object.values[2], object.values[3],
                                      object.values[4], object.values[5], object.values[6], object.values[7])
            table.insert(self.resources, resource)

        elseif object.type == 'Line' then
            local line = Line(self.world, 
                              object.values[1], object.values[2], object.values[3],
                              object.values[4], object.values[5], object.values[6])
            table.insert(self.lines, line)
            if self.player.current_attack.name == 'Brimstone' and line.line_modifier.name == 'Brimstone' then
                line:attach(object.values[1])
            end

        elseif object.type == 'ItemBox' then
            self.itembox = ItemBox(self.world, object.values[2], object.values[3], object.values[1])

        elseif object.type == 'Mine' then
            local mine = Mine(self.world, object.values[1], object.values[2], object.values[3])
            table.insert(self.mines, mine)
        end
    end
    self.to_be_created = {}
end

function Level:remove(object)
    -- Non physics world objects can be removed normally
    if instanceOf(MovingText, object) then
        table.remove(self.texts, findIndexByID(self.texts, object.id))
    end
end

function Level:destroy()
    local types = {'projectiles', 'areas', 'lines', 'enemies', 'flying_enemies', 'mines', 'wall_doors', 'solids', 'familiars', 'resources'}
    for _, type in ipairs(types) do
        for _, o in ipairs(self[type]) do
            o.dead = true
        end
    end
    self:safeRemoveGroup('projectiles')
    self:safeRemoveGroup('areas')
    self:safeRemoveGroup('lines')
    self:safeRemoveGroup('enemies')
    self:safeRemoveGroup('flying_enemies')
    self:safeRemoveGroup('mines')
    self:safeRemoveGroup('wall_doors')
    self:safeRemoveGroup('solids')
    self:safeRemoveGroup('familiars')
    self:safeRemoveGroup('resources')
    self.player = nil
    self.spawner = nil
    self.camera = nil
    self.collision = nil
    self.particle = nil
    self.camera_shake = nil
    self.projectiles_areas_bind = nil
    self.next_familiar_parent = nil
    for _, automata in ipairs(self.automata) do automata:collectorDestroy() end
    self.destroyed = true
end

function Level:safeRemoveGroup(type)
    -- Physics world objects should be removed after the world updates 
    for i = #self[type], 1, -1 do
        if self[type][i].dead then
            self[type][i].fixture:setUserData(nil)
            self[type][i].sensor:setUserData(nil)
            self[type][i].body:destroy()
            self[type][i]:collectorDestroy()
            table.remove(self[type], i)
        end
    end
end

function Level:keypressed(key)
    self.player:keypressed(key)
end

function Level:keyreleased(key)
    self.player:keyreleased(key)
end
