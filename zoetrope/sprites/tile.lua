Tile = Sprite:extend {

	imageOffset = {x = 0, y = 0},

	new = function (self, obj)
		obj = obj or {}
		self:extend(obj)
		
		if obj.image then obj:updateQuad() end
		if obj.onNew then obj:onNew() end
		return obj
	end,


	updateQuad = function(self)
		if self.image then 
			
			texture = MOAITexture.new()
			texture:load(self.image)
			local width,height = texture:getSize()

			if not self.width then self.width = width end 

			if not self.height then self.height = height end

			-- TODO: use Cached to optimize this; each individual spritesheet that is loaded
			-- should be a MOAIGfxQuadDeck2D (probably), then individual Sprite classes that USE
			-- them can add quads
			spritesheet = MOAIGfxQuad2D.new()
			spritesheet:setTexture(self.image)
			spritesheet:setUVRect(
				self.imageOffset.x / width,
				self.imageOffset.y / height,
				(self.imageOffset.x+self.width) / width,
				(self.imageOffset.y+self.height) / height	
			)
			spritesheet:setRect(0,0,self.width,self.height)
			
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

		end

	end,

	draw = function(self,x,y)
		
		self._m_translate:setLoc(x,y)
		-- MOAI does rotation in degrees, but we want to keep our mathy compatibility, 
		-- so we'll store rotation as rads, and convert to degrees before actual rotation
		-- make rotations be around center
		--self._m_object:setPiv(self.width/2,self.height/2)
		self._m_object:setRot(math.deg(self.rotation))

		--self._m_object:setPiv(0,0)
	end
}