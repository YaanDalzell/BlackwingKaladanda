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

function Projectile:init(type, x, y, r, dy, offset)
    self.x = x+offset
    self.y = y
    self.dx = 0
    self.type = type or "bullet"
    self.rotation_offset = r
    if self.type == "bullet" then
        self.dy = 200 * -dy
        self.ddy = 0
        self.width = 1
        self.height = 2
        self.damage = 0.5
        self.frame = TILE_BULLET
        self.hit_frame = TILE_BULLET_HIT
    elseif self.type == "missile" then
        self.dy =  30 * -dy
        self.ddy = 200 * -dy
        self.width = 2
        self.height = 6
        self.damage = 1
        self.frame = TILE_MISSILE
        self.hit_frame = TILE_MISSILE_HIT
    elseif self.type == "nuke" then
        self.dy = 10 * -dy
        self.ddy = 0
        self.width = 5
        self.height = 8
        self.damage = 100
        self.frame = TILE_NUKE
        self.hit_frame = TILE_NUKE_HIT
    end

    self.texture = love.graphics.newImage("/resources/graphics/projectiles.png")
    self.frames = generate_quads(self.texture, 7, 7)
end

function Projectile:update(dt)
    self.x = self.x + self.dx * dt
    self.dy = self.dy + self.ddy*dt
    self.y = self.y + self.dy * dt 
end

function Projectile:render()
   love.graphics.draw(
       self.texture,
       self.frames[self.frame],
       self.x,
       self.y,
       self.rotation_offset,
       2,
       2,
       3.5,
       3.5)
end
