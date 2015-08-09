function loadMines()
    local mine = struct('name', 'width', 'height', 'image', 'ti', 'ignore_enemy') 

    mines = {}
    mines['Salamanca'] = mine('Salamanca', 24, 44, salamanca, 3, true)
end

