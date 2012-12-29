Accelerometer = Sprite:extend {
    
    visible = false,

    x = 0, 
    y = 0,
    z = 0,


    new = function (self, obj)
        obj = self:extend(obj)
        the.accelerometer = obj

        MOAIInputMgr.device.level:setCallback(function(x,y,z) obj:updateAccelerometer(x,y,z) end)

        if obj.onNew then obj:onNew() end
        return obj
    end,


    updateAccelerometer = function (self,x,y,z)
        self.x = x
        self.y = y
        self.z = z
    end,


    getPitch = function(self)
        return math.atan2(self.x,math.sqrt(self.y^2 + self.z^2)) * 180/math.pi
    end,


    getRoll = function(self)
        return math.atan2(self.y,self.z) * 180/math.pi
    end,


    update = function() end


}
