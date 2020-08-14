
-- Dependencies
Class = require "lib/class"
push = require "lib/push"
require "lib/world"
require "lib/enemy"
require "lib/utilities"
require "lib/player"
require "lib/animator"
require "lib/projectile"


WINDOW_WIDTH = 512
WINDOW_HEIGHT = 800
VIRTUAL_WIDTH = 500/800*512
VIRTUAL_HEIGHT = 500

DEBUG_STATE = false


function love.load()
    -- Setup Screen
    push:setupScreen(
        VIRTUAL_WIDTH, 
        VIRTUAL_HEIGHT, 
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false,
            resizable = false,
            vsync = true
        }
    )

    love.graphics.setDefaultFilter("nearest", "nearest")
    -- Load Fonts
    title_font = love.graphics.newFont("/resources/Vermin Vibes 1989.ttf", 32)
    default_font = love.graphics.newFont("/resources/advanced_pixel_lcd-7.ttf", 8)
    fps_font = love.graphics.newFont("/resources/advanced_pixel_lcd-7.ttf", 6)
    debug_font = love.graphics.newFont("/resources/Retron2000.ttf", 8)
    -- Create world 
    world = World()

    -- Set Application State
    game_state = "title_screen"
end

function love.update(dt)
    world:update(dt)

end

function love.draw()
    -- Dubug FPS
    if DEBUG_STATE == true then
        displayFPS()
        love.graphics.setFont(debug_font)
        love.graphics.print("Debug Mode", 10, 30)
        love.graphics.print("Game State:          " ..game_state, 10, 40)
        love.graphics.print("Player 1 dx:         " ..world.player_1.dx, 10, 50)
        love.graphics.print("Player 1 ddx:       " ..world.player_1.ddx, 10, 60)
        love.graphics.print("Player 1 damage:  "..world.player_1.damage, 10, 70)
        love.graphics.setFont(default_font)
    end
    push:apply('start') 

    -- Render world
    world:render()
    
    -- Menu display scripts
    if game_state == "title_screen" then
        -- Title Text
        love.graphics.setFont(title_font)
        love.graphics.printf("BlackWing",0 , 50, VIRTUAL_WIDTH, "center" )
        love.graphics.printf("KALADANDA",0 , 80, VIRTUAL_WIDTH, "center" )
        
        -- Instruction Text
        love.graphics.setFont(default_font)
        love.graphics.printf("Press Enter to Start", 0, 256, VIRTUAL_WIDTH, 'center')
    end

    -- Print Score and Damage
    if game_state == "play" or game_state == "pause_menu" or DEBUG_STATE == true then 
        love.graphics.setFont(default_font)
        love.graphics.printf("Damage: " , 10, VIRTUAL_HEIGHT - 12, VIRTUAL_WIDTH/2, 'left')
        love.graphics.rectangle("line", 72, VIRTUAL_HEIGHT - 12- 8-1, 82, 18)
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", 73, VIRTUAL_HEIGHT - 12- 8, 20 * (world.player_1.damage-1), 16)
        love.graphics.setColor(1,1,1)
        love.graphics.printf("Score: ".. world.player_1.score, VIRTUAL_WIDTH /2 + 5, VIRTUAL_HEIGHT - 12, VIRTUAL_WIDTH/2, 'left')
    end 
    
     push:apply("end")
end

function love.keypressed(key)
    if key == 'escape' then
        if game_state == 'title_screen' then
            love.event.quit()
        elseif game_state == "start_menu" then
            game_state = "title_screen"
        elseif game_state == "play" then
            game_state = "pause_menu"
        elseif game_state == "pause_menu" then
            game_state = "start_menu"
        end
    elseif (key == "enter" or key == "return") then
        if game_state == "title_screen" then game_state = "start_menu"
        elseif game_state == "start_menu" then game_state = "play"
        elseif game_state == "pause_menu" then game_state = "play"
        end
    elseif (key == "f1" and (game_state == "title_screen" or game_state == "start_menu")) then
       if DEBUG_STATE == false then
        DEBUG_STATE = true
        world:generate_enemy_wave("debug") 
       else DEBUG_STATE = false
        world:clear_enemy_wave()
        world:clear_projectiles()
       end
    end
end

function displayFPS()
    love.graphics.setFont(fps_font)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1,1,1,1)
end



