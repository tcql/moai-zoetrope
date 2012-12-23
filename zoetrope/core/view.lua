

View = Group:extend{
	

	new = function (self, obj)
		obj = Group.new(self,obj)

		viewport = MOAIViewport.new()
		viewport:setSize(the.app.width,the.app.height)
		viewport:setScale(the.app.width,-the.app.height)
		viewport:setOffset(-1,1)
		--viewport:setOffset(-the.app.width/2,the.app.height/2)

		obj._m_viewport = viewport

		obj._m_layer:setViewport(obj._m_viewport)
		MOAISim.pushRenderPass(obj._m_layer)
		--obj._m_viewport:setOffset(-0.5,-0.5)
		return obj
	end,


	add = function (self,sprite)

		if sprite.instanceOf and sprite:instanceOf(Group) then
			sprite._m_layer:setViewport(self._m_viewport)
			--MOAIRenderMgr.pushRenderPass(sprite._m_object)
		else 

			MOAISim.pushRenderPass(sprite._m_object)
		end


		Group.add(self,sprite)


		--MOAISim.pushRenderPass(sprite._m_object)

	end,

	update = function(self,elapsed)

		Group.update(self,elapsed)
	end



}