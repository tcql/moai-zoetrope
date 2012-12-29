require 'zoetrope.init'

the.app = App:extend 
{
    
    onRun = function(self)

        local fill = Fill:new 
        {
            width=100,
            height=80,
            fill = {255,255,255,255},
            border = {0,255,255},
            time_count = 0,
            velocity = { rotation = 5 },
            onUpdate = function(self,dt)
                
      
                self.x = the.app.width/2 - self.width/2
                self.y = the.app.height/2 - self.height/2
       
                self.time_count = self.time_count+dt
                if self.time_count > 0.5 then 
                    self.fill = {math.random(0,255),math.random(0,255),math.random(0,255)}
                    self.time_count = 0
                end
         
            end

        }

        self:add(fill)

    end,



}


the.app:new()

the.app:run()