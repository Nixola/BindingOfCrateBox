Sound = class('Sound')

function Sound:initialize()
    self.songs = {
        ["KgZ - Ace Harbor"] = "resources/Ace Harbor by KgZ.ogg",
        ["KgZ - Black Snow"] = "resources/Black Snow by KgZ.ogg",
        ["KgZ - Digital Kaleidoscope"] = "resources/Digital Kaleidoscope by KgZ.ogg", 
        ["KgZ - Foundry Stage"] = "resources/Foundry Stage by KgZ.ogg",
        ["KgZ - Go Ace Man, Go!"] = "resources/Go Ace Man, Go! by KgZ.ogg", 
        ["KgZ - Super Rocket Punch!"] = "resources/Super Rocket Punch! by KgZ.ogg",
        ["KgZ - You Can't Stop Me!"] = "resources/You Can't Stop Me! by KgZ.ogg"
    }

    self.jump = {"resources/sounds/jump_1.wav"}
    self.enemy_dead = {"resources/sounds/enemy_dead_1.wav"}
    self.enemy_hard_dead = {"resources/sounds/enemy_dead_2.wav"}
    self.itemget = {"resources/sounds/item_get_1.wav"}
    self.passiveget = {"resources/sounds/passive_get_1.wav"}
    self.player_hit = {"resources/sounds/player_hit_1.wav"}
    self.explosion = {"resources/sounds/explosion_1.wav"}
    self.attack = {"resources/sounds/attack_1.wav"}
    self.coin = {"resources/sounds/coin_1.wav"}
    self.dash = {"resources/sounds/dash_1.wav"}
    self.select = {"resources/sounds/select_1.wav"}

    self.songs_list = {"KgZ - Ace Harbor", "KgZ - Black Snow", "KgZ - Digital Kaleidoscope",
                       "KgZ - Foundry Stage", "KgZ - Go Ace Man, Go!", "KgZ - Super Rocket Punch!",
                       "KgZ - You Can't Stop Me!"}
    self:playSong()

    self.max_music_volume = 0.5
    self.music_volume = self.max_music_volume
    self.max_game_volume = 0.4
    self.game_volume = self.max_game_volume

    beholder.observe('MUSIC VOLUME REQUEST', function()
        beholder.trigger('MUSIC VOLUME REPLY', self.max_music_volume)
    end)

    beholder.observe('GAME VOLUME REQUEST', function()
        beholder.trigger('GAME VOLUME REPLY', self.max_game_volume)
    end)

    beholder.observe('SET MUSIC VOLUME', function(s)
        self.max_music_volume = s
    end)

    beholder.observe('SET GAME VOLUME', function(s)
        self.max_game_volume = s
    end)

    beholder.observe('PLAY SOUND EFFECT', function(name)
        TEsound.play(self[name], {"game"})
    end)

    beholder.observe('CHANGE MUSIC VOLUME', function(s)
        main_tween(0.5, self, {music_volume = self.max_music_volume*s}, 'linear')
    end)

    beholder.observe('CHANGE GAME VOLUME', function(s)
        main_tween(0.5, self, {game_volume = self.max_game_volume*s}, 'linear')
    end)
end

function Sound:playSong()
    local song = self.songs_list[math.random(1, #self.songs_list)]
    self.songs_list = removeTable(self.songs_list, {song})
    if #self.songs_list == 0 then 
        self.songs_list = {"KgZ - Ace Harbor", "KgZ - Black Snow", "KgZ - Digital Kaleidoscope",
                           "KgZ - Foundry Stage", "KgZ - Go Ace Man, Go!", "KgZ - Super Rocket Punch!",
                           "KgZ - You Can't Stop Me!"}
    end
    beholder.trigger('MUSIC UI TEXT', song)
    TEsound.play(self.songs[song], {"music"}, 1, 1, function()
        self:playSong()
    end)
end

function Sound:update(dt)
    TEsound.volume("game", self.game_volume)
    TEsound.volume("music", self.music_volume)
    -- print(self.music_volume)
end
