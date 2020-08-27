-- Created in VSCode
-- User: Yaan Dalzell
-- Date:
-- Time:

-- Description: Creates an enemy object for Blackwing Kaladanda V1.0

Enemy = Class{}

-- Frame ID's
-- Stealth Bomber (Nuke)
STEALTH_IDLE = 1
STEALTH_RIGHT = 2
STEALTH_LEFT = 3
STEALTH_EXPLOSION_1 = 4
STEALTH_EXPLOSION_2 = 5

-- Raider (Machine Gun)
RAIDER_IDLE = 7
RAIDER_RIGHT = 8
RAIDER_LEFT = 9
RAIDER_EXPLOSION_1 = 10
RAIDER_EXPLOSION_2 = 11

-- Destroyer (Missile)
DESTROYER_IDLE = 13
DESTROYER_RIGHT = 14
DESTROYER_LEFT = 15
DESTROYER_EXPLOSION_1 = 16
DESTROYER_EXPLOSION_2 = 17

--Explosion
EXPLODE_3 = 6
EXPLODE_4 = 12
EXPLODE_5 = 18

function Enemy:init(world, type, level, x, y, r, dx, dy)
    -- Set base level variables
    self.state = "idle"
    self.width = 10
    self.height = 10
    self.level = level
    self.rotation_offset = r
    self.weapon_lock = false
    self.weapon_timer = 0
    self.type = type
    self.dx = dx
    self.dy = dy
    self.x = x
    self.y = y
    self.explosion_timer = 0
    self.explosion_length = 0.5
    
    -- Load textures
    self.texture = love.graphics.newImage("/resources/graphics/enemy_ships.png")
    self.frames = generate_quads(self.texture, self.width, self.height)

    -- Define Frames and Fire Intervals as per type
    if self.type == "stealth" then
        self.idle_frame = STEALTH_IDLE
        self.left_frame = STEALTH_LEFT
        self.right_frame = STEALTH_RIGHT
        self.explode_frame_1 = STEALTH_EXPLOSION_1
        self.explode_frame_2 = STEALTH_EXPLOSION_2
        self.weapon = "nuke"
        self.weapon_interval = 100
    elseif self.type == "raider" then
        self.idle_frame = RAIDER_IDLE
        self.left_frame = RAIDER_LEFT
        self.right_frame = RAIDER_RIGHT
        self.explode_frame_1 = RAIDER_EXPLOSION_1
        self.explode_frame_2 = RAIDER_EXPLOSION_2
        self.weapon = "bullet"
        self.weapon_interval = 3
    elseif self.type == "destroyer" then
        self.idle_frame = DESTROYER_IDLE
        self.left_frame = DESTROYER_LEFT
        self.right_frame = DESTROYER_RIGHT
        self.explode_frame_1 = DESTROYER_EXPLOSION_1
        self.explode_frame_2 = DESTROYER_EXPLOSION_2
        self.weapon = "missile"
        self.weapon_interval = 4
    end

    self.explode_frame_3 = EXPLODE_5
    self.explode_frame_4 = EXPLODE_4
    self.explode_frame_5 = EXPLODE_3
    -- Generate Animations
    self.animations = self:generate_animations(self.type)
    self.animation = self.animations[self.state]




end

function Enemy:update(dt)
    -- Fire Weapon
    self:fire_weapon()
    self.animation = self.animations[self.state]
    self.animation:update(dt)
    self:update_weapon_timer(dt)
    self.x = self.x+self.dx*dt
    self.y = self.y+self.dy*dt
    if self.state=="exploding" then
        self.explosion_timer = self.explosion_timer+dt
    end
end

function Enemy:render()
--    love.graphics.circle('line', self.x, self.y, self.width)
    love.graphics.draw(
        self.texture,
        self.animation:get_current_frame(),
        math.floor(self.x),
        math.floor(self.y),
        0,
        self.animation.scale_factor*2,
        self.animation.scale_factor*2,--1,
        self.width/2,
        self.height/2
    )
end

function Enemy:generate_animations()
    animations = {
        ['idle'] = Animation{
            texture = self.texture,
            frames = {
                self.frames[self.idle_frame]
            },
            interval = 1
        },
        ['left'] = Animation{
            texture = self.texture,
            frames = {
                self.frames[self.left_frame]
            },
            interval = 1
        },
        ['right'] = Animation{
            texture = self.texture,
            frames = {
                self.frames[self.right_frame]
            },
            interval = 1
        },
        ['exploding'] = Animation{
            texture = self.texture,
            frames = {
                self.frames[self.explode_frame_1],
                self.frames[self.explode_frame_2],
                self.frames[self.explode_frame_3],
                self.frames[self.explode_frame_4],
                self.frames[self.explode_frame_5],
                self.frames[self.explode_frame_5]
            },
            interval = 0.1
        },
    }
    return animations
end

function Enemy:fire_weapon(x, y)
    if self.weapon_lock == false and (self.weapon_timer >= self.weapon_interval or self.weapon_timer == 0) then
        table.insert(world.enemy_projectiles, Projectile(self.weapon, self.x, self.y, 0, -1, 0))
        if self.weapon == "nuke" then
            world.world_sounds["enemy_nuke_warning"]:play()
        elseif self.weapon == "missile" then
            world.world_sounds["enemy_missile"]:play()
        else
            world.world_sounds["enemy_cannon"]:play()
        end
        self.weapon_timer = 0
    end
end

function Enemy:update_weapon_timer(dt)
    self.weapon_timer = self.weapon_timer + dt
end