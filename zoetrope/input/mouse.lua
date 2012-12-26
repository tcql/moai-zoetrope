Mouse = Sprite:extend
{
	visible = false,

	_thisFrame = {},

	_lastFrame = {},

		
	new = function (self, obj)
		obj = self:extend(obj)
		the.mouse = obj
		
		local callmouse = function(btn,down)
			if down then 
				obj:mousePressed(btn)
			else
				obj:mouseReleased(btn)
			end
		end

		MOAIInputMgr.device.mouseLeft:setCallback(function(down) callmouse('l',down) end)
		MOAIInputMgr.device.mouseMiddle:setCallback(function(down) callmouse('m',down) end)
		MOAIInputMgr.device.mouseRight:setCallback(function(down) callmouse('r',down) end)

		if obj.onNew then obj:onNew() end
		return obj
	end,


	mousePressed = function(self,button)
		self._thisFrame[button] = true
	end,

	mouseReleased = function(self,button)
		self._thisFrame[button] = false
	end,


	pressed = function (self, ...)
		local buttons = {...}

		if #buttons == 0 then buttons[1] = 'l' end
	
		for _, value in pairs(buttons) do
			if STRICT then
				assert(type(value) == 'string', 'all mouse buttons are strings; asked to check a ' .. type(value))
			end

			if self._thisFrame[value] then
				return true
			end
		end
		
		return false
	end,


	justPressed = function(self, ...)
		local buttons = {...}

		if #buttons == 0 then buttons[1] = 'l' end
	
		for _, value in pairs(buttons) do
			if STRICT then
				assert(type(value) == 'string', 'all mouse buttons are strings; asked to check a ' .. type(value))
			end

			if self._thisFrame[value] and not self._lastFrame[value] then
				return true
			end
		end
		
		return false
	end,


	endFrame = function(self)
		for key, value in pairs(self._thisFrame) do
			self._lastFrame[key] = value
		end

		self.x, self.y = the.view._m_object:wndToWorld ( MOAIInputMgr.device.pointer:getLoc () )

		Sprite.endFrame(self)
	end,


	update = function() end
}