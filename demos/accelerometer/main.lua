require 'zoetrope.init'

the.app = App:extend{
    onRun = function (self) 
 
        t = Text:new {
            onUpdate = function (self,dt)
                local g = 9.8
                --[[ 
                if the.app:hasAccelerometer() then
                    self.text = "X: "..the.accelerometer.x.."\n"
                        .. "Y: "..the.accelerometer.y.."\n"
                        .. "Z: "..the.accelerometer.z
                else
                    self.text = "X: No accelerometer :(\n"
                        .. "Y: No accelerometer D:\n"
                        .. "Z: No accelerometer DD:"
                end
                --]]
                self.text = the.app:isMobile()
            end
        }

        self:add(t)

    end    

}

the.app:new()
the.app:run()