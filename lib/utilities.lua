-- Created in VSCode
-- User: Yaan Dalzell
-- Date:
-- Time:

-- Description: General Functions for Blackwing Kaladanda V1.0

function generate_quads(atlas, tile_width, tile_height)
    local sheet_width = atlas:getWidth()/tile_width
    local sheet_height = atlas:getHeight()/tile_height

    local quad_counter = 1
    local quads = {}

    for y = 0, sheet_height - 1 do
        for x = 0, sheet_width - 1 do
            quads[quad_counter] = love.graphics.newQuad(
                x*tile_width,
                y*tile_height,
                tile_width,
                tile_height,
                atlas:getDimensions()
            )
            quad_counter = quad_counter+1
        end
    end
    return quads
end

function detect_ship_collision(ship_1, ship_2)
    if ship_1.x - ship_1.width > ship_2.x + ship_2.width or
            ship_1.x + ship_1.width < ship_2.x - ship_2.width or
            ship_1.y + ship_1.height < ship_2.y - ship_2.height or
            ship_1.y - ship_1.height > ship_2.y + ship_2.height
        then
        return false
    else
        return true
    end
end

function detect_projectile_collision(projectile, ship)
    if ship.state ~= "exploding" then
        if projectile.x - projectile.width > ship.x + ship.width or
                projectile.x + projectile.width < ship.x - ship.width or
                projectile.y + projectile.height < ship.y - ship.height or
                projectile.y - projectile.height > ship.y + ship.height
        then
            return false
        else
            return true
        end
    end
end
