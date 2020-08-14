World = Class{}

function World:init()
    -- Load World Sounds
    self.world_sounds = {
        -- Weapon Sounds
        ['cannon'] = love.audio.newSource('resources/sounds/cannon.wav', 'static'),
        ['missile'] = love.audio.newSource('resources/sounds/missile.wav', 'static'),
        ['nuke'] = love.audio.newSource('resources/sounds/nuke_warning.wav', 'static'),
        ['enemy_cannon'] = love.audio.newSource('resources/sounds/enemy_cannon.wav', 'static'),
        ['kaladanda_fire'] = love.audio.newSource('resources/sounds/kaladanda_fire.wav', 'static'),

        -- Environment Sounds
        ['player_1_engine'] = love.audio.newSource('resources/sounds/thrusters.mp3', 'static'),
        ['player_hit'] = love.audio.newSource('resources/sounds/player_hit.wav', 'static'),
        ['player_explode'] = love.audio.newSource('resources/sounds/player_explodes.wav', 'static'),
        ['enemy_explodes'] = love.audio.newSource('resources/sounds/enemy_explode.wav', 'static'),
    }

    -- Create Player
    self.bottom_player_border = VIRTUAL_HEIGHT-25
    self.top_player_border = VIRTUAL_HEIGHT/2
    self.player_1 = Player(self)

    -- Bullets and Projectiles Exist in the world
    self.projectiles = {}

    -- Enemies exist in the world
    self.enemy_texture = love.graphics.newImage("resources/graphics/enemy_ships.png")
    self.enemy_frames = generate_quads(self.enemy_texture, 10, 10)
    self.enemies = {}

end

function World:update(dt)
    -- update scenery

    -- update player
    self.player_1:update(dt)
    -- update bullets
    self:update_projectiles(dt)
    -- update enemies
    self:update_enemies(dt)

end

function World:render()
    -- render scenery
    
    -- render bullets
    self:render_projectiles()

    -- render enemies
    self:render_enemies()
    
    -- render player
    self.player_1:render()
    
    
end

function World:update_projectiles(dt)
    for i = 1, #self.projectiles do
        self.projectiles[i]:update(dt)
    end
end

function World:render_projectiles(dt)
    for i = 1, #self.projectiles do
        self.projectiles[i]:render()
    end
end

function World:update_enemies(dt)
    for i = 1, #self.enemies do
        self.enemies[i]:update(dt)
    end
end

function World:render_enemies(dt)
    for i = 1, #self.enemies do
        self.enemies[i]:render()
    end
end

function World:generate_enemy_wave(wave)
    if wave == "debug" then
        table.insert(self.enemies, Enemy(self, "raider", 0, VIRTUAL_WIDTH/4, 150, 0, 0, 0))
        table.insert(self.enemies, Enemy(self, "destroyer", 0, VIRTUAL_WIDTH/2, 150, 0, 0, 0))
        table.insert(self.enemies, Enemy(self, "stealth", 0, VIRTUAL_WIDTH/4*3, 150, 0, 0, 0))
    end 
end

function World:clear_enemy_wave()
    self.enemies = {}
end

function World:clear_projectiles()
    self.projectiles = {}
end

function World:collision_detection()

    --  Check Enemy Off Screen
    --  If off screen delete

    --  Check Collisions between ships
    --  trigger Destroy Enemy, 2*Damage to Player

    --  Check collisions between ships and projectiles
    --  Assign projectile damage to player ship
    --  Trigger Destroy enemy ships
end


