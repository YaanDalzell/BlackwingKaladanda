Enemy = Class{}

-- Frame ID's
-- Stealth Bomber (Nuke)
STEALTH_IDLE = 1
STEALTH_RIGHT = 2
STEALTH_LEFT = 3
STEALTH_EXPLOSION_1 = 4
STEALTH_EXPLOSION_2 = 5

-- Raider (Machine Gun)
RAIDER_IDLE = 6
RAIDER_RIGHT = 7
RAIDER_LEFT = 8
RAIDER_EXPLOSION_1 = 9
RAIDER_EXPLOSION_2 = 10

-- Destroyer (Missile)
DESTROYER_IDLE = 11
DESTROYER_RIGHT = 12
DESTROYER_LEFT = 13
DESTROYER_EXPLOSION_1 = 14
DESTROYER_EXPLOSION_2 = 15

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
        self.weapon_interval = 10
    elseif self.type == "raider" then
        self.idle_frame = RAIDER_IDLE
        self.left_frame = RAIDER_LEFT
        self.right_frame = RAIDER_RIGHT
        self.explode_frame_1 = RAIDER_EXPLOSION_1
        self.explode_frame_2 = RAIDER_EXPLOSION_2
        self.weapon = "bullet"
        self.weapon_interval = 1
    elseif self.type == "destroyer" then
        self.idle_frame = DESTROYER_IDLE
        self.left_frame = DESTROYER_LEFT
        self.right_frame = DESTROYER_RIGHT
        self.explode_frame_1 = DESTROYER_EXPLOSION_1
        self.explode_frame_2 = DESTROYER_EXPLOSION_2
        self.weapon = "missile"
        self.weapon_interval = 3
    end

    -- Generate Animations
    self.animations = self:generate_animations(self.type)
    self.animation = self.animations[self.state]




end

function Enemy:update(dt)
    -- Fire Weapon
    self:fire_weapon()
    self:update_weapon_timer(dt)
    self.x = self.x+self.dx
    self.y = self.y+self.dy
end

function Enemy:render()
    -- love.graphics.circle('line', self.x, self.y, self.width)
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
        ['explode'] = Animation{
            texture = self.texture,
            frames = {
                self.frames[self.explode_frame_1],
                self.frames[self.explode_frame_2]
            },
            interval = 0.5
        },
    }
    return animations
end

function Enemy:fire_weapon(x, y)
    if self.weapon_lock == false and (self.weapon_timer >= self.weapon_interval or self.weapon_timer == 0) then
        table.insert(world.projectiles, Projectile(self.weapon, self.x, self.y, 0, -1, 0))
        self.weapon_timer = 0
    end
end

function Enemy:update_weapon_timer(dt)
    self.weapon_timer = self.weapon_timer+dt
end