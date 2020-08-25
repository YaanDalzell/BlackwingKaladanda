--
-- Created in IntelliJ IDEA.
-- User: Yaan Dalzell
-- Date: 16/08/2020
-- Time: 6:37 PM
--


Wave = Class{}

function Wave:init(world, wave_number)
    -- Set main wave parameters
    self.wave_timer = 0
    self.wave = wave_number
    self.wave_state = 'loading'

    -- Set Enemy Deployment Timer dependent on ship type and inversely proportional to wave number
    self.raider_reset_time = 1 * 3 / self.wave
    self.destroyer_reset_time = 3 * 3 / self.wave
    self.stealth_reset_time = 10 * 3 / self.wave

    -- Track time since last enemy type deployment
    self.raider_timer = 0
    self.destroyer_timer = 0
    self.stealth_timer = 0

    -- Set max number of deployed enemies per type per wave
    self.max_raider_deployments = math.floor(self.wave * 0.5 * 5)
    self.max_destroyer_deployments = math.floor(self.wave * 0.5 * 3)
    self.max_stealth_deployents = math.floor(self.wave * 0.5 * 0.3)

    -- Set Deployed enemy counter
    self.raiders_deployed = 0
    self.destroyers_deployed = 0
    self.stealths_deployed = 0

    self.world = world
end

function Wave:update(dt)

    -- Behaviours Governing Wave Loading State
    if self.wave_state == "loading" then
        self.wave_timer = self.wave_timer + dt
        if self.wave_timer > 3 then self.wave_state = "deploying" end
    end

    -- Behaviours Governing Wave Deployment State
    if self.wave_state == 'deploying' then
        --    Generate Raiders
        if self.raider_timer > self.raider_reset_time and self.raiders_deployed < self.max_raider_deployments then
            table.insert(self.world.enemies, Enemy(self.w, "raider", 0, math.random(20, VIRTUAL_WIDTH-20), -20, 0, 0, 30))
            self.raiders_deployed = self.raiders_deployed + 1
            self.raider_timer = 0
        end
        --    Generate Destroyers
        if self.destroyer_timer > self.destroyer_reset_time and self.destroyers_deployed < self.max_destroyer_deployments
        then
            table.insert(self.world.enemies, Enemy(self.w, "destroyer", 0, math.random(20, VIRTUAL_WIDTH-20), -20, 0, 0, 50))
            self.destroyers_deployed = self.destroyers_deployed + 1
            self.destroyer_timer = 0
        end
        --    Generate Stealth
        if self.stealth_timer > self.stealth_reset_time and self.stealths_deployed < self.max_stealth_deployents
        then
            table.insert(self.world.enemies, Enemy(self.w, "stealth", 0, math.random(20, VIRTUAL_WIDTH-20), -20, 0, 0, 300))
            self.stealths_deployed = self.stealths_deployed + 1
            self.stealth_timer = 0
        end
    end

    -- Check Deployment State
    if self.raiders_deployed == self.max_raider_deployments and
            self.destroyers_deployed == self.max_destroyer_deployments and
            self.stealths_deployed == self.max_stealth_deployents then
        self.wave_state = "deployed"
    end

    -- If a wave is fully deployed check whether the wave assets are destroyed
    if self.wave_state == "deployed" then
        if #self.world.enemies == 0 then
            self:init(self.world, self.wave+1)
        end
    end

    self.raider_timer = self.raider_timer + dt
    self.destroyer_timer = self.destroyer_timer + dt
    self.stealth_timer = self.stealth_timer + dt
    self.wave_timer = self.wave_timer + dt

end

function Wave:render()
    if self.wave > 0  and self.wave_timer < 3 then
        love.graphics.setFont(title_font)
        love.graphics.printf("Wave " ..tostring(self.wave),0 , 200, VIRTUAL_WIDTH, "center" )
        love.graphics.setFont(default_font)
    end
--    love.graphics.printf("State:"..(self.wave_state),0 , 200, VIRTUAL_WIDTH, "center" )
--    love.graphics.printf("Enemies:"..tostring(#self.world.enemies),0 , 230, VIRTUAL_WIDTH, "center" )
--    love.graphics.printf("Raiders:"..tostring(self.raiders_deployed).."/"..tostring(self.max_raider_deployments),0 , 260, VIRTUAL_WIDTH, "center" )
--    love.graphics.printf("Destroyers:"..tostring(self.destroyers_deployed).."/"..tostring(self.max_destroyer_deployments),0 , 290, VIRTUAL_WIDTH, "center" )
--    love.graphics.printf("Stealths:"..tostring(self.stealths_deployed).."/"..tostring(self.max_stealth_deployents),0 , 320, VIRTUAL_WIDTH, "center" )
end


