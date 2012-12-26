require 'zoetrope.init'

the.app = App:extend{
    onRun = function (self) 

        t = Text:new {
            onUpdate = function (self,dt)
                local g = 9.8
                
                if the.app:hasAccelerometer() then
                    if math.abs(the.accelerometer.z) < 0.5*g
                        and the.accelerometer.x > 0.5*g
                        and math.abs(the.accelerometer.y) < 0.4*g
                    then 
                        self.text = "Top"

                    elseif math.abs(the.accelerometer.z) < 0.5*g
                        and the.accelerometer.x < -0.5*g
                        and math.abs(the.accelerometer.y) < 0.4*g
                    then 
                        self.text = "Bottom"

                    elseif math.abs(the.accelerometer.z) < 0.5*g 
                        and the.accelerometer.y > 0.5*g 
                        and math.abs(the.accelerometer.x) < 0.4*g 
                    then 
                        self.text = "Right"

                    elseif math.abs(the.accelerometer.z) < 0.5*g 
                        and the.accelerometer.y < -0.5*g 
                        and math.abs(the.accelerometer.x) < 0.4*g 
                    then 
                        self.text = "Right"
                    end
                    --[[
                    if the.accelerometer:getPitch() > 45 and the.accelerometer:getRoll() < 35 then
                        self.text = "Landscape"
                    elseif the.accelerometer:getRoll() > 35 and math.abs(the.accelerometer:getPitch()) < 15 then
                        self.text = "Portrait"
                    end
                    --]]
                    --[[
                    self.text = "X: "..the.accelerometer.x.."\n"
                        .. "Y: "..the.accelerometer.y.."\n"
                        .. "Z: "..the.accelerometer.z
                    --]]
                    --self.text = "Pitch: "..the.accelerometer:getPitch().."\n"
                    --    .. "Roll: "..the.accelerometer:getRoll()
                else
                    self.text = "X: No accelerometer :(\n"
                        .. "Y: No accelerometer D:\n"
                        .. "Z: No accelerometer DD:"
                end

            end
        }

        self:add(t)

    end    

}

the.app:new()
the.app:run()