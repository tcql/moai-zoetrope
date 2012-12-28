STRICT = true
require 'zoetrope.init'


activeTouches = {}
activeBubbles = {}


bubble = Tile:extend {
    id = "0",
    image = 'bubble.png',
    onNew = function(self)
        self:placeAtParent()
    end,
    onUpdate = function (self,dt) 
        self:placeAtParent()
    end,
    placeAtParent = function(self)
        local parent = activeTouches[self.id]
        if parent then 
            self.x = parent.x-self.width/2
            self.y = parent.y-self.height/2
        end
    end
}


the.app = App:extend 
{


    onRun = function (self)

        self:_debugInputs()
        
        text = Text:new {
            onUpdate = function (self,dt)
                if the.app:hasTouch() then 

                    if the.touch:pressed() then 
                        local pressed = the.touch:allPressed()
                        local touches = the.touch:getEvents(pressed)

                    
                        self.text = ''
                        for _,v in pairs(pressed) do
                            local loc = touches[v]
                            self.text = self.text..v..": x = "..loc.x..", y = "..loc.y.."\n"
                        end
                    else
                        self.text = 'no touches'
                    end   
                else
                    self.text = "Sorry, you don't have touch capability." 
                end
            end
        }
        self:add(text)

    end,

    onUpdate = function(self,dt)
        if the.app:hasTouch() then 
            
            local pressed = the.touch:getEvents(the.touch:allPressed())
            local released = the.touch:allJustReleased()

            for _,v in pairs(released) do
                if activeBubbles[v] then
                    self:remove(activeBubbles[v])
                    --activeBubbles[v]:die()
                end
                activeTouches[v] = nil
            end

            for k,v in pairs(pressed) do 
                activeTouches[k] = v
                if the.touch:justPressed(k) then 
                    local b = bubble:new{id = k}

                    the.app:add(b)
                    activeBubbles[k] = b
                end 

                
            end

        end
    end    

}

the.app:new()
the.app:run()