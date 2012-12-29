Tile = Sprite:extend {

	imageOffset = {x = 0, y = 0},


	-- private property: keeps track of properties that need action
	-- to be taken when they are changed
	-- image must be a nonsense value, not nil,
	-- for the tile to see that an image has been set if it
	-- was initially nil
	_set = { image = -1, imageOffset = { x = 0, y = 0 } },


	new = function (self, obj)
		obj = obj or {}
		obj = self:extend(obj)
		
		if obj.image then obj:updateQuad() end
		if obj.onNew then obj:onNew() end
		return obj
	end,


	updateQuad = function(self)
		if self.image then 
			
			local texture = MOAITexture.new()
			texture:load(self.image)
			local width,height = texture:getSize()

			if not self.width then self.width = width end 

			if not self.height then self.height = height end

			-- TODO: use Cached to optimize this; each individual spritesheet that is loaded
			-- should be a MOAIGfxQuadDeck2D (probably), then individual Sprite classes that USE
			-- them can add quads
			local spritesheet = MOAIGfxQuad2D.new()
			spritesheet:setTexture(self.image)
			spritesheet:setUVRect(
				self.imageOffset.x / width,
				self.imageOffset.y / height,
				(self.imageOffset.x+self.width) / width,
				(self.imageOffset.y+self.height) / height	
			)
			spritesheet:setRect(0,0,self.width,self.height)

			local prop
			if not self._m_object then 
				prop = MOAIProp2D.new()
			else
				prop = self._m_object
			end

			prop:setDeck(spritesheet)
			self._m_object = prop
			
			-- This sets up the translation node for this 
			-- tile. This makes it so that we can translate by the 
			-- top left corner of the sprite, while the sprite itself can
			-- be rotated by it's center. 
			self._m_translate = MOAITransform2D.new()
			--prop:setLoc(self.x,self.y)
			self._m_translate:setPiv(0,0)
			self._m_translate:setLoc(0,0)
			
			-- Parent the actual tile to the translation node
			-- then set our pivot to the center of the sprite (for rotation)
			-- We then have to offset our location within the translation node
			self._m_object:setParent(self._m_translate)
			self._m_object:setPiv(self.width/2,self.height/2)
			self._m_object:setLoc(self.width/2,self.height/2)

			self._set.image = self.image
			self._set.imageOffset = { x = self.imageOffset.x, y = self.imageOffset.y }

		end

	end,

	draw = function(self,x,y)
		if not self.visible or self.alpha <= 0 then return end

		x = math.floor(x or self.x)
		y = math.floor(y or self.y)

		if self.image and (self.image ~= self._set.image or
		   self.imageOffset.x ~= self._set.imageOffset.x or
		   self.imageOffset.y ~= self._set.imageOffset.y) then
			self:updateQuad()
		end

		if self.image then 
			self._m_translate:setLoc(x,y)
			-- MOAI does rotation in degrees, but we want to keep our mathy compatibility, 
			-- so we'll store rotation as rads, and convert to degrees before actual rotation
			-- make rotations be around center
			--self._m_object:setPiv(self.width/2,self.height/2)
			self._m_object:setRot(math.deg(self.rotation))
		end

	end,

	__tostring = function (self)
        local result = 'Tile (x: ' .. self.x .. ', y: ' .. self.y ..
                                   ', w: ' .. self.width .. ', h: ' .. self.height .. ', '

        result = result .. 'image \'' .. self.image .. '\', '

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