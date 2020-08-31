-- Created in IntelliJ IDEA.
-- User: Yaan Dalzell
-- Date: 15/08/2020
-- Time: 3:08 PM

-- Description: Creates a pixel class for use in Blackwing Kaladanda V1.0

Pixel = Class{}

function Pixel:init(x, y, dx, dy, width, height, colour)
    self.x = x
    self.y = y
    self.dx = dx
    self.dy = dy
    self.width = width
    self.height = height
    self.r = colour["r"]
    self.g = colour["g"]
    self.b = colour["b"]
    self.a = colour["a"]
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
    self.width,
    self.height
    )
    love.graphics.setColor(1, 1, 1, 1)
end

