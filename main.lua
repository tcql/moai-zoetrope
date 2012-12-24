
require 'zoetrope.init'


local time = 0
local time2 = 0

the.app = App:extend {
	onNew = function(self)
		t = Tile:new {
			imageOffset = {x=32,y = 0},
			
			image = 'image.axd.png',
			width = 32,
			height = 32,
			

			--velocity = {x = 50, y = 50, rotation = math.pi},
			acceleration = { x = 10, y = 10, rotation = 0.5},


			onUpdate = function(self,dt)
				--self.rotation = self.rotation+math.rad(180)*dt
				--self.x = self.x+20*dt
			end
		}

		self:add(t)

	end

	--[[
	onNew = function (self) 

		grp = Group:new()
		grp2 = Group:new { timeScale = 0.5 }

		-- This text is in grp, whose timescale will be continuously decreased
		-- by the App onUpdate.
		text1 = Text:new 
		{

			onUpdate = function(self,dt) 
				time = time+dt
					
				local ts = tostring(grp.timeScale):sub(0,6)
				local tl = tostring(time):sub(0,6)
				self.text = "Timescaled Group (at scale "..ts.."): \n"..tl
			end
		}

		-- This text shows the actual elapsed time with no modification
		text2 = Text:new 
		{
			y = 50,
			onUpdate = function(self,dt)
				local tl = tostring(dt):sub(0,6)
				self.text = "Actual Time (delta-time: "..tl.."): \n"..tostring(MOAISim.getElapsedTime()):sub(0,6)
			end

		}

		-- This text belongs to grp2, who is timescaled at 1/2 speed
		text3 = Text:new 
		{
			y = 120,
			onUpdate = function(self,dt)
				time2 = time2+dt
				self.text = "Timescaled Group (at scale "..grp2.timeScale.."): \n"..tostring(time2):sub(0,6)
			end
		}



		grp:add(text1)
		grp2:add(text3)

		-- Nested groups work. You can swap the two lines below to see 
		-- that nested groups display and that their timescales also work 
		--grp:add(grp2)
		self:add(grp2)


		self:add(grp)
		self:add(text2)
	end,


	onUpdate = function(self,dt)


		if grp.timeScale > 0 then 
			grp.timeScale = grp.timeScale - 0.05*dt
		else
			grp.timeScale = 0
		end


	end
	--]]
}



the.app:new()

the.app:run()