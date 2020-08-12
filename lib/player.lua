Player = Class{}

-- Frame ID's
-- Damage Level 0
SHIP_IDLE_1 = 1
SHIP_RIGHT_1 = 2
SHIP_LEFT_1 = 3

-- Damage Level 1
SHIP_IDLE_2 = 4
SHIP_RIGHT_2 = 5
SHIP_LEFT_2 = 6

-- Damage Level 2
SHIP_IDLE_3 = 7
SHIP_RIGHT_3 = 8
SHIP_LEFT_3 = 9

-- Damage Level 3
SHIP_IDLE_4 = 10
SHIP_RIGHT_4 = 11
SHIP_LEFT_4 = 12

-- Dead Ship
SHIP_IDLE_5 = 13
SHIP_RIGHT_5 = 14
SHIP_LEFT_5 = 15

function Player:init(world)
    -- Basic Initialisations
    self.player_state = "idle"
    self.score = 0
    self.damage = 1
    self.play_timer = 0
    self.width = 16
    self.height = 16

    -- Control Weapons Repeat Rate
    self.cannon_lock = false
    self.cannon_timer = 0
    self.cannon_interval = 0.5
    self.cannon_offset = 10


    self.missile_lock = false
    self.missile_timer = 0
    self.missile_interval = 2
    self.missile_offset = 4

    self.nuke_lock = false
    self.nuke_timer = 0
    self.nuke_interval = 120

    self.idle_frame = SHIP_IDLE_1
    self.left_frame = SHIP_LEFT_1
    self.right_frame = SHIP_RIGHT_1

    -- Spatials
    -- Location
    self.x = VIRTUAL_WIDTH/2
    self.y = VIRTUAL_HEIGHT - self.height - 50
    -- Velocity
    self.dx = 0
    self.dy = 0
    -- Acceleration
    self.ddx = 0
    self.ddy = 0
    -- Impulse
    self.impulse = 500

    -- Load player graphics
    self.texture = love.graphics.newImage("/resources/player_1_ship.png")
    self.frames = generate_quads(self.texture, self.width, self.height)
    
    -- Animations
    self.animations = self:generate_animations()
    
    self.animation = self.animations[self.player_state]

end

function Player:update(dt)
    -- Check World Limit Collisions
    self:check_movement_limits()

    -- Update play timer
    self.play_timer = self.play_timer + dt

    -- Debug -- Check Visual Damage Updates
    self.damage = math.floor(self.play_timer % 5)+1
    -- Debug -- Check Score Updates
    self.score = math.floor(self.play_timer)


    -- Update animations
    self.animations = self:generate_animations()
    -- Update Ship Damage Level
    if self.damage == 1 then
        self.idle_frame = SHIP_IDLE_1
        self.right_frame = SHIP_RIGHT_1
        self.left_frame = SHIP_LEFT_1
    elseif self.damage == 2 then
        self.idle_frame = SHIP_IDLE_2
        self.right_frame = SHIP_RIGHT_2
        self.left_frame = SHIP_LEFT_2
    elseif self.damage == 3 then
        self.idle_frame = SHIP_IDLE_3
        self.right_frame = SHIP_RIGHT_3
        self.left_frame = SHIP_LEFT_3
    elseif self.damage == 4 then
        self.idle_frame = SHIP_IDLE_4
        self.right_frame = SHIP_RIGHT_4
        self.left_frame = SHIP_LEFT_4
    else -- Ship damage > 4
        self.idle_frame = SHIP_IDLE_5
        self.right_frame = SHIP_RIGHT_5
        self.left_frame = SHIP_LEFT_5
    end

    -- Move this to a behaviours table
    -- X movement
    if love.keyboard.isDown('left')  then
        self.ddx = -self.impulse
    elseif love.keyboard.isDown('right')  then
        self.ddx = self.impulse
    else 
        if self.dx > 0 then
            self.ddx = -self.impulse
        elseif self.dx < 0 then
            self.ddx = self.impulse
        else
            self.ddx = 0
        end
    end
    -- Y Movement
    if love.keyboard.isDown('up')  then
        self.ddy = -self.impulse
    elseif love.keyboard.isDown('down')  then
        self.ddy = self.impulse
    else 
        if self.dy > 0 then
            self.ddy = -self.impulse
        elseif self.dy < 0 then
            self.ddy = self.impulse
        else
            self.ddy = 0
        end
    end
    -- Fire Control
    if love.keyboard.isDown('space') then
        self:fire_cannon(self.x, self.y)
    end
    if love.keyboard.isDown('lalt') then
        self:fire_missile(self.x, self.y)
    end
    if love.keyboard.isDown('n') then
        self:fire_nuke(self.x, self.y)
    end

    -- Update spatials
    self.play_timer = self.play_timer + dt
    self.dx = self.dx+math.floor(self.ddx*dt)
    self.x = math.max(self.width, math.min(self.x+(self.dx*dt), VIRTUAL_WIDTH+self.width/2))
    self.dy = self.dy+math.floor(self.ddy*dt)
    self.y = math.min(world.bottom_player_border-self.height, math.max(self.y+self.dy*dt, world.top_player_border))

    -- Update animation depending on velocity
    if self.dx > 30  then
        self.player_state = "right"
    elseif self.dx < -30 then
        self.player_state = "left"
    else 
        self.player_state = "idle" 
    end
    
    -- Update Weapon Locks
    self:update_weapon_locks(dt)
    
    self.animation = self.animations[self.player_state]
    self.animation:update(dt)

