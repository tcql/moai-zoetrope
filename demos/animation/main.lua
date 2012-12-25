require 'zoetrope.init'

frameCounter = 1

the.app = App:extend {
	
	onNew = function(self)

		t = Text:new { y = 80, text = 'stopped'}
		anim = Animation:new {
			y = 180,
			image = 'emp.png',
			sequences = {
				start = {frames = {1,2,3,4,5,4,3,2,1}, fps=20, loops=true},

			},
			width = 120,
			height =120,

			onEndSequence = function (self)
				t.text = 'stopped'
				frameCounter = self.currentFrame + 1
			end

		}

		t2 = Text:new { text = "Left Click to Play \nRight Click to Pause\nMiddle Click to step frame by frame" }

		self:add(anim)
		self:add(t)
		self:add(t2)
		--anim:play('start')
	end,

	onUpdate = function(self,dt)
		if the.mouse:justPressed('l') then 
			anim:play('start')
			t.text = 'playing'
		elseif the.mouse:justPressed('r') then 
			anim:freeze()

		elseif the.mouse:justPressed('m') then 

			anim:freeze(frameCounter)
			frameCounter = frameCounter+1

		end
	end
}

the.app:new()
the.app:run()