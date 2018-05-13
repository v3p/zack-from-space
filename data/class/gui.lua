local gui = {
	array = {} 
}


function gui:new(path, data)
	local b = love.filesystem.load(path)()
	b.data = data
	self.array[#self.array + 1] = b
	if type(self.array[#self.array].load) == "function" then
		self.array[#self.array]:load()
	end
	return self.array[#self.array]
end

function gui:clear()
	self.array = {}
end

function gui:update(dt)
	local mx, my = love.mouse.getPosition()
	for i,v in ipairs(self.array) do
		if type(v.update) == "function" then v:update(dt) end

		if v.data.interactive then
			v.mouseOver = false
			if pointInRect(mx, my, v.data.x, v.data.y, v.data.width, v.data.height) then
				v.mouseOver = true
			end
		end
	end
end

function gui:draw()
	for i,v in ipairs(self.array) do
		v:draw()
	end
end

function gui:mousepressed(x, y, key)
	for i,v in ipairs(self.array) do
		if type(v.mousepressed) == "function" then v:mousepressed(x, y, key) end
	end
end

function gui:mousereleased(x, y, key)
	for i,v in ipairs(self.array) do
		if type(v.mousereleased) == "function" then v:mousereleased(x, y, key) end
	end
end

function gui:wheelmoved(x, y, key)
	for i,v in ipairs(self.array) do
		if type(v.wheelmoved) == "function" then v:wheelmoved(x, y, key) end
	end
end

return gui








