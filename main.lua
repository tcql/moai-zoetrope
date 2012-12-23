
require 'zoetrope.init'


local time = 0
local time2 = 0
local time3 = 0
the.app = App:extend {
	
	onNew = function (self) 

		
		grp = Group:new()
		grp2 = Group:new 
		{
			timeScale = 0.5
		}

		text1 = Text:new 
		{

			onUpdate = function(self,dt) 
				time = time+dt
					
				local ts = tostring(grp.timeScale):sub(0,6)
				local tl = tostring(time):sub(0,6)
				self.text = "Timescaled Group (at scale "..ts.."): "..tl
			end
		}

		text2 = Text:new 
		{
			x = 0,
			y = 50,
			onUpdate = function(self,dt)
				time2 = time2+dt
				local tl = tostring(dt):sub(0,6)
				self.text = "Actual Time (delta-time: "..tl.."): "..tostring(time2):sub(0,6)
			end

		}


		text3 = Text:new 
		{
			y = 100,
			onUpdate = function(self,dt)
				time3 = time3+dt
				self.text = "Timescaled Group (at scale "..grp2.timeScale.."): "..tostring(time3):sub(0,6)
			end
		}



		grp:add(text1)
		grp2:add(text3)

		self:add(grp2)
		self:add(grp)

		self:add(text2)
	end,

	onUpdate = function(self,dt)
		if grp.timeScale > 0 then 
			grp.timeScale = grp.timeScale - 0.1*dt
		else
			grp.timeScale = 0
		end

	end
}

the.app:new()

the.app:run()