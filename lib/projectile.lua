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
    self.x = x+offset
    self.y = y
    self.dx = 0
    self.dy = 0
    self.type = type or "bullet"
    self.rotation_offset = r
    if self.type == "bullet" then
        self.velocity = 200
        self.acceleration = 0
        self.width = 1
        self.height = 2
        self.damage = 0.5
        self.frame = TILE_BULLET
        self.hit_frame = TILE_BULLET_HIT
    elseif self.type == "rocket" then
        self.velocity =  30
        self.acceleration = 300
        self.width = 2
        self.height = 6
        self.damage = 1
        self.frame = TILE_MISSILE
        self.hit_frame = TILE_MISSILE_HIT
    elseif self.type == "missile" then
        if #world.enemies > 0 then
            self.target = world.enemies[math.random(1, #world.enemies)]
        end
        self.velocity =  5
        self.acceleration = 500
        self.width = 2
        self.height = 6
        self.damage = 1
        self.frame = TILE_MISSILE
        self.hit_frame = TILE_MISSILE_HIT
    elseif self.type == "nuke" then
        self.acceleration = 10
        self.velocity =  20
        self.width = 5
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
    self.explosion_length = 0.5
end

function Projectile:update(dt)
    if self.type == "missile" then
        self:track_location(dt)
    end
    self.dx = self.dx + self.acceleration * math.sin(self.rotation_offset) * dt
    self.dy = self.dy + self.acceleration * math.cos(self.rotation_offset) * dt
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end


function Projectile:render()
   love.graphics.draw(
       self.texture,
       self.frames[self.frame],
       self.x,
       self.y,
       -self.rotation_offset,
       2,
       2,
       3.5,
       3.5)
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