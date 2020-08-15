-- Created in IntelliJ IDEA.
-- User: Yaan Dalzell
-- Date: 15/08/2020
-- Time: 1:13 PM

-- Description: Creates a simple proceduraly generated "star map" background for Blackwing Kaladanda V1.0


star_scape = Class{}

function star_scape:init()
    self.map_x_velocity = 0
    self.map_y_velocity = 80
    self.pixel_colour_1= {
        ["r"] = 1,
        ["g"] = 1,
        ["b"] = 1,
        ["a"] = 1 }
    self.pixel_colour_2 = {
        ["r"] = 1,
        ["g"] = 0.5,
        ["b"] = 0.5,
        ["a"] = 1 }
    self.pixel_colour_3 = {
        ["r"] = 1,
        ["g"] = 0.8,
        ["b"] = 0.5,
        ["a"] = 1 }
    self.pixel_colour_4 = {
        ["r"] = 0.7,
        ["g"] = 0.8,
        ["b"] = 1,
        ["a"] = 1 }
    self.pixels = {}

    -- Set initial pixel map
    for x = 1, VIRTUAL_WIDTH do
        for y = 1, VIRTUAL_HEIGHT do
            if math.random(VIRTUAL_WIDTH * 5) == 1 then
                local size = math.random(1, 3)
                local velocity_multiplyer = math.random(1, 3)
                local colour = math.random(1, 15)
                if colour == 4 then
                    colour = self.pixel_colour_4
                elseif colour == 3 then
                    colour = self.pixel_colour_3
                elseif colour == 2 then
                    colour = self.pixel_colour_2
                else colour = self.pixel_colour_1
                end
                table.insert(self.pixels,
                    Pixel(x, y,
                        self.map_x_velocity,
                        self.map_y_velocity + velocity_multiplyer * 10,
                        size,
                        size,
                        colour))
            end
        end
    end
end

function star_scape:update(dt)
    --  Generate random "star pixels moving at map velocity"
    for p = 1, VIRTUAL_WIDTH do
        if math.random(VIRTUAL_WIDTH * 5) == 1 then
            local size = math.random(1, 3)
            local velocity_multiplyer = math.random(1, 3)
            local colour = math.random(1, 15)
            if colour == 4 then
                colour = self.pixel_colour_4
            elseif colour == 3 then
                colour = self.pixel_colour_3
            elseif colour == 2 then
                colour = self.pixel_colour_2
            else colour = self.pixel_colour_1
            end
            table.insert(self.pixels,
                Pixel(p, 0,
                    self.map_x_velocity,
                    self.map_y_velocity + velocity_multiplyer * 10,
                    size,
                    size,
                    colour))
        end
    end

    --  If Pixel is stale (out of display limit) delete the pixel, otherwise update it's position
    self.pixel_count = #self.pixels
    if self.pixel_count > 0 then
        for i = 0, self.pixel_count - 1 do
            if self.pixels[self.pixel_count-i].x > VIRTUAL_WIDTH
                or self.pixels[self.pixel_count - i].x < 0
                or self.pixels[self.pixel_count - i].y > VIRTUAL_HEIGHT then
            table.remove(self.pixels, self.pixel_count-i)
            else
                self.pixels[self.pixel_count - i]:update(dt)
            end
        end
    end
end

function star_scape:render()
    pixel_count = #self.pixels
    for i = 0, pixel_count - 1 do
        self.pixels[pixel_count - i]:render(dt)
    end
end

