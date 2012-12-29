Fill = Sprite:extend
{
    
    -- Property: fill
    -- A table of color values in RGBA order. Each value should fall
    -- between 0 and 255. The fill sprite fills this color in its bounds
    -- onscreen.
    fill = { 255, 255, 255, 255 },

    -- Property: border
    -- A table of color values in RGBA order. Each value should fall
    -- between 0 and 255. The fill sprite draws the border in this color
    -- after filling in a color (if any).
    border = nil,


    new = function(self,obj) 
        obj = obj or {}
        obj = self:extend(obj)
        


        obj._m_deck = MOAIScriptDeck.new()
        obj._m_deck:setRect(0, 0, obj.width, obj.height)
        obj._m_deck:setDrawCallback(
            function()
                obj:_draw()
            end
        )

        obj._m_translate = MOAITransform2D.new()
        --prop:setLoc(obj.x,obj.y)
        obj._m_translate:setPiv(0,0)
        obj._m_translate:setLoc(0,0)

        obj._m_object = MOAIProp2D.new()
        obj._m_object:setDeck(obj._m_deck)

        -- Parent the actual tile to the translation node
        -- then set our pivot to the center of the sprite (for rotation)
        -- We then have to offset our location within the translation node
        obj._m_object:setParent(obj._m_translate)
        
        
        if obj.onNew then obj:onNew() end
        return obj
    end,


    _draw = function(self)
        
        if self.fill then 
            local fillAlpha = self.fill[4] or 255
            --print(fillAlpha*self.alpha)
            local alpha = math.min((fillAlpha*self.alpha)/255,1)

            MOAIGfxDevice.setPenColor(
                math.min((self.fill[1] * self.tint[1])/255, 1)*alpha,
                math.min((self.fill[2] * self.tint[2])/255, 1)*alpha,
                math.min((self.fill[3] * self.tint[3])/255, 1)*alpha,
                1
            )
            MOAIDraw.fillRect(0, 0, self.width, self.height)
        end

        if self.border then 
            local borderAlpha = self.border[4] or 255
            local alpha = math.min((borderAlpha*self.alpha)/255,1)


            MOAIGfxDevice.setPenColor(
                math.min((self.border[1] * self.tint[1])/255, 1)*alpha,
                math.min((self.border[2] * self.tint[2])/255, 1)*alpha,
                math.min((self.border[3] * self.tint[3])/255, 1)*alpha,
                1
            )
            MOAIDraw.drawRect(0, 0, self.width, self.height)
        end

        self._m_object:setPiv(self.width/2,self.height/2)
        self._m_object:setLoc(self.width/2,self.height/2)

    end,


    update = function(self,dt)
        Sprite.update(self,dt)
    end,


    draw = function(self, x, y)
        x = math.floor(x or self.x)
        y = math.floor(y or self.y)

        if not self.visible or self.alpha <= 0 then return end

        self._m_translate:setLoc(x, y)

        local scaleX = self.scale * self.distort.x
        local scaleY = self.scale * self.distort.y
        self._m_translate:setScl(scaleX, scaleY)
        -- MOAI does rotation in degrees, but we want to keep our mathy compatibility, 
        -- so we'll store rotation as rads, and convert to degrees before actual rotation
        -- make rotations be around center
        --self._m_object:setPiv(self.width/2,self.height/2)
        self._m_object:setRot(math.deg(self.rotation))
    end,




    __tostring = function (self)
        local result = 'Fill (x: ' .. self.x .. ', y: ' .. self.y ..
                       ', w: ' .. self.width .. ', h: ' .. self.height .. ', '

        if self.fill then
            result = result .. 'fill {' .. table.concat(self.fill, ', ') .. '}, '
        else
            result = result .. 'no fill, '
        end

        if self.border then
            result = result .. 'border {' .. table.concat(self.border, ', ') .. '}, '
        else
            result = result .. 'no border, '
        end

        if self.active then
            result = result .. 'active, '
        else
            result = result .. 'inactive, '
        end

        if self.visible then
            result = result .. 'visible, '
        else
            result = result .. 'invisible, '
        end

        if self.solid then
            result = result .. 'solid'
        else
            result = result .. 'not solid'
        end

        return result .. ')'
    end


}