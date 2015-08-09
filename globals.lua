math.randomseed(os.time())
math.random(); math.random(); math.random()

function loadRequire()
    require 'libraries/middleclass/middleclass'
    require 'libraries/chrono/chrono'
    require 'libraries/Vector'
    require 'libraries/anal/AnAL'
    require 'utils'
    beholder = require 'libraries/beholder/beholder'
    struct = require 'libraries/struct/struct'
    Camera = require 'libraries/hump/camera'
    main_tween = require 'libraries/tween/tween'
    sound_tween = require 'libraries/tween/tween'
    main_chrono = Chrono()
    sound_chrono = Chrono()
    require 'game/rng'
    require 'libraries/xboxlove'
    require 'libraries/TEsound'

    require 'mixins/Collector'
    require 'mixins/Input'
    require 'mixins/PhysicsLine'
    require 'mixins/PhysicsRectangle'
    require 'mixins/PhysicsCircle'
    require 'mixins/Movable'
    require 'mixins/Jumper'
    require 'mixins/Logic'
    require 'mixins/Attacker'
    require 'mixins/Itemuser'
    require 'mixins/Behavior'
    require 'mixins/Hittable'
    require 'mixins/MovableAreaProjectile'
    require 'mixins/LogicProjectile'
    require 'mixins/LogicArea'
    require 'mixins/LogicLine'
    require 'mixins/LogicActivation'
    require 'mixins/PlayerEnemyVisual'
    require 'mixins/Stats'
    require 'mixins/Steerable'
    require 'mixins/FamiliarVisual'
    require 'mixins/FlyingBehavior'

    require 'game_objects/Entity'
    require 'game_objects/Solid'
    require 'game_objects/Player'
    require 'game_objects/Projectile'
    require 'game_objects/Enemy'
    require 'game_objects/ItemBox'
    require 'game_objects/MovingText'
    require 'game_objects/Area'
    require 'game_objects/Line'
    require 'game_objects/Mine'
    require 'game_objects/Familiar'
    require 'game_objects/Resource'
    require 'game_objects/Automata'
    require 'game_objects/EProjectile'
    require 'game_objects/Shadow'
    require 'game_objects/FlyingEnemy'
    require 'game_objects/Boss'

    require 'definitions/input'
    require 'definitions/levels'
    require 'definitions/attacks'
    require 'definitions/projectiles'
    require 'definitions/collisions'
    require 'definitions/areas'
    require 'definitions/lines'
    require 'definitions/items'
    require 'definitions/mines'
    require 'definitions/screens'
    require 'definitions/passives'
    require 'definitions/stats'
    require 'definitions/familiars'
    require 'definitions/resources'
    require 'definitions/chance'
    require 'definitions/pools'
    require 'definitions/eprojectiles'
    require 'definitions/enemies'
end

function loadScale()
    scale = 1
    scales = {1, 1.25, 1.5, 1.75, 2}
end

-- Returns a table of images from tile sheet = name, with tile width = tile_w and height = tile_h.
-- Reads left->right, top->down: first image: x = 1, y = 1; 
-- wth image: x = tile_w, y = 1, last image: x = tile_w, y = tile_h.
local function getImagesFromTileSheet(name, tile_w, tile_h)
    local tiles = {}
    local data = love.image.newImageData('resources/' .. name .. '.png')
    local n_w, n_h = data:getWidth()/tile_w, data:getHeight()/tile_h
    for j = 1, n_h do
        for i = 1, n_w do
            local tile = love.image.newImageData(tile_w, tile_h)
            local m, n = 0, 0
            for k = tile_w*(i-1), tile_w*i-1 do
                n = 0
                for l = tile_h*(j-1), tile_h*j-1 do
                    local r, g, b, a = data:getPixel(k, l)
                    tile:setPixel(m, n, r, g, b, a)
                    n = n + 1
                end
                m = m + 1
            end
            table.insert(tiles, love.graphics.newImage(tile))
        end
    end
    return tiles
end

