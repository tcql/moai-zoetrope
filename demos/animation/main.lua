require 'zoetrope.init'

the.app = App:extend {
	
	onNew = function(self)
		anim = Animation:new {
			image = 'emp.png',
			sequences = {
				start = {frames = {1,2,3,4,5,4,3,2,1}, fps=20, loops=true},

			},
			width = 120,
			height =120,

		}

		self:add(anim)
		anim:play('start')
	end
}

the.app:new()
the.app:run()