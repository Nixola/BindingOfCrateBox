function loadAreas() 
    local area_logic = struct('r_i', 'r_f', 'delay', 'duration', 'tween', 'on_hit')
    areas_logic = {}
    areas_logic['normal'] = {}
    areas_logic['normal']['default'] = area_logic(64)
    areas_logic['normal']['on_hit'] = area_logic(64, nil, nil, 1, nil, true)
    areas_logic['normal']['small_on_hit'] = area_logic(32, nil, nil, 3, nil, true)
    areas_logic['normal']['huge'] = area_logic(256, nil, nil, 2)
    areas_logic['small'] = {}
    areas_logic['small']['flame'] = area_logic(32, 32, 0, 1, 'linear', true)
    areas_logic['small']['bomb1'] = area_logic(0, 16, 0, 0.3, 'linear', true)
    areas_logic['small']['bomb2'] = area_logic(0, 14, 0, 0.25, 'linear', true)
    areas_logic['small']['bomb3'] = area_logic(0, 12, 0, 0.15, 'linear', true)
    areas_logic['small']['bomb4'] = area_logic(0, 8, 0, 0.15, 'linear', true)
    areas_logic['small']['bomb5'] = area_logic(0, 4, 0, 0.2, 'linear', true)
    areas_logic['small']['bomb6'] = area_logic(0, 10, 0, 0.3, 'linear', true)
    areas_logic['small']['bomb7'] = area_logic(0, 18, 0, 0.15, 'linear', true)
    areas_logic['small']['bomb8'] = area_logic(0, 20, 0, 0.2, 'linear', true)
    areas_logic['huge'] = {}
    areas_logic['huge']['blizzard'] = area_logic(160)
    areas_logic['exploding'] = {}
    areas_logic['exploding']['default'] = area_logic(0, 128, 0, 0.5, 'inOutCubic', true)
    areas_logic['exploding']['small'] = area_logic(0, 48, 0, 0.3, 'inOutCubic', true)
    areas_logic['exploding']['grenade'] = area_logic(0, 64, 0, 0.3, 'inOutCubic', true)
    areas_logic['exploding']['salamanca'] = area_logic(48, 256, 0, 0.5, 'inOutCubic', true)
    areas_logic['exploding']['stickybomb'] = area_logic(0, 96, 0, 0.4, 'inOutCubic', true)
end
