Touch = Sprite:extend 
{
    visible = false,

    x = 0,
    y = 0,

    -- private property: _thisFrame
    -- used for tracking which touch ids are active this frame
    _thisFrame = {},

    -- private property: _lastFrame
    -- used for tracking which touch ids were active last frame
    _lastFrame = {},

    -- private property: _touches
    -- tracks active touch locations
    _touches = {},


    new = function (self,obj)
        obj = self:extend(obj)
        the.touch = obj

        
        MOAIInputMgr.device.touch:setCallback (
            function (eventType, touch_id, x, y, tap_count)
                touch_id = tostring(touch_id)

                if eventType == MOAITouchSensor.TOUCH_DOWN then
                    obj:touchPressed(touch_id,x,y,tap_count)
                elseif eventType == MOAITouchSensor.TOUCH_UP then 
                    obj:touchReleased(touch_id)
                elseif eventType == MOAITouchSensor.TOUCH_MOVE then
                    obj:touchMoved(touch_id,x,y)
                end
               
            end
        )


        if obj.onNew then obj:onNew() end
        return obj
    end,


    touchPressed = function(self,touch_id, tap_x, tap_y, taps)
        self._thisFrame[touch_id] = true
        self._touches[touch_id] = {
            x = tap_x,
            y = tap_y,
            tap_count = taps
        }
    end,


    touchReleased = function(self,touch_id)
        self._thisFrame[touch_id] = false
        self._touches[touch_id] = nil
    end,


    touchMoved = function(self, touch_id, tap_x, tap_y)
        self._touches[touch_id] = { 
            x = tap_x,
            y = tap_y,
            tap_count = 0 
        }
    end,


    pressed = function (self, ...)
        local touches = {...}

        if #touches == 0 then 
            touches = {}
            for key,_ in pairs(self._touches) do
                table.insert(touches,key)
            end
        end
    
        for _, value in pairs(touches) do
            if self._thisFrame[value] then
                return true
            end
        end
        
        return false
    end,


    justPressed = function(self, ...)
        local touches = {...}

        if #touches == 0 then 
            touches = {}
            for key,_ in pairs(self._touches) do
                table.insert(touches,key)
            end
        end

        for _, value in pairs(touches) do
            if self._thisFrame[value] and not self._lastFrame[value] then
                return true
            end
        end
        
        return false
    end,


    justReleased = function(self, ...)
        local touches = {...}

        if #touches == 0 then 
            touches = {}
            for key,_ in pairs(self._lastFrame) do
                table.insert(touches,key)
            end
        end

        for _, value in pairs(touches) do
            if self._lastFrame[value] and not self._thisFrame[value] then
                return true
            end
        end
        
        return false
    end,

    -- returns a table of data about which touch events
    -- are new on this frame. The table is keyed by touch ID
    -- and contains a table for each touch ID, describing it's current
    -- x, y, and tap_count (if it was double+ tapped)
    allJustPressed = function(self)
        local result = {}

        for key,value in pairs(self._thisFrame) do
            if value and not self._lastFrame[value] then 
                table.insert(result,key)
            end 
        end

        return result
    end,


    allPressed = function (self)
        local result = {}

        for key,value in pairs(self._thisFrame) do
            if value then 
                table.insert(result,key)
            end 
        end

        return result
    end,

    -- returns a table of which touch events were just released this frame.
    -- The table's values are touch_ids that are no longer active
    allJustReleased = function(self)
        local result = {}

        for key,value in pairs(self._lastFrame) do
            if self._lastFrame[key] and not self._thisFrame[key] then 
                table.insert(result,key)
            end
        end

        return result
    end,


    getEvent = function(self,id) 
        if type(id) ~= "table" then 
            id = {id}
        end

        local result = {}
        for _,value in pairs(id) do
            assert(self._touches[value] ~= nil, "Attemped to retrieve a touch event that doesn't exist")
            result[value] = self._touches[value]
        end

        return result
    end,

    endFrame = function(self)
        for key, value in pairs(self._thisFrame) do
            self._lastFrame[key] = value
        end

        Sprite.endFrame(self)
    end,


    update = function() end

}