function loadItems()
    local item = struct('name', 'activation', 'uses', 'cooldown', 'desc_text', 'other_text')
    items = {}
    item_specific = {}

    items['Empty'] = item('Empty', 'passive', nil, nil) -- can't get current_item to work while being nil
    items['The Dead Ringer'] = item('The Dead Ringer', 'passive', nil, nil, '', {})
    item_specific['The Dead Ringer'] = {duration = 6.5}
    items['Invis Watch'] = item('Invis Watch', 'press', nil, nil, '', {})
    item_specific['Invis Watch'] = {turn_duration = 1, duration = 9}
    items['Spider Butt'] = item('Spider Butt', 'press', nil, nil, '', {})
    item_specific['Spider Butt'] = {duration = 3, slow_value = 0.25, damage = 0.5}
    items['The Salamanca!'] = item('The Salamanca!', 'press', nil, nil, '', {})
    item_specific['The Salamanca!'] = {mine = 'Salamanca'}
    items['Stickybomb Launcher'] = item('Stickybomb Launcher', 'press', nil, nil, '', {})
    items['The Joker'] = item('The Joker', 'press', nil, nil, '', {'some men...'})
    items["Gangplank's Soul"] = item("Gangplank's Soul", 'press', nil, nil, '', {})
    item_specific["Gangplank's Soul"] = {duration = 20, chance = 0.3}
    items["Anivia's R"] = attacks["Anivia's R"]
    items["Anivia's R"].desc_text = ''
    items["Anivia's R"].other_text = {}
    items['Double Damage'] = item('Double Damage', 'press', nil, nil, '', {})
    item_specific['Double Damage'] = {duration = 10}
    items['Double Defense'] = item('Double Defense', 'press', nil, nil, '', {})
    item_specific['Double Defense'] = {duration = 20}
    items['Through the Fire and Flames'] = item('Through the Fire and Flames', 'press', nil, nil, '', {})
    item_specific['Through the Fire and Flames'] = {interval = 0.5, times = 8, damage = 0.25}
    items['Green Potion'] = item('Green Potion', 'press', nil, nil, '', {})
    items['Blue Potion'] = item('Blue Potion', 'press', nil, nil, '', {})
    items['Orange Potion'] = item('Orange Potion', 'press', nil, nil, '', {})
    items['Red Potion'] = item('Red Potion', 'press', nil, nil, '', {})
    items['White Potion'] = item('White Potion', 'press', nil, nil, '', {})
    items['Yellow Potion'] = item('Yellow Potion', 'press', nil, nil, '', {})
    items['Pink Potion'] = item('Pink Potion', 'press', nil, nil, '', {})
end
