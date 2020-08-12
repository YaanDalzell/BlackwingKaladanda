
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
    instruction_font = love.graphics.newFont("/resources/advanced_pixel_lcd-7.ttf", 8)
    -- Create world 
    world = World()
    world:generate_enemy_wave("debug")

    -- Set Application State
    game_state = 'Menu'
end

function love.update(dt)
    world:update(dt)

end

function love.draw()
    push:apply('start') 

    -- Render world
    world:render()
    
    -- Menu display scripts
    if game_state == 'Menu' then
        -- Title Text
        love.graphics.setFont(title_font)
        love.graphics.printf("BlackWing",0 , 50, VIRTUAL_WIDTH, 'center' )
        love.graphics.printf("KALADANDA",0 , 80, VIRTUAL_WIDTH, 'center' )
        
        -- Instruction Text
        love.graphics.setFont(instruction_font)
        love.graphics.printf("Launch: Enter", 0, 256, VIRTUAL_WIDTH, 'center')
    end

    -- Print Score and Damage
    if game_state == "Play" then 
        love.graphics.setFont(instruction_font)
        love.graphics.printf("Damage: " , 10, VIRTUAL_HEIGHT - 12, VIRTUAL_WIDTH/2, 'left')
        love.graphics.rectangle("line", 72, VIRTUAL_HEIGHT - 12- 8-1, 82, 18)
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", 73, VIRTUAL_HEIGHT - 12- 8, 20 * (world.player_1.damage-1), 16)
        love.graphics.setColor(1,1,1)
        love.graphics.printf("Score: ".. world.player_1.score, VIRTUAL_WIDTH /2 + 5, VIRTUAL_HEIGHT - 12, VIRTUAL_WIDTH/2, 'left')
    end

    -- Print Game state
     love.graphics.setFont(instruction_font)
     love.graphics.printf(game_state, 0, 300, VIRTUAL_WIDTH, 'center')
    
    
     push:apply("end")
end

function love.keypressed(key)
    if key == 'escape' and game_state == 'Menu' then
        love.event.quit()
    elseif key == 'escape' and game_state ~='Menu' then
        game_state = 'Menu'
    elseif (key == 'enter' or key == 'return') and game_state == 'Menu' then
        game_state = 'Play'
    end
end



