

Group = Class:extend {
	
	active = true,

	visible = true,

	solid = true,

	translate = {x = 0, y = 0},

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
	end,


	update = function(self, elapsed) 

		if not self.active then return end 

		elapsed = elapsed * self.timeScale

		if self.onUpdate then self:onUpdate(elapsed) end 

		for _,spr in pairs(self.sprites) do 
			--if spr.active then spr:update(elapsed) end
			spr:update(elapsed)
		end


	end

	
}