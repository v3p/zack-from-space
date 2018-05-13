local label = {}

function label:draw()
	love.graphics.setColor(self.data.color)
	love.graphics.setFont(self.data.font)
	love.graphics.printf(self.data.text, self.data.x, self.data.y, self.data.maxWidth, self.data.alignment)
end	

return label