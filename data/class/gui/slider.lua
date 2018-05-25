local slider = {}

function slider:load()
	self.value = self.data.value or 0 --NORMALIZED
	self.minValue = self.data.minValue or 0
	self.maxValue = self.data.maxValue or 1

	self.mousedown = false
end

function slider:getValue()
	return fmath.lerp(self.value, self.minValue, self.maxValue)
end

function slider:update(dt)
	local mx, my = love.mouse.getPosition()
	if self.mouseDown then
		self.value = fmath.normal(mx, self.data.x, self.data.x + self.data.width)
		if self.value < 0 then
			self.value = 0
		elseif self.value > 1 then
			self.value = 1
		end
	end
end

function slider:draw()
	love.graphics.setColor(self.data.color)
	love.graphics.rectangle("line", self.data.x, self.data.y, self.data.width, self.data.height)

	love.graphics.rectangle("fill", self.data.x, self.data.y, self.data.width * self.value, self.data.height)
end

function slider:mousepressed(x, y, key)
	if fmath.pointInRect(x, y, self.data.x, self.data.y, self.data.width, self.data.height) then
		self.mouseDown = true
	end
end

function slider:mousereleased(x, y, key)
	self.mouseDown = false
end

return slider