
require 'zoetrope.init'

frameCounter = 1

the.app = App:extend {
	
	onNew = function(self)

		t = Text:new { y = 80, text = 'stopped'}
		anim = Animation:new {
			y = 180,
			image = 'player.png',
			sequences = {
				right = {frames = {1,2,3,4,5,6}, fps=10, loops=true},
				left = {frames = {7,8,9,10,11,12}, fps = 10, loops = true }
			},
			width = 32,
			height = 48,
			--rotation = math.pi/2,
			onEndSequence = function (self)
				t.text = 'stopped'
				frameCounter = self.currentFrame + 1
			end

		}
		anim.currentSequence = 'right'

		t2 = Text:new { text = "Left Click to Play \nRight Click to Pause\nMiddle Click to switch animation" }

		self:add(anim)
		self:add(t)
		self:add(t2)
		--anim:play('right')
	end,

	onUpdate = function(self,dt)
		if the.mouse:justPressed('l') then 
			anim:play(anim.currentSequence)
			t.text = 'playing\n'..anim.currentSequence
		elseif the.mouse:justPressed('r') then 
			anim:freeze()

		elseif the.mouse:justPressed('m') then 
			if anim.currentSequence == "left" then
				anim:freeze()
				anim:play('right')
			else
				anim:freeze()
				anim:play('left')
			end
			t.text = 'playing\n'..anim.currentSequence
		end
	end
}

the.app:new()
the.app:run()