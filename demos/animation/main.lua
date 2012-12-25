require 'zoetrope.init'

the.app = App:extend {
	
	onNew = function(self)

		t = Text:new {text = 'stopped'}
		anim = Animation:new {
			y = 120,
			image = 'emp.png',
			sequences = {
				start = {frames = {1,2,3,4,5,4,3,2,1}, fps=20, loops=true},

			},
			width = 120,
			height =120,

			onEndSequence = function (self)
				t.text = 'stopped'
			end

		}

		self:add(anim)
		self:add(t)
		--anim:play('start')
	end,

	onUpdate = function(self,dt)
		if the.mouse:justPressed('l') then 
			anim:play('start')
			t.text = 'playing'
		elseif the.mouse:justPressed('r') then 
			anim:freeze()
		end
	end
}

the.app:new()
the.app:run()