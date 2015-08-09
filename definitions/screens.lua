function loadScreens()
    local screen = struct('image', 'duration', 's_i', 's_f', 's_tween', 'r_i', 'r_f', 'r_tween')

    screens = {}
    screens['Salamanca'] = screen(salamanca_screen, 0.75, 0.75, 1.5, 'outCubic', 0, math.pi/24, 'outCubic')
end
