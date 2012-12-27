require 'zoetrope.init'

the.app = App:extend 
{
    onRun = function (self)

        text = Text:new {
            text = "Hi.",
            onUpdate = function (self,dt)
                if the.app:hasTouch() then 
         
                    if the.touch:pressed() then 
                        local pressed = the.touch:allPressed()
                        local touches = the.touch:getEvent(pressed)

                        local first = touches["0"]
                        text.text = first.x..","..first.y
                    elseif the.touch:justReleased("0") then
                        text.text = "Aww.. you let go :("

                    --else 
                     --   text.text = "no new touches this frame.."
                    end
                end
            end
        }
        self:add(text)

    end,

    onUpdate = function(self,dt)

    end    

}

the.app:new()
the.app:run()