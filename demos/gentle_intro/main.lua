require 'zoetrope.init'


 
Platform = Tile:extend
{
    width = 128,
    height = 32,

    image = 'brick.png',
 
    onCollide = function (self, other)
        self:displace(other)
    end
}

the.app = App:extend 
{

    onRun = function (self)

        self.platforms = Group:new()
        self.platforms:add(Platform:new{ x = 0, y = 400 })
        self.platforms:add(Platform:new{ x = 250, y = 400 })
        self:add(self.platforms)

    end   

}

the.app:new()
the.app:run()