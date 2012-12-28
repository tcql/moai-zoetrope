require 'zoetrope.init'


the.app = App:extend {
    onRun = function(self)
        if the.gps then 
            the.gps.continuous = true
            the.gps.collectAltitudeAverage = true
        end

        local text = Text:new {

            onUpdate = function(self,dt)
                if the.app:hasGPS() then
                    self.text = "Lat: "..the.gps.lat.."\n"
                        .."Lng: "..the.gps.lng.."\n"
                        .."Alt: "..the.gps.altitude.."\n"
                        .."Spd: "..the.gps.speed.."\n"
                        .."Readings: "..the.gps._stats.alt_readings.."\n"
                        .."Avg Alt: "..the.gps.average_altitude
                else
                    self.text = "No GPS"
                end
            end
        }

        self:add(text)
    end,
}

the.app:new()
the.app:run()