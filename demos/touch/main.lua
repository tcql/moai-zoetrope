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
        
        text = Text:new {
            onUpdate = function (self,dt)
                if the.app:hasTouch() then 

                    if the.touch:pressed() then 
                        local pressed = the.touch:allPressed()
                        local touches = the.touch:getEvent(pressed)

                    
                        text.text = ''
                        for _,v in pairs(pressed) do
                            local loc = touches[v]
                            text.text = text.text..v..": x = "..loc.x..", y = "..loc.y.."\n"
                        end
                    else
                        text.text = 'no touches'
                    end   
                else
                    text = "Sorry, you don't have touch capability." 
                end
            end
        }
        self:add(text)

    end,

    onUpdate = function(self,dt)

        if the.app:hasTouch() then 
            
            local pressed = the.touch:getEvent(the.touch:allPressed())
            local released = the.touch:allJustReleased()

            for _,v in pairs(released) do
                if activeBubbles[v] then
                    activeBubbles[v]:die()
                end
                activeTouches[v] = nil
            end

            for k,v in pairs(pressed) do 
                if the.touch:justPressed(k) then 
                    local b = bubble:new{id = k}

                    the.app:add(b)
                    activeBubbles[k] = b
                end 

                activeTouches[k] = v
            end

        end
    end    

}

the.app:new()
the.app:run()