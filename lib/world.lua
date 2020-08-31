-- Created in VSCode
-- User: Yaan Dalzell
-- Date:
-- Time:

-- Description: Provides "world" functionality to Blackwing Kaladanda V1.0


World = Class{}

function World:init()
    -- Load World Sounds
    self.world_sounds = {
        -- Weapon Sounds
        ['cannon'] = love.audio.newSource('resources/sounds/cannon.wav', 'static'),
        ['missile'] = love.audio.newSource('resources/sounds/missile.wav', 'static'),
        ['nuke'] = love.audio.newSource('resources/sounds/nuke_warning.wav', 'static'),
        ['player_nuke_warning'] = love.audio.newSource('resources/sounds/player_nuke_warning.wav', 'static'),
        ['enemy_nuke_warning'] = love.audio.newSource('resources/sounds/enemy_nuke_warning.wav', 'static'),
        ['enemy_missile'] = love.audio.newSource('resources/sounds/enemy_missile.wav', 'static'),
        ['enemy_cannon'] = love.audio.newSource('resources/sounds/enemy_cannon.wav', 'static'),
        ['kaladanda_fire'] = love.audio.newSource('resources/sounds/kaladanda_fire.wav', 'static'),

        -- Environment Sounds
        ['player_1_engine'] = love.audio.newSource('resources/sounds/thrusters.mp3', 'static'),
        ['player_hit'] = love.audio.newSource('resources/sounds/player_hit.wav', 'static'),
        ['player_explodes'] = love.audio.newSource('resources/sounds/player_explodes.wav', 'static'),
        ['player_explodes_1'] = love.audio.newSource('resources/sounds/explosion_1.wav', 'static'),
        ['enemy_explodes'] = love.audio.newSource('resources/sounds/enemy_explode.wav', 'static'),
        ['damage_warning'] = love.audio.newSource('resources/sounds/damage_warning.wav', 'static'),
    }

    -- Create Player
    self.bottom_player_border = VIRTUAL_HEIGHT-25
    self.top_player_border = VIRTUAL_HEIGHT/2
    self.player_1 = Player(self)

    -- Bullets and Projectiles Exist in the world
    self.projectiles = {}
    self.enemy_projectiles = {}

    -- Enemies exist in the world
    self.enemy_texture = love.graphics.newImage("resources/graphics/enemy_ships.png")
    self.enemy_frames = generate_quads(self.enemy_texture, 10, 10)
    self.enemies = {}

    -- Set Scenery
    self.scene = star_scape()

    -- Track Wave
    self.wave_counter = 0
    self.wave_timer = 0
    self.wave = Wave(self,0)

end

function World:update(dt)
    if self.wave_counter > 0 then-- Update Wave
        self.wave:update(dt)
    end

    -- update scenery
    self.scene:update(dt)

    -- update player
    self.player_1:update(dt)

    -- update bullets
    self:update_projectiles(dt)

    -- update enemies
    self:update_enemies(dt)

    -- Check collisions detections
    self:collision_detection()

end

function World:render()

    -- render scenery
    self.scene:render()

    -- render bullets
    self:render_projectiles()

    -- render enemies
    self:render_enemies()
    
    -- render player
    self.player_1:render()

    -- Render Wave
    self.wave:render()
    
    
end

function World:update_projectiles(dt)
    for i = 1, #self.projectiles do
        self.projectiles[i]:update(dt)
    end
    for i = 1, #self.enemy_projectiles do
        self.enemy_projectiles[i]:update(dt)
    end
end

function World:render_projectiles(dt)
    for i = 1, #self.projectiles do
        self.projectiles[i]:render()
    end
    for i = 1, #self.enemy_projectiles do
        self.enemy_projectiles[i]:render()
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
        table.insert(self.enemies, Enemy(self, "raider", 0, VIRTUAL_WIDTH/4, 400, 0, 0, 0))
        table.insert(self.enemies, Enemy(self, "destroyer", 0, VIRTUAL_WIDTH/2, 400, 0, 0, 0))
        table.insert(self.enemies, Enemy(self, "stealth", 0, VIRTUAL_WIDTH/4*3, 400, 0, 0, 0))
    end 
end

function World:clear_enemy_wave()
    self.enemies = {}
end

function World:clear_projectiles()
    self.projectiles = {}
    self.enemy_projectiles = {}
end

function World:collision_detection()

    --  Check Stale Enemies
    local array_size = #self.enemies
    for i = 0, array_size - 1 do
        if self:check_stale(self.enemies[array_size-i], "enemy")  == true then
            table.remove(self.enemies, array_size-i)
        end
    end

    --  Check Stale Enemy Projectiles
    array_size = #self.enemy_projectiles
    for i = 0, array_size - 1 do
        if self:check_stale(self.enemy_projectiles[array_size-i], "enemy_projectile") == true then
            table.remove(self.enemy_projectiles, array_size-i)
        end
    end

    --  Check Stale Player Projectiles
    array_size = #self.projectiles
    for i = 0, array_size - 1 do
        if self:check_stale(self.projectiles[array_size-i], "projectile") == true then
            table.remove(self.projectiles, array_size-i)
        end
    end

    --  Check Collisions between ships
    --  Version 1.0 Will use AABB Collision Detection
    array_size = #self.enemies
    for i = 0, array_size - 1 do
        if detect_ship_collision(self.enemies[array_size - i], self.player_1) == true then
            self.player_1:damage_ship(1)
            self.world_sounds["enemy_explodes"]:play()
            table.remove(self.enemies, array_size-i)
        end
    end

    --  Check collisions between player ship and enemy projectiles
    array_size = #self.enemy_projectiles
    for i = 0, array_size - 1 do
        if self.enemy_projectiles[array_size - i].state == "idle" or
                (self.enemy_projectiles[array_size - i].state == "exploding" and
                        self.enemy_projectiles[array_size - i].type == "nuke") then
            if detect_projectile_collision(self.enemy_projectiles[array_size - i], self.player_1) == true then
                self.player_1:damage_ship(1)
                self.enemy_projectiles[array_size - i].state = "exploding"
            end
        end
    end

    --  Check collisions between enemy ships and player projectiles
    array_size = #self.projectiles
    local array_size_2 = #self.enemies
    for i = 0, array_size - 1 do
        for j = 0, array_size_2 - 1 do
            if detect_projectile_collision(self.projectiles[array_size - i], self.enemies[array_size_2 - j]) == true then
                self.world_sounds["enemy_explodes"]:play()
                self.player_1.score = self.player_1.score + 1
                self.enemies[array_size_2 - j].state = "exploding"
                self.projectiles[array_size - i].state = "exploding"
                return
            end
        end
    end
end


function World:check_stale(instance, instance_type)
    if instance_type == "enemy" or instance_type == "enemy_projectile" then
        if instance.x - instance.width > VIRTUAL_WIDTH or
                instance.x + instance.width < 0 or
                instance.y - instance.height > VIRTUAL_HEIGHT or
                instance.explosion_timer > instance.explosion_length
            then return true
        end
        return false
    end
    if instance_type == "projectile" then
        if instance.x - instance.width > VIRTUAL_WIDTH or
                instance.x + instance.width < 0 or
                instance.y + instance.height < 0 or
                instance.explosion_timer > instance.explosion_length
        then return true
        end
        return false
    end
    return false
end