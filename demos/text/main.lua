require 'zoetrope.init'
--MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX_BASELINES, 2, 1, 1, 0, 1 )
--MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX_LAYOUT, 2, 1, 1, 0, 1 )
MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX, 2, 1, 0, 1, 1 )



the.app = App:extend
{

    onRun = function(self)
        t = Text:new 
        {
            x = 00,
            y = 00,
            font = {size = 20, dpi=1},
            text = "Supercalifragilisticexpialidocious",
            width = 150,
            height = 86,
            verticalAlign = 'center',
            horizontalAlign = 'center',
            wordBreak = true,
            velocity = {rotation = 1},

            _scaleRot = 0,
            onUpdate = function(self,dt)
                self.scale = 1.5+math.sin(self._scaleRot)
                self._scaleRot = self._scaleRot+0.8*dt 
                self:centerAround(the.app.width/2,the.app.height/2)
            end
    

        }
        self:add(t)



    end


}

the.app:new()
the.app:run()