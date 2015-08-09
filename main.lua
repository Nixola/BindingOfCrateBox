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
    love.filesystem.setIdentity("The Binding of Crate Box v0.1.1")
    love.graphics.setDefaultFilter('nearest', 'nearest')
    uid = 0
    current_level_id = 0
    getUID = function() uid = uid + 1; return uid end

    initialize()

    debug_draw = false

    controller = xboxlove.create(1)
    controller_keys_down = {}
    controller_dpad_keys = {'Up', 'Down', 'Left', 'Right'}
    controller_buttons = {'A', 'B', 'X', 'Y', 'LB', 'RB', 'Start', 'Back'}
    if controller then
        controller:setDeadzone("ALL", 0)
    end
end

function love.update(dt)
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

function love.run()
    math.randomseed(os.time())
    math.random(); math.random(); math.random();

    if love.load then love.load(arg) end

    local t = 0
    local dt = 0
    local fixed_dt = 1/60 
    local accumulator = 0

    -- Main loop time
    while true do
        -- Process events
        if love.event then
            love.event.pump()
            for e, a, b, c, d in love.event.poll() do
                if e == "quit" then
                    if not love.quit or not love.quit() then
                        if love.audio then
                            love.audio.stop()
                        end
                        return
                    end
                end
                love.handlers[e](a, b, c, d)
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        if dt > fixed_dt then dt = fixed_dt end
        accumulator = accumulator + dt

        while accumulator >= fixed_dt do
            if love.update then love.update(fixed_dt) end
            accumulator = accumulator - fixed_dt
            t = t + fixed_dt
        end

        if love.graphics then
            love.graphics.clear()
            if love.draw then love.draw() end
        end

        if love.graphics then love.graphics.present() end
    end
end
