-- Created in IntelliJ IDEA.
-- User: Yaan Dalzell
-- Date: 15/08/2020
-- Time: 3:08 PM

-- Description: Creates a pixel class for use in Blackwing Kaladanda V1.0

Pixel = Class{}

function Pixel:init(x, y, dx, dy, params)
    self.x = x
    self.y = y
    self.dx = dx
    self.dy = dy
    self.r = params["r"]
    self.g = params["g"]
    self.b = params["b"]
    self.a = params["a"]
end

function Pixel:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Pixel:render()
    love.graphics.setColor(self.r, self.g, self.b, self.a)
    love.graphics.rectangle(
    "fill",
    self.x,
    self.y,
    2,
    2
    )
    love.graphics.setColor(1, 1, 1, 1)
end

