function initialize()
    require 'globals'

    loadRequire()
    loadScale()
    loadGlobals()

    over_chrono = Chrono()
    require 'game/Game'

    debugging = true

    state = {game = Game()}
    current_state = state.game
end

function love.load()
    love.filesystem.setIdentity("bindingCrateBox")
    love.graphics.setDefaultFilter('nearest', 'nearest')
    uid = 0
    current_level_id = 0
    getUID = function() uid = uid + 1; return uid end

    initialize()

    --config loading!
    local settings = love.filesystem.read("settings")
    if settings then
        for event, value in settings:gmatch("([A-Z ]+)%:(.-)\n") do
            if value and value ~= "nil" then
                value = tonumber(value) or value
                beholder.trigger(event, value)
            end
        end
    end

    debug_draw = false

    love.filesystem.createDirectory("resources")
    love.joystick.loadGamepadMappings("resources/mappings.list")
    if love.filesystem.isFile("resources/user.mappings.list") then
        love.joystick.loadGamepadMappings("resources/user.mappings.list")
    end
    local c
    for i, joystick in ipairs(love.joystick.getJoysticks()) do
        if joystick:isGamepad() then
            c = joystick
            break
        else
            print("Name:", joystick:getName())
            print("GUID:", joystick:getGUID())
        end
    end
    controller = xboxlove.create(c)
    controller_keys_down = {}
    controller_dpad_keys = {'Up', 'Down', 'Left', 'Right'}
    controller_buttons = {'A', 'B', 'X', 'Y', 'LB', 'RB', 'Start', 'Back'}
    if controller then
        controller:setDeadzone("ALL", 0)
    end
end

function love.update(dt)
    --print(love.timer.getAverageDelta())
    if current_state.end_it_all then
        loadRequire()
        loadScale()
        loadGlobals()
        player_passives = {}
        player_item = table.copy(items['Empty'])
        player_attack = table.copy(attacks[pools['Tutorial'][math.random(1, #pools['Tutorial'])][2]]) 
        p_familiars = {}
        p_buffs = {}
        current_state.current_level.familiars = {}
        current_state.current_level.player.passives = {}
        current_state.current_level.player.current_item = table.copy(items['Empty'])
        current_state.current_level.player.current_attack = nil
        current_state.current_level.player.buffs = {} 
        if string.match(current_map_name, 'tutorial') then n_levels = 0 end
        current_state.ui.unlock_texts = {}
        current_state.ui.unlock_colors1 = 0
        current_state.ui.unlock_colors2 = 0
        current_state.ui.unlock_colors3 = 0
        current_state.music_color =  {255, 255, 255, 0}
        current_state.music_color2 = {0, 0, 0, 0}
        current_state.death_overlay = {128, 128, 128, 0}
        current_state.retry_alpha = 0
        current_state.death = false
        current_state.end_it_all = false
        current_state.retry = false
        beholder.trigger('TRANSITION TO', current_map_name)
    end
    -- Controller
    if controller then 
        controller:update(dt) 
        for _, key in ipairs(controller_dpad_keys) do
            if controller.Dpad[key] then 
                if not controller_keys_down[key] then
                    controller_keys_down[key] = true
                    controllerKeypressed(key)
                end
            else
                if controller_keys_down[key] then
                    controller_keys_down[key] = nil
                    controllerKeyreleased(key)
                end
            end
        end
        for _, key in ipairs(controller_buttons) do
            if controller.Buttons[key] then 
                if not controller_keys_down[key] then
                    controller_keys_down[key] = true
                    controllerKeypressed(key)
                end
            else
                if controller_keys_down[key] then
                    controller_keys_down[key] = nil
                    controllerKeyreleased(key)
                end
            end
        end
    end
    -- Main
    if not current_state.paused then
        main_chrono:update(dt)
        current_state:update(dt)
    end

    if love.keyboard.isDown('lshift') then shift_down = true
    else shift_down = false end
    -- print(tostring(math.round(collectgarbage("count"), 0) .. 'Kb'))
    --
    main_tween.update(dt)
    sound_chrono:update(dt)
    over_chrono:update(dt)
    current_state.sound:update(dt)
    TEsound.cleanup()
end

function love.draw()
    current_state:draw()
    --[[
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 40)
    if current_state.current_level then
        love.graphics.print("Current attack: " .. current_state.current_level.player.current_attack.name, 10, 70)
        love.graphics.print("Current item: " .. current_state.current_level.player.current_item.name, 10, 100)
    end
    --]]
end

function controllerKeypressed(key)
    current_state:keypressed(key)
end

function controllerKeyreleased(key)
    current_state:keyreleased(key)
end

function love.keypressed(key)
    --[[
    if key == 'm' then love.event.push('quit') end
    if key == 'g' then collectgarbage(); collectgarbage("stop") end
    if key == 'f' then love.graphics.toggleFullscreen() end
    if key == 'f2' then debug_draw = not debug_draw end
    ]]--
    current_state:keypressed(key)
end

function love.keyreleased(key)
    current_state:keyreleased(key) 
end

function love.joystickadded(joystick)
    if not controller then
        controller = xboxlove.create(joystick)
        if controller then
            controller:setDeadzone("ALL", 0)
        end
    end
end

function love.joystickremoved(joystick)
    if controller and (controller.joystick == joystick) then
        controller = false
    end
end


function love.run()
    love.math.setRandomSeed(os.time())
    love.math.random(); love.math.random(); love.math.random();

    love.event.pump()

    love.load(arg)

    love.timer.step()

    local t = 0
    local dt = 0
    local fixed_dt = 1/60
    local accumulator = 0

    -- Main loop time
    while true do
        -- Process events
        love.event.pump()
        for e, a, b, c, d in love.event.poll() do
            if e == "quit" then
                if not love.quit() then
                    if love.audio then
                        love.audio.stop()
                    end
                    return
                end
            end
            love.handlers[e](a, b, c, d)
        end

        -- Update dt, as we'll be passing it to update
        love.timer.step()
        dt = love.timer.getDelta()

        if dt > fixed_dt then dt = fixed_dt end
        accumulator = accumulator + dt

        while accumulator >= fixed_dt do
            love.update(fixed_dt)
            accumulator = accumulator - fixed_dt
            t = t + fixed_dt
        end

        love.graphics.clear()
        love.graphics.origin()
        love.draw()
        love.graphics.present()
        
        love.timer.sleep(0.001)

    end
end


love.quit = function()
    local f = love.filesystem.newFile("settings", "w")
    if not f then return end
    local musicVolume = state.game.paused_menu.music_volume
    local soundVolume = state.game.paused_menu.game_volume
    local holdToJump  = state.game.paused_menu.hold_to_jump
    local particles   = state.game.paused_menu.particles
    f:write(
    "SET MUSIC VOLUME:"  .. tostring(musicVolume) .. '\n' ..
    "SET GAME VOLUME:"   .. tostring(soundVolume) .. '\n' ..
    "SET HOLD TO JUMP:"  .. tostring(holdToJump)  .. '\n' ..
    "SET PARTICLE RATE:" .. tostring(particles)   .. '\n')
    print "things saved maybe"
    f:close()
end
