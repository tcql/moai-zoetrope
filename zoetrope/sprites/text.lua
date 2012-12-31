Text = Sprite:extend {
	FONT_BITMAP = 0x01,
	FONT_TTF 	= 0x02,
	--[[
	-- New Font property setup...
	-- MOAI fonts can be customized quite a bit, 
	-- so exposing a bit more seems like a good idea
	font = {
		source_type 	=
		size 			= 12,
		glyphs 			= '',
		color_format 	= '',
		source 			= n,
	},
	--]]

	wordBreak = false,
	
	text = '',

	-- options are 'top', 'center' or 'bottom'
	verticalAlign = 'top',
	-- options are 'left', 'center' or 'right'
	horizontalAlign = 'left',

	-- Property: font
	-- Font to use to draw. See <Cached.font> for possible values here; if
	-- you need more than one value, use table notation. Some example values:
	-- 		* 12 (default font, size 12)
	--		* 'fonts/bitmapfont.png' (bitmap font, default character order)
	--		* { 'fonts/outlinefont.ttf', 12 } (outline font, font size)
	--		* { 'fonts/bitmapfont.ttf', 'ABCDEF' } (bitmap font, custom character order)
	--font = 12,
	font = {},

	x = 0,
	y = 0,

	width = 50,
	height = 50,


	_set = {},

	new = function(self,obj)
		obj=  obj or {}

		self:extend(obj)



		-- Setup the translation node for this sprite
		-- TODO: generalize? all sprites could use a Transform2D node
		-- with their actual object parented under it?
		obj._m_translate = MOAITransform2D.new()
        obj._m_translate:setPiv(0,0)
        obj._m_translate:setLoc(0,0)
		
		-- Rotation on textboxes themselves seems to cause some weird trouble. 
		-- not really sure WHY... but whatever
        obj._m_rotation = MOAITransform2D.new()
        obj._m_rotation:setPiv(self.width/2, self.height/2)
        obj._m_rotation:setLoc(self.width/2, self.height/2)
        obj._m_rotation:setParent(obj._m_translate)

		obj._m_textbox = MOAITextBox.new() 
		obj._m_textbox:setParent(obj._m_rotation)


		obj:updateFont()
		if obj.onNew then obj:onNew() end 

		return obj

	end,



	updateFont = function(self)

		-- Set up defaults
		self.font = Class.extend({
			size 		= 18,
			source_type = Text.FONT_TTF,
			-- MOAI doesn't seem to have any setup for 
			-- a default system font, so I've found a freely
			-- licensed Sans-Serif TTF font that looks 
			-- decent
			source 		= ZOE_PATH.."/Roboto-Regular.ttf"
		},self.font)


		local fonttype
		if self.font.source_type == Text.FONT_BITMAP then
			fonttype = true 
		else 
			fonttype = false
		end

		self._m_font = Cached:font(fonttype,self.font)

		self._m_textbox:setFont(self._m_font)
		self._m_textbox:setTextSize(self.font.size)

		self._m_textbox:setRect(0,0,self.width,self.height)
		self._m_textbox:setString(self.text)

		self._m_object = self._m_textbox
	end,

	-- Method: centerAround
	-- Centers the text around a position onscreen.
	--
	-- Arguments:
	--		x - center's x coordinate
	--		y - center's y coordinate
	--		centering - can be either 'horizontal', 'vertical', or 'both';
	--					default 'both'
	
	centerAround = function (self, x, y, centering)
		centering = centering or 'both'
		local width, height = self.width, self.height

		if width == 0 then return end

		if centering == 'both' or centering == 'horizontal' then
			self.x = x - width / 2
		end

		if centering == 'both' or centering == 'vertical' then
			self.y = y - height / 2
		end
	end,


	setAlignment = function(self)
		if self.horizontalAlign ~= self._set.horizontalAlign or 
			self.verticalAlign ~= self._set.verticalAlign
		then

			local aligns = {
				top	 	= MOAITextBox.LEFT_JUSTIFY,
				left 	= MOAITextBox.LEFT_JUSTIFY,
				center 	= MOAITextBox.CENTER_JUSTIFY,
				bottom  = MOAITextBox.RIGHT_JUSTIFY,
				right 	= MOAITextBox.RIGHT_JUSTIFY
			}

			self.horizontalAlign 	= aligns[self.horizontalAlign] or aligns.left 
			self.verticalAlign 	= aligns[self.verticalAlign] or aligns.top

			self._m_textbox:setAlignment(self.horizontalAlign,self.verticalAlign)

			self._set.horizontalAlign 	= self.horizontalAlign
			self._set.verticalAlign 	= self.verticalAlign

		end
	end,


	setBreakAndWrap = function (self)
		if self.wordBreak ~= self._set.wordBreak then

			if self.wordBreak then 
				self._m_textbox:setWordBreak(MOAITextBox.WORD_BREAK_CHAR)
			else 
				self._m_textbox:setWordBreak(MOAITextBox.WORD_BREAK_NONE)
			end

			self._set.wordBreak = self.wordBreak
		end
	end,


	draw = function (self,x,y)
		if not self.visible or self.alpha <= 0 or not self.text or not self.font then return end

		x = math.floor(x or self.x)
		y = math.floor(y or self.y)


		-- update the text
		self._m_textbox:setString(tostring(self.text))

		-- update the location
		self._m_translate:setLoc(x,y)


		-- Ensure that we are pivoting around the correct location.
		-- This only matters if we have changed width/height since last 
		-- draw
		self._m_rotation:setPiv(self.width/2,self.height/2)
        self._m_rotation:setLoc(self.width/2,self.height/2)

        self._m_rotation:setRot(math.deg(self.rotation))

        local scaleX = self.scale * self.distort.x
		local scaleY = self.scale * self.distort.y

		if self.flipX then scaleX = scaleX * -1 end
		if self.flipY then scaleY = scaleY * -1 end

		self._m_object:setPiv(self.width/2,self.height/2)
        self._m_object:setLoc(self.width/2,self.height/2)


		self._m_object:setScl(scaleX,scaleY)



		self:setAlignment()
		self:setBreakAndWrap()


		if self.onDraw then self:onDraw(x,y) end
	end



}