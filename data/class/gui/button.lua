local button = {}

function button:load()

end

function button:update(dt)

end

function button:draw()
	love.graphics.setColor(self.data.color)
	love.graphics.rectangle("fill", self.data.x, self.data.y, self.data.width, self.data.height)

	if self.mouseOver then
		love.graphics.setColor(COLOR.green)
		love.graphics.rectangle("line", self.data.x, self.data.y, self.data.width, self.data.height)
	end

	love.graphics.setColor(COLOR.white)
	love.graphics.setFont(self.data.font)
	local centerY = self.data.y + (self.data.height / 2) - ( (self.data.font:getAscent() - self.data.font:getDescent() ) / 2 )
	love.graphics.printf(self.data.text, self.data.x, centerY, self.data.width, "center")

end

function button:mousepressed(x, y, key)

end

function button:mousereleased(x, y, key)
	if self.mouseOver then
		self.data.click(self)
	end
end

return button