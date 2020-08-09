function loadInput()
    local map_key = struct('type', 'action', 'keys', 'buttons')
    playerInputKeys = {
        map_key('down',     'MOVE RIGHT',           {'d'},          {'Right'}),
        map_key('down',     'MOVE LEFT',            {'a'},          {'Left'}),
        map_key('down',     'JUMP',                 {'w', 'space'}, {'A'}),
        map_key('down',     'ATTACK',               {'j'},          {'X'}),
        map_key('down',     'USE',                  {'k'},          {'Y'}),
        map_key('press',    'JUMP PRESSED',         {'w', 'space'}, {'A'}),
        map_key('press',    'ATTACK PRESSED',       {'j'},          {'X'}),
        map_key('press',    'USE PRESSED',          {'k'},          {'Y'}),
        map_key('press',    'DASH RIGHT PRESSED',   {'e'},          {'RB'}),
        map_key('press',    'DASH LEFT PRESSED',    {'q'},          {'LB'}),
        map_key('press',    'BOMB PRESSED',         {'f', 'l'},     {'B'}),
        map_key('press',    'SHIFT PRESSED',        {'lshift'}),
        map_key('release',  'ATTACK RELEASED',      {'j'},          {'X'}),
        map_key('release',  'JUMP RELEASED',        {'w', 'space'}, {'A'}),
        map_key('release',  'USE RELEASED',         {'k'},          {'Y'}),
        map_key('release',  'DASH RIGHT RELEASED',  {'e'},          {'RB'}),
        map_key('release',  'DASH LEFT RELEASED',   {'q'},          {'LB'}),
        map_key('release',  'SHIFT RELEASED',       {'lshift'})
    }
end
