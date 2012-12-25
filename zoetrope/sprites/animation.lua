Animation = Sprite:extend 
{
	-- Property: paused
	-- Set this to true to freeze the animation on the current frame.
	paused = false,

	-- Property: sequences
	-- A lookup table of sequences. Each one is stored by name and has
	-- the following properties:
	-- * name - string name for the sequence.
	-- * frames - table of frames to display. The first frame in the sheet is at index 1.
	-- * fps - frames per second.
	-- * loops - does the animation loop? defaults to true
	sequences = {},

	-- Property: image
	-- A string filename to the image to use as a sprite strip. A sprite
	-- strip can have multiple rows of frames.

	-- Property: currentSequence
	-- A reference to the current animation sequence table.

	-- Property: currentName
	-- The name of the current animation sequence.

	-- Property: currentFrame
	-- The current frame being displayed; starts at 1.

	-- Property: frameIndex
	-- Numeric index of the current frame in the current sequence; starts at 1.

	-- Property: frameTimer
	-- Time left before the animation changes to the next frame in seconds.
	-- Normally you shouldn't need to change this directly.

	-- private property: used to check whether the source image
	-- for our quad is up-to-date
	_set = { sequences = {} },

	_m_sequences = {},

	-- private property imageObj: actual Image instance used to draw
	-- this is normally set via the image property, but you may set it directly
	-- so long as you never change that image property afterwards.


	new = function (self,obj)
		obj = obj or {}
		self:extend(obj)
		obj:updateQuad()

		if obj.onNew then obj:onNew() end 
		return obj
	end,


	updateQuad = function (self)
		if self.image then 
			local texture = MOAITexture.new()
			texture:load(self.image)
			local width,height = texture:getSize()

			-- Yes, we intentionally set width to = height.
			if not self.width then self.width = height end 
			if not self.height then self.height = height end


			local deck = MOAITileDeck2D.new ()
			deck:setTexture(texture)
			deck:setRect(0,0,self.width,self.height)
			-- Sets how many quads there are
			deck:setSize(math.floor(width/self.width),math.floor(height/self.height))


			self._m_object = MOAIProp2D.new()
			self._m_object:setDeck(deck)

			self._set.image = self.image
		end
	end,


	play = function(self,name)
		if self.currentName == name and not self.paused then 
			return 
		end

		assert(self.sequences[name], 'no animation sequence named "' .. name .. '"')

		if self.sequences[name].loops == nil then 
			self.sequences[name].loops = true 
		end

		if self.sequences[name] ~= self._set.sequences[name] then 
			self:buildSequence(name)
		end 
		self.currentSequence = name
		self._m_sequences[name]:start()
		self.paused = false
	end,



	freeze = function(self,index)
		if self.currentSequence then 
			self._m_sequences[self.currentSequence]:stop()
		end

		if self._set.image ~= self.image then
			self:updateQuad()
		end

		if index then 
			self._m_object:setIndex(index)
		end

		self.paused = true
	end,



	-- private method: buildSequence 
	-- builds the necessary structure for a MOAIAnim
	buildSequence = function(self,sequence)
		local seq = self.sequences[sequence]

		local curve = MOAIAnimCurve.new()

		curve:reserveKeys(#seq.frames)
		local time = 0
		local step = 1/seq.fps

		
		for ind,frame in ipairs(seq.frames) do 
			curve:setKey(ind, time, frame, MOAIEaseType.FLAT)
			time = time+step
		end

		local anim = MOAIAnim:new()
		anim:reserveLinks(1)
		-- Link our animation curve to the prop's index property
		anim:setLink(1, curve, self._m_object, MOAIProp2D.ATTR_INDEX)

		if seq.loops then 
			anim:setMode(MOAITimer.LOOP)
		end

		-- Set up the onEndSequence listener for when this sequence is done playing
		local onStop = function () 
			self.paused = true
			if self.onEndSequence then self:onEndSequence(sequence) end
		end

		anim:setListener ( MOAIAction.EVENT_STOP, onStop )

		self._set.sequences[sequence] = seq
		self._m_sequences[sequence] = anim

	end,

	draw = function(self,x,y)
		x = math.floor(x or self.x)
		y = math.floor(y or self.y)

		if STRICT then
			assert(type(x) == 'number', 'visible animation does not have a numeric x property')
			assert(type(y) == 'number', 'visible animation does not have a numeric y property')
			assert(type(self.width) == 'number', 'visible animation does not have a numeric width property')
			assert(type(self.height) == 'number', 'visible animation does not have a numeric height property')
		end

		if not self.visible or not self.image or self.alpha <= 0 then return end
		
		-- if our image changed, update the quad
		
		if self._set.image ~= self.image then
			self:updateQuad()
		end
		

		-- draw the quad

		local scaleX = self.scale * self.distort.x
		local scaleY = self.scale * self.distort.y

		if self.flipX then scaleX = scaleX * -1 end
		if self.flipY then scaleY = scaleY * -1 end
			
		self._m_object:setLoc(x,y)
		
		Sprite.draw(self, x, y)

	end


}