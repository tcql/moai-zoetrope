
require 'zoetrope.init'

the.app = App:extend {
	onNew = function(self)
		t = Tile:new {
			imageOffset = {x=32,y = 0},
			
			image = 'image.axd.png',
			width = 32,
			height = 32,
			
			acceleration = { rotation = 2},
			maxVelocity = {rotation = 15},

		}

	end

}



the.app:new()

the.app:run()