function loadLines()
    local line_logic = struct('raycast', 'bolt_offset', 'y_scale')

    lines_logic = {}
    lines_logic['normal'] = {}
    lines_logic['normal']['technology 2'] = line_logic(true, 3, 16)
    lines_logic['normal']['technology'] = line_logic(true, 5, 32)
    lines_logic['normal']['brimstone'] = line_logic(true, 5, 128)
end
