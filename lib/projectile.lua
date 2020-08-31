-- Created in VSCode
-- User: Yaan Dalzell
-- Date:
-- Time:

-- Description: Defines projectile behaviours for Blackwing Kaladanda V1.0

Projectile = Class{}

TILE_BULLET = 1
TILE_BULLET_HIT = 4
TILE_NUKE = 2
TILE_NUKE_HIT = 5
TILE_MISSILE = 3
TILE_MISSILE_HIT = 6

function Projectile:init(type, x, y, r, offset, world)
    self.state = "idle"
    self.x = x+offset
    self.y = y
    self.dx = 0
    self.dy = 0
    self.world = world
    self.type = type or "bullet"
    self.rotation_offset = r
    if self.type == "bullet" then
        self.explosion_length = 0.1
        self.velocity = 200
        self.acceleration = 0
        self.width = 1
        self.damage_radius = 1
        self.height = 2
        self.damage = 0.5
        self.frame = TILE_BULLET
        self.hit_frame = TILE_BULLET_HIT
    elseif self.type == "rocket" then
        self.explosion_length = 0.1
        self.velocity =  30
        self.acceleration = 250
        self.damage_radius = 1
        self.width = 2
        self.height = 6
        self.damage = 1
        self.frame = TILE_MISSILE
        self.hit_frame = TILE_MISSILE_HIT
    elseif self.type == "missile" then
        self.explosion_length = 0.1
        if #world.enemies > 0 then
            self.target = world.enemies[math.random(1, #world.enemies)]
        end
        self.velocity =  5
        self.acceleration = 500
        self.width = 2
        self.damage_radius = 30
        self.height = 6
        self.damage = 1
        self.frame = TILE_MISSILE
        self.hit_frame = TILE_MISSILE_HIT
    elseif self.type == "nuke" then
        self.explosion_length = 1
        self.acceleration = 10
        self.velocity =  20
        self.width = 5
        if self.rotation_offset == 0 then
            self.damage_radius = 100
        else self.damage_radius = 300
        end
        self.height = 8
        self.damage = 100
        self.frame = TILE_NUKE
        self.hit_frame = TILE_NUKE_HIT
    end


    self.dx = self.velocity * math.sin(self.rotation_offset)
    self.dy = self.velocity * math.cos(self.rotation_offset)

    self.texture = love.graphics.newImage("/resources/graphics/projectiles.png")
    self.frames = generate_quads(self.texture, 7, 7)
    self.explosion_timer = 0

    self.animations = {
        ["idle"] = Animation{
            texture = self.texture,
            frames = {
                self.frames[self.frame]
            },
            interval = 1
        },
        ["exploding"] = Animation{
            texture = self.texture,
            frames = {
                self.frames[self.hit_frame]
            },
            interval = 1
        },
    }

    self.animation = self.animations[self.state]

end

function Projectile:update(dt)
    if self.type == "missile" then
        self:track_location(dt)
    end
    if self.type == "nuke" then
        if self.rotation_offset == math.pi and self.y < 200 and self.state ~= "exploding" then
            self.state = "exploding"
            self.world.world_sounds["nuke_det"]:play()
        elseif self.rotation_offset == 0 and self.y > VIRTUAL_HEIGHT - 60 and self.state ~= "exploding"  then
            self.state = "exploding"
            self.world.world_sounds["nuke_det"]:play()
        end
    end
    self.dx = self.dx + self.acceleration * math.sin(self.rotation_offset) * dt
    self.dy = self.dy + self.acceleration * math.cos(self.rotation_offset) * dt
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    self.animation = self.animations[self.state]
    self.animation:update(dt)
    if self.state == "exploding" then
        self.width = self.damage_radius
        self.height = self.damage_radius
        self.explosion_timer = self.explosion_timer+dt
    end
end


function Projectile:render()
   love.graphics.draw(
       self.texture,
       self.animation:get_current_frame(),
       self.x,
       self.y,
       -self.rotation_offset,
       2,
       2,
       3.5,
       3.5)

    -- Nuke Effects
    if (self.type == "nuke"  or self.type == "missile") and self.state == "exploding" then
        love.graphics.circle("line", self.x, self.y, self.damage_radius* self.explosion_timer*8)
        love.graphics.circle("fill", self.x, self.y, 10)
    end
end

function Projectile:track_location(dt)
    ---- Get angle of attack
    if self.target then
        dx = self.target.x - self.x
        dy =  self.target.y - self.y
        if dy < 0 then
            angle = math.atan(dx/dy) + math.pi
        elseif dy > 0 then
            if dx > 0 then
                angle = math.atan(dx/dy)
            elseif dx < 0 then
                angle = math.atan(dx/dy) + 2*math.pi
            end
        end
        if angle < self.rotation_offset then
            self.rotation_offset = self.rotation_offset - 2 * math.pi * dt
        elseif angle  > self.rotation_offset then
            self.rotation_offset = self.rotation_offset + 2 * math.pi * dt
        end
    end


end