-- Class: Group
-- A group is a set of sprites. Groups can be used to
-- implement layers or keep categories of sprites together.
--
-- Extends:
--              <Class>
--
-- Event: onDraw
-- Called after all member sprites are drawn onscreen.
--
-- Event: onUpdate
-- Called once each frame, with the elapsed time since the last frame in seconds.
--
-- Event: onBeginFrame
-- Called once each frame like onUpdate, but guaranteed to fire before any others' onUpdate handlers.
--
-- Event: onEndFrame
-- Called once each frame like onUpdate, but guaranteed to fire after all others' onUpdate handlers.


Group = Class:extend {
	
	active = true,

	visible = true,

	solid = true,

	translate = { x = 0, y = 0 },

	translateScale = { x = 1, y = 1},


	sprites = {},
	

	timeScale = 1,


	new = function(self,obj)

		obj = Class.new(self,obj)

		obj._m_layer = MOAILayer2D.new()

		obj._m_object = obj._m_layer


		return obj
	end,

	
	-- Method: add
    -- Adds a sprite to the group.
    --
    -- Arguments:
    --              sprite - <Sprite> to add
    --
    -- Returns:
    --              nothing

	add = function (self, sprite)

		table.insert(self.sprites,sprite)

		-- todo: fix this...
		if sprite._m_object then 
			self._m_layer:insertProp(sprite._m_object)

			--[[
			if sprite:instanceOf(Group) then 
				sprite._m_object:setViewport(the.view._m_viewport)
			end
			--]]

			-- TODO: figure out why this line is REALLY screwy.
			-- It seems to be necessary when dealing with nested groups (?)
			-- but completely breaks things when not.
			-- With it removed, the timescales demo is broken,
			-- with it added in, the touch demo doesn't work correctly, because 
			-- things aren't :remove()'d  correctly
			--MOAIRenderMgr.pushRenderPass(sprite._m_object)
		end
	end,


    -- Method: remove
    -- Removes a sprite from the group. If the sprite is
    -- not in the group, this does nothing.
    -- 
    -- Arguments:
    --              sprite - <Sprite> to remove
    -- 
    -- Returns:
    --              nothing

	remove = function(self,sprite)
		for i, spr in ipairs(self.sprites) do
            if spr == sprite then
                table.remove(self.sprites, i)

                -- moai code to stop visibly rendering 
                -- the sprite on this layer
                if sprite._m_object then
	                self._m_layer:removeProp(sprite._m_object)
	            end
                return
            end
        end
        
        if STRICT then
            local info = debug.getinfo(2, 'Sl')
            print('Warning: asked to remove a sprite from a group it was not a member of (' ..
                      info.short_src .. ' line ' .. info.currentline .. ')')
        end
	end,


	startFrame = function (self,elapsed) 
		if not self.active then return end 
		elapsed = elapsed*self.timeScale 
		if self.onStartFrame then self:onStartFrame(elapsed) end 

		for _, spr in pairs(self.sprites) do
			if spr.active then spr:startFrame(elapsed) end
		end


	end,


	update = function(self, elapsed) 

		if not self.active then return end 
		elapsed = elapsed * self.timeScale
		if self.onUpdate then self:onUpdate(elapsed) end 

		for _,spr in pairs(self.sprites) do 
			if spr.active then spr:update(elapsed) end
			
		end

	end,


	endFrame = function(self,elapsed)
		if not self.active then return end
		elapsed = elapsed * self.timeScale
		if self.onEndFrame then self:onEndFrame(elapsed) end

		for _, spr in pairs(self.sprites) do
			if spr.active then spr:endFrame(elapsed) end
		end
	end,


	draw = function(self,x,y) 
		x = x or self.translate.x
		y = y or self.translate.y

		local scrollX = x*self.translateScale.x
		local scrollY = y*self.translateScale.y
		local appWidth = the.app.width
		local appHeight = the.app.height


		if not self.active then return end
		
		for _, spr in pairs(self.sprites) do	
			if spr.visible then
				if spr.translate then
					spr:draw(spr.translate.x + scrollX, spr.translate.y + scrollY)
				elseif spr.x and spr.y and spr.width and spr.height then
					local sprX = spr.x + scrollX
					local sprY = spr.y + scrollY

					if sprX < appWidth and sprX + spr.width > 0 and
					   sprY < appHeight and sprY + spr.height > 0 then
						spr:draw(sprX, sprY)
					end
				else
					spr:draw(scrollX, scrollY)
				end
			end
		end

		if self.onDraw then self:onDraw() end

		
	end,

	


    __tostring = function (self)
        local result = 'Group ('

        if self.active then
                result = result .. 'active'
        else
                result = result .. 'inactive'
        end

        if self.visible then
                result = result .. ', visible'
        else
                result = result .. ', invisible'
        end

        if self.solid then
                result = result .. ', solid'
        else
                result = result .. ', not solid'
        end

        return result .. ', ' .. self:count(true) .. ' sprites)'
    end
	
	
}