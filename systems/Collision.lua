-- Doesn't need to be a class.

Collision = class('Collision')

function Collision:initialize()
    
end

function Collision.onEnter(fixture_a, fixture_b, contact)
    local a, b = fixture_a:getUserData(), fixture_b:getUserData()
    local nx, ny = contact:getNormal()

    -- When both are sensors = they shouldn't physically collide/reject/push
    -- but logically something should happen.
    if fixture_a:isSensor() and fixture_b:isSensor() then
        if collIf('Player', 'Enemy', a, b) then
            a, b = collEnsure('Player', a, 'Enemy', b)
            a:collisionEnemy(b)

        elseif collIf('Player', 'ItemBox', a, b) then
            a, b = collEnsure('Player', a, 'ItemBox', b)
            a:collisionItemBox(b)

        elseif collIf('Projectile', 'Enemy', a, b) then
            a, b = collEnsure('Projectile', a, 'Enemy', b)
            a:collisionEnemy(b)

        elseif collIf('Projectile', 'FlyingEnemy', a, b) then
            a, b = collEnsure('Projectile', a, 'FlyingEnemy', b)
            a:collisionEnemy(b)

        elseif collIf('Projectile', 'Boss', a, b) then
            a, b = collEnsure('Projectile', a, 'Boss', b)
            a:collisionEnemy(b)

        elseif collIf('Projectile', 'Player', a, b) then
            a, b = collEnsure('Projectile', a, 'Player', b)
            a:collisionPlayer(b)
        
        elseif collIf('Player', 'Resource', a, b) then
            a, b = collEnsure('Player', a, 'Resource', b)
            b:collisionPlayer(a)

        elseif collIf('Enemy', 'Enemy', a, b) then
            a, b = collEnsure('Enemy', a, 'Enemy', b)
            a:collisionEnemy(b)

        elseif collIf('Enemy', 'FlyingEnemy', a, b) then
            a, b = collEnsure('Enemy', a, 'FlyingEnemy', b)
            a:collisionEnemy(b)

        elseif collIf('FlyingEnemy', 'FlyingEnemy', a, b) then
            a, b = collEnsure('FlyingEnemy', a, 'FlyingEnemy', b)
            a:collisionEnemy(b)
        end

    -- When both are not sensors = they should physically collide/reject/push each other
    elseif not (fixture_a:isSensor() or fixture_b:isSensor()) then
        if collIf('Player', 'Solid', a, b) then
            a, b = collEnsure('Player', a, 'Solid', b)
            a:collisionSolid(b, nx, ny)

        elseif collIf('Projectile', 'Solid', a, b) then
            a, b = collEnsure('Projectile', a, 'Solid', b)
            a:collisionSolid(b, nx, ny)

        elseif collIf('Enemy', 'Solid', a, b) then
            a, b = collEnsure('Enemy', a, 'Solid', b)
            a:collisionSolid(b, nx, ny)
        end
    end
end

function Collision.onExit(fixture_a, fixture_b, contact)
    local a, b = fixture_a:getUserData(), fixture_b:getUserData()
    local nx, ny = contact:getNormal()

    if fixture_a:isSensor() and fixture_b:isSensor() then

    elseif not (fixture_a:isSensor() or fixture_b:isSensor()) then
        if a and b then
            if collIf('Player', 'Solid', a, b) then
                a, b = collEnsure('Player', a, 'Solid', b)
                beholder.trigger('COLLISION EXIT' .. a.id, b)
            end
        end
    end
end
