local checkBox = {}

function checkBox:draw()
	love.graphics.setColor(self.data.color)
	local m = "line"
	if self.data.checked then
		m = "fill"
	end
	love.graphics.rectangle(m, self.data.x, self.data.y, self.data.height, self.data.height)
	love.graphics.setFont(self.data.font)
	local centerY = self.data.y + (self.data.height / 2) - ( (self.data.font:getAscent() - self.data.font:getDescent() ) / 2 )
	love.graphics.print(self.data.text, self.data.x + (self.data.height * 1.1), centerY)
end

function checkBox:mousereleased(x, y, key)
	if self.mouseOver then
		self.data.checked = not self.data.checked
	end
end

return checkBox