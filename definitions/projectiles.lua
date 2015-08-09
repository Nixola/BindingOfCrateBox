function loadProjectiles()
    PROJECTILE_V = 500

    local projectile_movement = struct('v_i', 'v_f', 'a', 'a_delay', 'time_limit')
    projectiles_movement = {}
    projectiles_movement['normal'] = {}
    projectiles_movement['normal']['default'] = projectile_movement(PROJECTILE_V, PROJECTILE_V)
    projectiles_movement['normal']['medium'] = projectile_movement(1.25*PROJECTILE_V, 1.25*PROJECTILE_V)
    projectiles_movement['normal']['slow'] = projectile_movement(0.5*PROJECTILE_V, 0.5*PROJECTILE_V)
    projectiles_movement['normal']['fast'] = projectile_movement(1.5*PROJECTILE_V, 1.5*PROJECTILE_V)
    projectiles_movement['normal']['IPECAC'] = projectile_movement(0.7*PROJECTILE_V, 0.7*PROJECTILE_V)
    projectiles_movement['accelerating'] = {}
    projectiles_movement['accelerating']['default'] = projectile_movement(0, 2*PROJECTILE_V, 1000)
    projectiles_movement['accelerating']['slow'] = projectile_movement(0, PROJECTILE_V, 500)
    projectiles_movement['accelerating']['medium'] = projectile_movement(PROJECTILE_V, 2*PROJECTILE_V, 1500)
    projectiles_movement['accelerating']['fast'] = projectile_movement(1.5*PROJECTILE_V, 3*PROJECTILE_V, 3000)
    projectiles_movement['decelerating'] = {}
    projectiles_movement['decelerating']['green'] = projectile_movement(0.7*PROJECTILE_V, 0.1*PROJECTILE_V, -1000)
    projectiles_movement['decelerating']['default'] = projectile_movement(0.9*PROJECTILE_V, 0, -500)
    projectiles_movement['decelerating']['blizzard'] = projectile_movement(PROJECTILE_V/4, PROJECTILE_V/16, -PROJECTILE_V)
    projectiles_movement['decelerating']['psyburst'] = projectile_movement(PROJECTILE_V*1.5, 0, -2000, 0, 0.4)
    projectiles_movement['decelerating']['candle'] = projectile_movement(PROJECTILE_V, 0, -500, 0, 1)
    projectiles_movement['boomerang'] = {}
    projectiles_movement['boomerang']['default'] = projectile_movement(0.6*PROJECTILE_V, -0.6*PROJECTILE_V, -400)
end
