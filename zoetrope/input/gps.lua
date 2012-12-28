GPS = Sprite:extend {
    visible = false,

    lat = 0,
    lng = 0,

    altitude = 0,

    speed = 0,

    altitude_accuracy = 0,

    speed_accuracy = 0,

    _stats = {alt_readings = 0, alt_avg = 0, speed_avg = 0, speed_readings = 0},


    average_altitude = 0,

    average_speed = 0,

    -- Property: continuous
    -- A boolean whether or not the GPS class should poll for updates 
    -- on every tick. If false, you must call the.gps:takeReading() manually
    -- to update with the latest GPS data
    continuous = false,


    collectSpeedAverage = false,

    collectAltitudeAverage = false,


    new = function(self,obj)
        obj = self:extend(obj)
        the.gps = obj

        if obj.onNew then obj:onNew() end
        return obj
    end,


    takeReading = function(self)

        local lat,lng,hacc,alt,vacc,speed = MOAIInputMgr.device.location:getLocation()

        self.lat = lat
        self.lng = lng 

        self.altitude = alt 
        self.speed = speed 
        
        if self.collectAltitudeAverage and alt ~= 0 and alt then 
            
            self._stats.alt_avg = (self._stats.alt_avg * self._stats.alt_readings + alt) / (self._stats.alt_readings+1)
            self.average_altitude = self._stats.alt_avg

            self._stats.alt_readings = self._stats.alt_readings+1
        end

        if self.collectSpeedAverage and speed ~= 0 and speed then 
                
            self._stats.speed_avg = (self._stats.speed_avg * self._stats.speed_readings + speed) / (self._stats.speed_readings+1)
            self.average_speed = self._stats.speed_avg

            self._stats.speed_readings = self._stats.speed_readings+1
        end
    end,



    update = function() end,


    endFrame = function(self,dt) 

        if self.continuous then 
            self:takeReading()
        end

        Sprite.endFrame(self,dt)
    end 



}