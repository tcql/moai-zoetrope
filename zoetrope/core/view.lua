

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
		MOAIRenderMgr.pushRenderPass(obj._m_layer)
		
		return obj
	end,


	add = function (self,sprite)

		self:_recurseGroups(sprite)

		Group.add(self,sprite)

	end,


	-- Utility method for ensuring any groups or subgroups that have been added to us
	-- have their viewport set to our viewport. This feels kind of hackish
	_recurseGroups = function (self,group)
		if group:instanceOf(Group) then 
			for _,spr in pairs(group.sprites) do 
				self:_recurseGroups(spr)
			end
			group._m_layer:setViewport(self._m_viewport)
		end
	end



}