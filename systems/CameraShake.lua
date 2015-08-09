CameraShake = class('CameraShake')
local Shake = struct('creation_time', 'id', 'intensity', 'duration')

function CameraShake:initialize(camera)
    self.camera = camera
    self.x, self.y = camera:pos()
    self.shakes = {}
    self.shake_intensity = 0
    self.uid = 0
end

function CameraShake:add(intensity, duration)
    self.uid = self.uid + 1
    table.insert(self.shakes, Shake(love.timer.getTime(), self.uid, intensity, duration))
end

function CameraShake:remove(id)
    table.remove(self.shakes, findIndexByID(self.shakes, id))
end

function CameraShake:update()
    -- Calculates shake intensity based on current Shakes in self.shakes
    self.shake_intensity = 0
    for _, shake in ipairs(self.shakes) do
        if love.timer.getTime() > shake.creation_time + shake.duration then
            self:remove(shake.id)
        else self.shake_intensity = self.shake_intensity + shake.intensity end
    end

    -- Shake!
    self.camera:lookAt(self.x + math.prandom(-self.shake_intensity, self.shake_intensity), 
                       self.y + math.prandom(-self.shake_intensity, self.shake_intensity))
    -- Return camera to original position if not more shakes are needed
    if self.shake_intensity == 0 then self.camera:lookAt(self.x, self.y) end
end
