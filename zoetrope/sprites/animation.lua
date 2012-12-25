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

		if self.sequences[name] ~= self._set.sequences[name] then 
			self:buildSequence(name)
		end 

		self._m_sequences[name]:start()
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

		self._set.sequences[sequence] = seq
		self._m_sequences[sequence] = anim

	end


}