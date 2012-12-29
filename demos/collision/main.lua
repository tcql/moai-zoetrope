require 'zoetrope.init'

the.app = App:extend
{
    onRun = function(self)

        f1 = Fill:new 
        {
            width = 100, height = 100,
            x = 150,
            y = 150,
            onCollide = function(self,other)
                print("COLLIDE from 1")
            end

        }

        f2 = Fill:new 
        {
            width=100, height = 100,
            x = 80,
            y = 50,
            fill = {0,255,0},

            onUpdate = function(self,dt)
                if the.keys:pressed('a') then
                    self.velocity.x = -80
                elseif the.keys:pressed('s') then
                    self.velocity.x = 80
                elseif the.keys:pressed('w') then
                    self.velocity.y = -80
                elseif the.keys:pressed('d') then
                    self.velocity.y = 80
                else
                    self.velocity.x = 0
                    self.velocity.y = 0
                end
                
            end,

            onCollide = function(self,other)
                print ("collide from 2")
                other:displace(self)
            end

        }

        self:add(f1)
        self:add(f2)

    end,


    onUpdate = function (self,dt)

        f1:collide(f2)
    end

}


the.app:new()
the.app:run()