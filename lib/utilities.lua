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