function loadGlobals()
    -- Game
    SX = scale/2
    SY = scale/2
    GAME_WIDTH = 800*scale
    GAME_HEIGHT = 512*scale

    -- UI 
    UI_TEXT_FONT_16 = love.graphics.newFont('resources/pf_tempesta_five.ttf', 16)
    UI_TEXT_FONT_20 = love.graphics.newFont('resources/pf_tempesta_five.ttf', 20)
    UI_TEXT_FONT_24 = love.graphics.newFont('resources/pf_tempesta_five.ttf', 24)
    UI_TEXT_FONT_32 = love.graphics.newFont('resources/pf_tempesta_five.ttf', 32)
    UI_TEXT_FONT_40 = love.graphics.newFont('resources/pf_tempesta_five.ttf', 40)
    UI_TEXT_FONT_48 = love.graphics.newFont('resources/pf_tempesta_five.ttf', 48)
    UI_TEXT_FONT_96 = love.graphics.newFont('resources/pf_tempesta_five.ttf', 96)
    GAME_FONT = love.graphics.newFont('resources/pf_tempesta_five.ttf', 16)
    love.graphics.setFont(UI_TEXT_FONT_24)

    -- Logic
    ATTACK_CHANCE = 0.8
    ITEM_CHANCE = 0.15
    PASSIVE_CHANCE = 0.05
    player_explosion_multiplier = 1
    luck = 1
    action = 1
    key = 0
    money = 25 
    bombs = 3 
    effect_duration_multiplier = 1
    keys = 0
    tat_free = false
    no_new_masks = false
    p_familiars = {}
    p_buffs = {}
    shift_down = false
    fire_spreads = false
    exploding_shots = false 
    exploding_shots_chance = 0.07 
    thick_skinned = false
    gentle_giant = false
    player_passives = {}
    player_item = nil
    player_attack = nil 
    player_stats = {max_hp = 3, hp = 3, speed = 4, explosion_size = 4, mask = 0, damage = 3, pierce = 1, reflect = 1, cooldown = 4, hp_limit = 6}
    run_difficulty = 1
    r_diff_mult = 1
    difficulty = 1
    blue_tower = false 
    red_tower = false 
    yellow_tower = false 
    green_tower = false 
    vampirism = false 
    vampirism_counter = 0
    vampirism_limit = 20
    okay = false 
    gangplanks_soul = false
    poison_damage = false
    poison_chance = 0.1
    ice_damage = false
    slow_chance = 0.1
    stun_damage = false
    stun_chance = 0.1
    chronomaged = false
    chronomaged_used = false
    double_damage = false
    double_defense = false
    more_chests = false
    more_chests_chance = 1.5
    more_money = false
    more_money_chance = 2 
    more_hearts = false
    more_hearts_chance = 2
    more_bombs = false
    more_bombs_chance = 2
    boomerang = false
    arrows = false
    book_1 = false
    book_1_chance = 0.5
    book_3 = false
    book_7 = false
    book_7_chance = 3
    added_difficulty = 0
    potions = {'Green Potion', 'Blue Potion', 'Orange Potion', 'Red Potion', 'White Potion', 'Yellow Potion', 'Pink Potion'}
    local potion_functions = {
        function(self)
            self.stats.cooldown = self.stats.cooldown + 1
            if self.stats.cooldown > 8 then self.stats.cooldown = 8 end
            return 'fire rate up'
        end,

        function(self)
            self.stats.cooldown = self.stats.cooldown - 1
            if self.stats.cooldown < 1 then self.stats.cooldown = 1 end 
            return 'fire rate down'
        end,

        function(self)
            self.stats.speed = self.stats.speed + 1
            if self.stats.speed > 8 then self.stats.speed = 8 end
            return 'speed up'
        end,

        function(self)
            self.stats.speed = self.stats.speed - 1
            if self.stats.speed < 1 then self.stats.speed = 1 end
            return 'speed down'
        end,

        function(self)
            self.stats.max_hp = self.stats.max_hp + 1
            if self.stats.max_hp > self.stats.hp_limit then self.stats.max_hp = self.stats.hp_limit end
            return 'hp up'
        end,

        function(self)
            self.stats.max_hp = self.stats.max_hp - 1
            if self.stats.hp > self.stats.max_hp then self.stats.hp = self.stats.max_hp end
            return 'hp down'
        end,

        function(self)
            added_difficulty = added_difficulty + 1
            return 'difficulty up'
        end
    }
    potions_map = {}
    for _, potion in ipairs(potions) do
        local r = math.random(1, #potion_functions)
        potions_map[potion] = potion_functions[r]
        table.remove(potion_functions, r)
    end

    -- Tiles
    environment_32 = getImagesFromTileSheet('environment_32', 32, 32)

    -- Images
    area = love.graphics.newImage('resources/area.png')
    paused_overlay = love.graphics.newImage('resources/paused_overlay.png')
    bg_square = love.graphics.newImage('resources/bg_square.png')
    bgm_pink = love.graphics.newImage('resources/bgm_pink.png')
    bgm_other_red = love.graphics.newImage('resources/bgm_other_red.png')
    bgm_green = love.graphics.newImage('resources/bgm_green.png')
    bgm_blue = love.graphics.newImage('resources/bgm_blue.png')
    bgm_market = love.graphics.newImage('resources/bgm_market.png')
    bgm_gray = love.graphics.newImage('resources/bgm_gray.png')
    bgm_red = love.graphics.newImage('resources/bgm_red.png')
    bgm_yellow = love.graphics.newImage('resources/bgm_yellow.png')
    bgm_black = love.graphics.newImage('resources/bgm_black.png')
    ui_bg = love.graphics.newImage('resources/ui_bg.png')
    ui_menu_bg = love.graphics.newImage('resources/ui_menu_bg.png')
    ui_separator = love.graphics.newImage('resources/ui_separator.png')
    ui_separator_2 = love.graphics.newImage('resources/ui_separator_2.png')
    ui_ai = love.graphics.newImage('resources/ui_ai.png')
    square = love.graphics.newImage('resources/square.png')
    proj = love.graphics.newImage('resources/proj.png')
    beholder_boss_128 = love.graphics.newImage('resources/beholder_128.png')
    beholder_boss_64 = love.graphics.newImage('resources/beholder_64.png')
    beholder_boss_32 = love.graphics.newImage('resources/beholder_32.png')
    player_left = love.graphics.newImage('resources/player_left.png')
    player_right = love.graphics.newImage('resources/player_right.png')
    player_shooting_left = love.graphics.newImage('resources/player_shooting_left.png')
    player_shooting_right = love.graphics.newImage('resources/player_shooting_right.png')
    skull_blue_left = love.graphics.newImage('resources/skull_blue_left.png')
    skull_blue_right = love.graphics.newImage('resources/skull_blue_right.png')
    skull_red_left = love.graphics.newImage('resources/skull_red_left.png')
    skull_red_right = love.graphics.newImage('resources/skull_red_right.png')
    skull_black_left = love.graphics.newImage('resources/skull_black_left.png')
    skull_black_right = love.graphics.newImage('resources/skull_black_right.png')
    player_left_shadow = love.graphics.newImage('resources/player_left_shadow.png')
    player_right_shadow = love.graphics.newImage('resources/player_right_shadow.png')
    blue_zombie_left = love.graphics.newImage('resources/blue_zombie_left.png')
    blue_zombie_right = love.graphics.newImage('resources/blue_zombie_right.png')
    red_zombie_left = love.graphics.newImage('resources/red_zombie_left.png')
    red_zombie_right = love.graphics.newImage('resources/red_zombie_right.png')
    pink_zombie_left = love.graphics.newImage('resources/pink_zombie_left.png')
    pink_zombie_right = love.graphics.newImage('resources/pink_zombie_right.png')
    a_friend_left = love.graphics.newImage('resources/a_friend_left.png')
    a_friend_right = love.graphics.newImage('resources/a_friend_right.png')
    a_better_friend_left = love.graphics.newImage('resources/a_better_friend_left.png')
    a_better_friend_right = love.graphics.newImage('resources/a_better_friend_right.png')
    flaria_left = love.graphics.newImage('resources/flaria_left.png')
    flaria_right = love.graphics.newImage('resources/flaria_right.png')
    bicurious_left = love.graphics.newImage('resources/bicurious_left.png')
    bicurious_right = love.graphics.newImage('resources/bicurious_right.png')
    salamanca = love.graphics.newImage('resources/salamanca.png')
    salamanca_screen = love.graphics.newImage('resources/salamanca_screen.png')
    light_line = love.graphics.newImage('resources/light_line.png')
    wall_door = love.graphics.newImage('resources/wall_door.png')
    heart_32 = love.graphics.newImage('resources/heart_32.png')
    half_heart_32 = love.graphics.newImage('resources/half_heart_32.png')
    empty_heart_32 = love.graphics.newImage('resources/empty_heart_32.png')
    mask_32 = love.graphics.newImage('resources/mask_32.png')
    half_mask_32 = love.graphics.newImage('resources/half_mask_32.png')
    bronze_coin_16 = love.graphics.newImage('resources/bronze_coin_16.png')
    plus = love.graphics.newImage('resources/plus.png')
    coin = love.graphics.newImage('resources/coin.png')
    bomb = love.graphics.newImage('resources/bomb.png')
    chest_open = love.graphics.newImage('resources/chest_open.png')
    chest_closed = love.graphics.newImage('resources/chest_closed.png')
    aspd = love.graphics.newImage('resources/aspd.png')
    fitter_happier = love.graphics.newImage('resources/fitter_happier.png')
    hl3 = love.graphics.newImage('resources/hl3.png')
    ricochet = love.graphics.newImage('resources/ricochet.png')
    kiri = love.graphics.newImage('resources/kiri.png')
    scout = love.graphics.newImage('resources/scout.png')
    tom_cruise = love.graphics.newImage('resources/tom_cruise.png')
    michael_bay = love.graphics.newImage('resources/michael_bay.png')
    crown = love.graphics.newImage('resources/crown.png')
    giant = love.graphics.newImage('resources/giant.png')
    iron_man = love.graphics.newImage('resources/iron_man.png')
    gun_kata = love.graphics.newImage('resources/gun_kata.png')
    thick_skin = love.graphics.newImage('resources/thick.png')
    wildfire = love.graphics.newImage('resources/wildfire.png')
    jumpnshootman = love.graphics.newImage('resources/jumpnshootman.png')
    dashnshootman = love.graphics.newImage('resources/dashnshootman.png')
    movnshootman = love.graphics.newImage('resources/movnshootman.png')
    resonance = love.graphics.newImage('resources/resonance.png')
    mutantspider = love.graphics.newImage('resources/mutantspider.png')
    eggbomb = love.graphics.newImage('resources/eggbomb.png')
    sludge = love.graphics.newImage('resources/sludge.png')
    psy = love.graphics.newImage('resources/psy.png')
    ember = love.graphics.newImage('resources/ember.png')
    leaf = love.graphics.newImage('resources/leaf.png')
    rock = love.graphics.newImage('resources/rock.png')
    flaria = love.graphics.newImage('resources/flaria.png')
    anivia = love.graphics.newImage('resources/anivia.png')
    spiderbutt = love.graphics.newImage('resources/spiderbutt.png')
    spy = love.graphics.newImage('resources/spy.png')
    tower_blue = love.graphics.newImage('resources/tower_blue.png')
    tower_red = love.graphics.newImage('resources/tower_red.png')
    tower_yellow = love.graphics.newImage('resources/tower_yellow.png')
    tower_green = love.graphics.newImage('resources/tower_green.png')
    bubble = love.graphics.newImage('resources/bubble.png')
    pentagram = love.graphics.newImage('resources/pentagram.png')
    bow_1 = love.graphics.newImage('resources/bow_1.png')
    pendant = love.graphics.newImage('resources/pendant.png')
    necklace = love.graphics.newImage('resources/necklace.png')
    sword = love.graphics.newImage('resources/sword.png')
    gold_sword = love.graphics.newImage('resources/gold_sword.png')
    heal = love.graphics.newImage('resources/heal_purple.png')
    vial = love.graphics.newImage('resources/health_vial.png')
    bow_2 = love.graphics.newImage('resources/bow_2.png')
    poisoned_spear = love.graphics.newImage('resources/poisoned_spear.png')
    earth_spear = love.graphics.newImage('resources/earth_spear.png')
    ice_spear = love.graphics.newImage('resources/ice_spear.png')
    impervius = love.graphics.newImage('resources/impervius.png')
    chronomage = love.graphics.newImage('resources/chronomage.png')
    ddamage = love.graphics.newImage('resources/ddamage.png')
    ddefense = love.graphics.newImage('resources/ddefense.png')
    apple = love.graphics.newImage('resources/I_C_Apple.png')
    banana = love.graphics.newImage('resources/I_C_Banana.png')
    bread = love.graphics.newImage('resources/I_C_Bread.png')
    carrot = love.graphics.newImage('resources/I_C_Carrot.png')
    cheese = love.graphics.newImage('resources/I_C_Cheese.png')
    cherry = love.graphics.newImage('resources/I_C_Cherry.png')
    egg = love.graphics.newImage('resources/I_C_Egg.png')
    fish = love.graphics.newImage('resources/I_C_Fish.png')
    meat = love.graphics.newImage('resources/I_C_Meat.png')
    orange = love.graphics.newImage('resources/I_C_Orange.png')
    pie = love.graphics.newImage('resources/I_C_Pie.png')
    watermelon = love.graphics.newImage('resources/I_C_Watermellon.png')
    chest_p = love.graphics.newImage('resources/I_Chest01.png')
    fang = love.graphics.newImage('resources/I_Fang.png')
    feather = love.graphics.newImage('resources/I_Feather02.png')
    goldcoin = love.graphics.newImage('resources/I_GoldCoin.png')
    mirror = love.graphics.newImage('resources/I_Mirror.png')
    death1 = love.graphics.newImage('resources/S_Death01.png')
    death2 = love.graphics.newImage('resources/S_Death02.png')
    heart_p = love.graphics.newImage('resources/S_Holy01.png')
    daggers = love.graphics.newImage('resources/daggers.png')
    arrow = love.graphics.newImage('resources/arrow.png')
    beams = love.graphics.newImage('resources/beams.png')
    book_pink = love.graphics.newImage('resources/W_Book01.png')
    book_attack = love.graphics.newImage('resources/W_Book02.png')
    book_holy = love.graphics.newImage('resources/W_Book03.png')
    book_hell = love.graphics.newImage('resources/W_Book04.png')
    book_gray = love.graphics.newImage('resources/W_Book05.png')
    book_glass = love.graphics.newImage('resources/W_Book06.png')
    book_blue = love.graphics.newImage('resources/W_Book07.png')
    potion_green_big = love.graphics.newImage('resources/potion_green_big.png')
    potion_blue_big = love.graphics.newImage('resources/potion_blue_big.png')
    potion_orange_big = love.graphics.newImage('resources/potion_orange_big.png')
    potion_pink_big = love.graphics.newImage('resources/potion_pink_big.png')
    potion_red_big = love.graphics.newImage('resources/potion_red_big.png')
    potion_white_big = love.graphics.newImage('resources/potion_white_big.png')
    potion_yellow_big = love.graphics.newImage('resources/potion_yellow_big.png')
    surprise = love.graphics.newImage('resources/surprise.png')
    rainbow_dash = love.graphics.newImage('resources/rainbowdash.png')
    cannon = love.graphics.newImage('resources/cannon.png')
    candy = love.graphics.newImage('resources/candy.png')

    -- Structs
    id_point = struct('id', 'p')

    -- Maps
    n_levels = 1
    local map = struct('bg', 'offset')
    maps = {}
    maps['tutorial_yellow'] = map(bgm_yellow, Vector(0, 0))
    maps['tutorial_red'] = map(bgm_red, Vector(0, 0))
    maps['tutorial_blue'] = map(bgm_blue, Vector(0, 0))
    maps['tutorial_green'] = map(bgm_green, Vector(0, 0))
    maps['tutorial_pink'] = map(bgm_pink, Vector(0, 0))
    maps['tutorial_gray'] = map(bgm_gray, Vector(0, 0))
    maps['tutorial_other_red'] = map(bgm_other_red, Vector(0, 0))
    maps['scb_gray'] = map(bgm_gray, Vector(0, 0))
    maps['market'] = map(bgm_market, Vector(0, 0))
    maps['scb_red'] = map(bgm_red, Vector(0, 0))
    maps['scb_blue'] = map(bgm_blue, Vector(0, 0))
    maps['scb_pink'] = map(bgm_pink, Vector(0, 0))
    maps['scb_green'] = map(bgm_green, Vector(0, 0))
    maps['scb_other_red'] = map(bgm_other_red, Vector(0, 0))
    maps['item_yellow'] = map(bgm_yellow, Vector(0, 0))
    maps['item_red'] = map(bgm_red, Vector(0, 0))
    maps['item_blue'] = map(bgm_blue, Vector(0, 0))
    maps['item_green'] = map(bgm_green, Vector(0, 0))
    maps['item_other_red'] = map(bgm_other_red, Vector(0, 0))
    maps['item_pink'] = map(bgm_pink, Vector(0, 0))
    maps['item_gray'] = map(bgm_gray, Vector(0, 0))
    maps['end'] = map(bgm_black, Vector(0, 0))
    math.random(); math.random(); math.random()
    tutorials_list = {'tutorial_yellow', 'tutorial_green', 'tutorial_pink', 'tutorial_red', 'tutorial_other_red', 'tutorial_gray', 'tutorial_blue'}
    items_mlist = {'item_yellow', 'item_green', 'item_pink', 'item_red', 'item_other_red', 'item_gray', 'item_blue'}
    current_map_name = tutorials_list[math.random(1, #tutorials_list)] 
   
    -- PSOs
    main_pso = 'resources/Zytokine.pso'

    -- Colors
    LIGHT_YELLOW = {224, 224, 160, 255}
    FLARE_RED = {179, 41, 0, 255}
    FLARE_BLUE = {0, 41, 179, 255}
    WHITE = {230, 232, 227, 225}
    INVISIBLE = {0, 0, 0, 0}
    POISON_GREEN = {77, 128, 57, 255}
    RED = {216, 48, 24, 255}
    GREEN = {48, 216, 24, 255}
    BLUE = {160, 160, 224, 255}
    ROCK = {196, 181, 159, 255}
    ROCK_PS = {196, 181, 159, 255, 196, 181, 159, 0}
    R_PINK_1 = {191, 98, 166, 255}
    R_PINK_1_PS = {191, 98, 166, 255, 191, 98, 166, 0}
    R_PINK_2 = {232, 104, 162, 255}
    R_PINK_2_PS = {232, 104, 162, 255, 232, 104, 162, 0}
    R_ORANGE = {242, 140, 51, 255}
    R_ORANGE_PS = {242, 140, 51, 255, 242, 140, 51, 0}
    R_YELLOW = {245, 214, 61, 255}
    R_YELLOW_PS = {245, 214, 61, 255, 245, 214, 61, 0}
    R_YELLOW_GREEN = {197, 214, 71, 255}
    R_YELLOW_GREEN_PS = {197, 214, 71, 255, 197, 214, 71, 0}
    R_GREEN = {121, 194, 103, 255}
    R_GREEN_PS = {121, 194, 103, 255, 121, 194, 103, 0}
    R_BLUE_1 = {69, 155, 168, 255}
    R_BLUE_1_PS = {69, 155, 168, 255, 69, 155, 168, 0}
    R_BLUE_2 = {120, 197, 214, 255}
    R_BLUE_2_PS = {120, 197, 214, 255, 120, 197, 214, 0}
    RAINBOW_COLORS = {R_PINK_1, R_PINK_2, R_ORANGE, R_YELLOW, R_YELLOW_GREEN, R_GREEN, R_BLUE_1, R_BLUE_2}
    RAINBOW_PSS = {R_PINK_1_PS, R_PINK_2_PS, R_ORANGE_PS, R_YELLOW_PS, R_YELLOW_GREEN_PS, R_GREEN_PS, R_BLUE_1_PS, R_BLUE_2_PS}
    YELLOW_PS = {224, 192, 128, 255, 224, 192, 128, 0}
    INVISIBLE_PS = {0, 0, 0, 0, 0, 0, 0, 0}
    LIGHT_BLUE_PS = {94, 160, 224, 255, 94, 160, 224, 0}
    BLUE_PS = {160, 160, 224, 255, 160, 160, 224, 0}
    ENEMY_RED_PS = {216, 48, 24, 255, 216, 48, 24, 0}
    GREEN_PS = {48, 216, 24, 255, 48, 216, 24, 0}
    ITEMGET_PS = {236, 229, 206, 255, 236, 229, 206, 0}
    DARK_BLUE_PS = {48, 80, 112, 255, 48, 80, 112, 0}
    ENEMY_DARK_RED_PS = {108, 24, 12, 225, 108, 24, 12, 0}
    SLOW_PS = {227, 246, 243, 255, 250, 240, 254, 0}
    STUN_PS1 = {148, 140, 117, 255, 148, 140, 117, 0}
    STUN_PS2 = {122, 106, 83, 255, 122, 106, 83, 0}
    STUN_PS3 = {217, 206, 178, 255, 217, 206, 178, 0}
    SMOKE_PS = {}
    BLIZZARD_WHITE = {230, 232, 227, 64, 230, 232, 227, 0}
    BLIZZARD_GRAY = {190, 195, 188, 96, 190, 195, 188, 0}
    BLIZZARD_BLUE = {101, 114, 122, 64, 101, 114, 122, 0}
    ROCKET_DARK = {128, 127, 133, 255, 128, 127, 133, 0}
    ROCKET = {157, 157, 147, 255, 157, 157, 147, 0}
    ROCKET_LIGHT = {180, 183, 177, 255, 180, 183, 177, 0}
    FLARE_RED_PS = {179, 41, 0, 255, 222, 133, 49, 128, 239, 172, 65, 0} 
    FLARE_BLUE_PS = {0, 41, 179, 255, 49, 133, 222, 128, 65, 172, 239, 0}
    SMOKE_PS = {48, 44, 44, 255, 61, 60, 56, 0}
    IPECAC_PS = {77, 178, 80, 255, 176, 204, 153, 0}

    -- ID

    -- Physics
    PHYSICS_METER = 32
    PHYSICS_GRAVITY = 10
    current_line = nil

    -- Entity
    TILEW = 32
    TILEH = 32

    -- Familiar
    FAMILIARW = 16
    FAMILIARH = 32

    -- Player
    PLAYERW = 24
    PLAYERH = 40
    PLAYER_GRAVITY_SCALE = 3.4
    PLAYERA = 5000
    PLAYER_MAX_VELOCITY = 225
    PLAYER_JUMP_IMPULSE = -576

    -- Enemy
    ENEMY_WALL_LEFT = 32
    ENEMY_WALL_RIGHT = 768
    SMALL_ENEMYW = 24
    SMALL_ENEMYH = 42
    BIG_ENEMYW = 48
    BIG_ENEMYH = 48
    SMALL_ENEMYA = 5000 
    BIG_ENEMYA = 5000
    SMALL_ENEMY_MAX_VELOCITY = 200
    BIG_ENEMY_MAX_VELOCITY = 175
    SMALL_ENEMY_GRAVITY_SCALE = 3.4 
    BIG_ENEMY_GRAVITY_SCALE = 6.8

    -- Projectile
    PROJECTILEW = 8
    PROJECTILEH = 8
    SPREAD_ANGLE = math.pi/24

    -- ItemBox
    ITEMBOXW = 16
    ITEMBOXH = 16
    ITEMBOXA = 5000
    ITEMBOX_MAX_VELOCITY = 200
    ITEMBOX_GRAVITY_SCALE = 3.4
    ITEMBOX_POSSIBLE_Y = {96, 192, 288, 400}

    -- Mine
    MINEA = 5000
    MINE_MAX_VELOCITY = 200
    MINE_GRAVITY_SCALE = 3.4
    MINEW = 16
    MINEH = 8

    loadLevels()
    loadInput()
    loadCollisions()
    loadProjectiles()
    loadeProjectiles()
    loadEnemies()
    loadAreas()
    loadLines()
    loadAttacks()
    loadItems()
    loadMines()
    loadScreens()
    loadPassives()
    loadStats()
    loadFamiliars()
    loadResources()
    loadChance()
    loadPools()
    maps_list = removeTable({'scb_gray', 'scb_pink', 'scb_green', 'scb_other_red', 'scb_blue', 'scb_red'}, locked_maps)

    player_item = table.copy(items['Empty'])
    player_attack = table.copy(attacks[pools['Tutorial'][math.random(1, #pools['Tutorial'])][2]]) 
    -- table.copy(attacks['Razor Leaf']) 
end
