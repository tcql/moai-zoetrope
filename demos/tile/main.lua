
require 'zoetrope.init'

the.app = App:extend {
	onNew = function(self)
		local tile_vel = 40

		zoetile = Tile:extend
		{
			image = 'logo.png',
			width = 32, height = 32,

			_rot = 0,
			x_mult = 1,
			y_mult = 1,

			onUpdate = function(self,dt)	
				self._rot = self._rot + (math.pi)*dt

				self.velocity.x = tile_vel * self.x_mult * math.sin(self._rot)
				self.velocity.y = tile_vel * self.y_mult * math.sin(self._rot)
			end

		}

		t1 = zoetile:new 
		{

			debug = true,
			x = the.app.width/2-32,
			y = the.app.height/2-32,
			
			x_mult = -1, 
			y_mult = -1

		}
	
		t2 = zoetile:new {
			imageOffset = {x=32,y=0},

			x = the.app.width/2,
			y = the.app.height/2-32,

			y_mult = -1,

		}

		t3 = zoetile:new {
			imageOffset = {x=0,y=32},
			
			x = the.app.width/2-32,
			y = the.app.height/2,

			x_mult = -1,
		}
	
		t4 = zoetile:new 
		{
			imageOffset = {x=0,y=32},
			
			x = the.app.width/2,
			y = the.app.height/2

		}
	

		self:add(t1)
		self:add(t2)
		self:add(t3)
		self:add(t4)
	end

}



the.app:new()

the.app:run()