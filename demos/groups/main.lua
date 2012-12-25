
require 'zoetrope.init'


local time = 0
local time2 = 0

the.app = App:extend {

	onNew = function (self) 

		group = Group:new()

		group:add(
			Tile:new 
			{
				y = 30,
				x = 20,
				image = 'logo.png'
			}
		)

		group:add(
			Text:new 
			{
				y = 100,
				x = 28,
				text = "Hello!"
			}
		)

		self:add(group)
	end
}



the.app:new()

the.app:run()