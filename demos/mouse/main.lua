
require 'zoetrope.init'

the.app = App:extend {
	onNew = function(self)
		t = Tile:new {
			
			image = 'logo.png',

			
			acceleration = { rotation = 2},
			maxVelocity = {rotation = 15},

			onUpdate = function(self,dt)
				if the.mouse:pressed('l') then
					self.velocity.rotation = 7
					--self.acceleration.rotation = 2
				elseif the.mouse:pressed('r') then
 					self.velocity.rotation = -7
 				else
 					self.velocity.rotation = 0
				end
				self.x = the.mouse.x
				self.y = the.mouse.y
				--self.rotation = self.rotation+math.rad(180)*dt
				--self.x = self.x+20*dt
			end
		}
		text =Text:new {

			onUpdate = function(self,dt)
				self.text = "Mouse X: "..the.mouse.x .. "\n" 
					.. "Mouse Y: "..the.mouse.y.."\n"
					.."Tile Rotational Velocity: "..t.velocity.rotation
			end 
		}
		self:add(text)
		self:add(t)

	end

}



the.app:new()

the.app:run()