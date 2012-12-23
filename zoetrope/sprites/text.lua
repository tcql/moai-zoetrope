Text = Sprite:extend {
	
	text = '',

	font = 12,

	x = 0,
	y = 0,

	new = function(self,obj)
		obj=  obj or {}

		self:extend(obj)

		obj._m_font = MOAIFont.new()
		obj._m_textbox = MOAITextBox.new() 
		--obj._m_textbox:setFont()

		obj:updateFont()
		if obj.onNew then obj:onNew() end 

		return obj

	end,



	updateFont = function(self)


		charcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890 .,:;!?()&/-'

		bitmapFontReader = MOAIBitmapFontReader.new ()
		bitmapFontReader:loadPage ( 'FontVerdana18.png', charcodes, 16 )
		self._m_font:setReader ( bitmapFontReader )

		glyphCache = MOAIGlyphCache.new ()
		glyphCache:setColorFormat ( MOAIImage.COLOR_FMT_RGBA_8888 )
		self._m_font:setCache ( glyphCache )

		--self._m_font:load('comic.ttf')

		self._m_textbox:setFont(self._m_font)
		self._m_textbox:setTextSize(16)
		--self._m_textbox:setTextSize(12,72)
		--self._m_textbox:setYFlip(true)
		self._m_textbox:setRect(0,0,500,20)

		self._m_textbox:setString(self.text)

		self._m_object = self._m_textbox
	end,



	update = function (self,elapsed)
		if self.onUpdate then self:onUpdate(elapsed) end 

		self:draw(self.x,self.y)

	end,

	draw = function (self,x,y)
		self._m_textbox:setString(tostring(self.text))
		self._m_textbox:setLoc(x,y)

		if self.onDraw then self:onDraw(x,y) end
	end



}