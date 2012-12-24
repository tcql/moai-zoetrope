

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


	add = function (self, sprite)

		table.insert(self.sprites,sprite)

		-- todo: fix this...
		self._m_layer:insertProp(sprite._m_object)

		--[[
		if sprite:instanceOf(Group) then 
			sprite._m_object:setViewport(the.view._m_viewport)
		end
		--]]
		MOAIRenderMgr.pushRenderPass(sprite._m_object)
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

	
	
	
}