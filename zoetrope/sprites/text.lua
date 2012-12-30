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
	
	text = '',

	
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

	new = function(self,obj)
		obj=  obj or {}

		self:extend(obj)

		
		obj._m_textbox = MOAITextBox.new() 
		--obj._m_textbox:setFont()

		obj:updateFont()
		if obj.onNew then obj:onNew() end 

		return obj

	end,



	updateFont = function(self)

		-- Set up defaults
		self.font = Class.extend({
			size 		= 12,
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

		self._m_textbox:setRect(0,0,600,600)
		self._m_textbox:setString(self.text)

		self._m_object = self._m_textbox
	end,



	update = function (self,elapsed)
		if self.onUpdate then self:onUpdate(elapsed) end 

		--self:draw(self.x,self.y)

	end,

	draw = function (self,x,y)
		self._m_textbox:setString(tostring(self.text))
		self._m_textbox:setLoc(x,y)

		if self.onDraw then self:onDraw(x,y) end
	end



}