end

function Player:render()
    -- love.graphics.circle('line', math.floor(self.x), math.floor(self.y), 16)
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
    love.graphics.print(self.dx, 50, 350)
    love.graphics.print(self.ddx, 50, 400)
    love.graphics.print(self.damage, 50, 450)
end

function Player:generate_animations()
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
    }
    return animations
end

function Player:fire_cannon(x, y, dy)
    if self.cannon_lock == false then
        bullet = Projectile("bullet", self.x, self.y, math.pi, 1, self.cannon_offset)
        table.insert(world.projectiles, bullet)
        self.cannon_lock = true
        self.cannon_timer = 0
    end
end

function Player:fire_missile(x, y, dy)
    if self.missile_lock == false then
        missile = Projectile("missile", self.x, self.y, math.pi, 1, self.missile_offset)
        table.insert(world.projectiles, missile)
        self.missile_lock = true
        self.missile_timer = 0
    end
end

function Player:fire_nuke(x, y, dy)
    if self.nuke_lock == false then
        nuke = Projectile("nuke", self.x, self.y, math.pi, 1, 0)
        table.insert(world.projectiles, nuke)
        self.nuke_lock = true
        self.nuke_timer = 0
    end
end

function Player:update_weapon_locks(dt)
    -- Update Cannon Lock
    if self.cannon_lock == true then
        self.cannon_timer = self.cannon_timer + dt
        if self.cannon_timer >= self.cannon_interval then
            self.cannon_lock = false
            self.cannon_timer = 0
            self.cannon_offset = -self.cannon_offset
        end
    end

    -- Update Missile Lock
    if self.missile_lock == true then
        self.missile_timer = self.missile_timer + dt
        if self.missile_timer >= self.missile_interval then
            self.missile_lock = false
            self.missile_timer = 0
            self.missile_offset = -self.missile_offset
        end
    end

    -- Update Nuke Lock
    if self.nuke_lock == true then
        self.nuke_timer = self.nuke_timer + dt
        if self.nuke_timer >= self.nuke_interval then
            self.nuke_lock = false
            self.nuke_timer = 0
        end
    end
end

function Player:check_movement_limits()
    if self.x <= self.width and (self.ddx < 0 or self.dx < 0) then
        self.ddx = 0
        self.dx = 0
        self.x = 0
    elseif self.x+self.width >= VIRTUAL_WIDTH and (self.ddx > 0 or self.dx > 0) then
        self.ddx = 0
        self.dx = 0
        self.x = VIRTUAL_WIDTH - self.width
    end
    if self.y >= world.bottom_player_border-self.height and (self.ddy > 0 or self.dy > 0) then
        self.ddy = 0
        self.dy = 0
        self.y = world.bottom_player_border-self.height
    elseif self.y <= world.top_player_border and (self.ddy < 0 or self.dy < 0) then
        self.ddy = 0
        self.dy = 0
        self.y = world.top_player_border
    end
end



