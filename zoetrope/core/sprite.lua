 

 Sprite = Class:extend {
-- Property: active
	-- If false, the sprite will not receive an update-related events.
	active = true,

	-- Property: visible
	-- If false, the sprite will not draw itself onscreen.
	visible = true,

	-- Property: solid
	-- If false, the sprite will never be eligible to collide with another one.
	solid = true,

	-- Property: x
	-- Horizontal position in pixels. 0 is the left edge of the window.
	x = 0,

	-- Property: y
	-- Vertical position in pixels. 0 is the top edge of the window.
	y = 0,

	-- Property: width
	-- Width in pixels.

	-- Property: height
	-- Height in pixels.

	-- Property: rotation
	-- Rotation of drawn sprite in radians. This does not affect the bounds
	-- used during collision checking.
	rotation = 0,

	-- Property: velocity
	-- Motion either along the x or y axes, or rotation about its center, in
	-- pixels per second.
	velocity = { x = 0, y = 0, rotation = 0 },

	-- Property: minVelocity
	-- No matter what else may affect this sprite's velocity, it
	-- will never go below these numbers.
	minVelocity = { x = - math.huge, y = - math.huge, rotation = - math.huge },

	-- Property: maxVelocity
	-- No matter what else may affect this sprite's velocity, it will
	-- never go above these numbers.
	maxVelocity = { x = math.huge, y = math.huge, rotation = math.huge },

	-- Property: acceleration
	-- Acceleration along the x or y axes, or rotation about its center, in
	-- pixels per second squared.
	acceleration = { x = 0, y = 0, rotation = 0 },

	-- Property: drag
	-- This property is only active when the related acceleration is 0. In those
	-- instances, it applies acceleration towards 0 for the given property. i.e.
	-- when the velocity is positive, it applies a negative acceleration.
	drag = { x = 0, y = 0, rotation = 0 },

	-- Property: scale
	-- This affects how the sprite is drawn onscreen. e.g. a sprite with scale 2 will
	-- display twice as big. Scaling is centered around the sprite's center. This has
	-- no effect on collision detection.
	scale = 1,

	-- Property: distort
	-- This allows you to scale a sprite in a distorted fashion by defining ratios
	-- between x and y scales.
	distort = { x = 1, y = 1 },

	-- Property: flipX
	-- If set to true, then the sprite will draw flipped horizontally.
	flipX = false,

	-- Property: flipY
	-- If set to true, then the sprite will draw flipped vertically.
	flipY = false,

	-- Property: alpha
	-- This affects the transparency at which the sprite is drawn onscreen. 1 is fully
	-- opaque; 0 is completely transparent.
	alpha = 1,

	-- Property: tint
	-- This tints the sprite a color onscreen. This goes in RGB order; each number affects
	-- how that particular channel is drawn. e.g. to draw the sprite in red only, set tint to
	-- { 1, 0, 0 }.
	tint = { 1, 1, 1 },

	-- Method: die
	-- Makes the sprite totally inert. It will not receive
	-- update events, draw anything, or be collided.
	--
	-- Arguments:
	--		none
	--
	-- Returns:
	-- 		nothing

	die = function(self) 
		self.active = false
		self.visible = false
		self.solid = false
		self._m_object:setVisible(false)
	end,

	revive = function(self)
		self.active = true
		sefl.visible = true
		self.solid = true
		self._m_object:setVisible(true)
	end,

	startFrame = function(self,elapsed)
		if self.onStartFrame then self:onStartFrame(elapsed) end
	end,


	update = function (self,elapsed)
		local vel = self.velocity
		local acc = self.acceleration
		local drag = self.drag
		local minVel = self.minVelocity
		local maxVel = self.maxVelocity

		-- check existence of properties

		if STRICT then
			assert(vel, 'active sprite has no velocity property')
			assert(acc, 'active sprite has no acceleration property')
			assert(drag, 'active sprite has no drag property')
			assert(minVel, 'active sprite has no minVelocity property')
			assert(maxVel, 'active sprite has no maxVelocity property')
		end

		vel.x = vel.x or 0
		vel.y = vel.y or 0
		vel.rotation = vel.rotation or 0

		-- physics
			
		if vel.x ~= 0 then self.x = self.x + vel.x * elapsed end
		if vel.y ~= 0 then self.y = self.y + vel.y * elapsed end
		if vel.rotation ~= 0 then self.rotation = self.rotation + vel.rotation * elapsed end
		
		if acc.x and acc.x ~= 0 then
			vel.x = vel.x + acc.x * elapsed
		else
			if drag.x then
				if vel.x > 0 then
					vel.x = vel.x - drag.x * elapsed
					if vel.x < 0 then vel.x = 0 end
				elseif vel.x < 0 then
					vel.x = vel.x + drag.x * elapsed
					if vel.x > 0 then vel.x = 0 end
				end
			end
		end
		
		if acc.y and acc.y ~= 0 then
			vel.y = vel.y + acc.y * elapsed
		else
			if drag.y then
				if vel.y > 0 then
					vel.y = vel.y - drag.y * elapsed
					if vel.y < 0 then vel.y = 0 end
				elseif vel.y < 0 then
					vel.y = vel.y + drag.y * elapsed
					if vel.y > 0 then vel.y = 0 end
				end
			end
		end
		
		if acc.rotation and acc.rotation ~= 0 then
			vel.rotation = vel.rotation + acc.rotation * elapsed
		else
			if drag.rotation then
				if vel.rotation > 0 then
					vel.rotation = vel.rotation - drag.rotation * elapsed
					if vel.rotation < 0 then vel.rotation = 0 end
				elseif vel.rotation < 0 then
					vel.rotation = vel.rotation + drag.rotation * elapsed
					if vel.rotation > 0 then vel.rotation = 0 end
				end
			end
		end

		if minVel.x and vel.x < minVel.x then vel.x = minVel.x end
		if maxVel.x and vel.x > maxVel.x then vel.x = maxVel.x end
		if minVel.y and vel.y < minVel.y then vel.y = minVel.y end
		if maxVel.y and vel.y > maxVel.y then vel.y = maxVel.y end
		if minVel.rotation and vel.rotation < minVel.rotation then vel.rotation = minVel.rotation end
		if maxVel.rotation and vel.rotation > maxVel.rotation then vel.rotation = maxVel.rotation end
		
		if self.onUpdate then self:onUpdate(elapsed) end
	end,

	endFrame = function(self,elapsed)
		if self.onEndFrame then self:onEndFrame(elapsed) end
	end,

	draw = function(self,x,y)
		if self.onDraw then self:onDraw(x,y) end
	end
 }