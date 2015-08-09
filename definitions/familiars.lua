function loadFamiliars()
    local familiar = struct('attack', 'visual')
    familiars = {}
    familiars['A Friend'] = familiar('A Friend', {left = a_friend_left, right = a_friend_right})
    familiars['A Better Friend'] = familiar('A Better Friend', {left = a_better_friend_left, right = a_better_friend_right})
    familiars['Flaria'] = familiar('Ember', {left = flaria_left, right = flaria_right})
    familiars['Bicurious'] = familiar('Bicurious', {left = bicurious_left, right = bicurious_right})
end
