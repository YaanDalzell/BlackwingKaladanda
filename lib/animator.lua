-- Created in VSCode
-- User: Yaan Dalzell
-- Date:
-- Time:

-- Description: Provides animation for Blackwing Kaladanda V1.0

Animation = Class{}

function Animation:init(params)
    self.texture = params.texture
    self.frames = params.frames
    self.interval = params.interval or 0.5
    self.timer = 0
    self.current_frame = 1
    self.scale_factor = params.scale_factor or 1
end

function Animation:get_current_frame()
    return self.frames[self.current_frame]
end

function Animation:restart()
    self.timer = 0
    self.current_frame = 1
end

function Animation:update(dt)
    self.timer = self.timer+dt

    if #self.frames == 1 then
        return self.current_frame
    else
        while self.timer>self.interval do
            self.timer = self.timer - self.interval
            self.current_frame = (self.current_frame + 1) % (#self.frames+1)
            if self.current_frame == 0 then self.current_frame = 1
            end
        end
    end
end
