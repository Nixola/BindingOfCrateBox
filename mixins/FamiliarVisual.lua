FamiliarVisual = {
    familiarVisualInit = function(self, visual) 
        self.visual = visual
    end,

    familiarVisualDraw = function(self)
        local x, y = self.body:getPosition()
        if self.direction == 'left' then
            love.graphics.draw(self.visual.left, x - self.w/2, y - self.h/2, 0)
        else
            love.graphics.draw(self.visual.right, x - self.w/2, y - self.h/2, 0)
        end
    end

}
