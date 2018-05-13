local listbox = {
	scrollSpeed = 4
}

local function normal(val, min, max)
	return (val - min) / (max - min)
end

function listbox:load()
	local nitems = {}
	local totalHeight = 0
	for i,v in ipairs(self.data.items) do
		v.height = self.data.font:getAscent() - self.data.font:getDescent()
		v.x = self.data.x + 12
		v.y = self.data.y + (v.height * (i - 1) )
		totalHeight = totalHeight + v.height
	end

	self.data.totalHeight = totalHeight
	self.data.rscroll = self.data.scroll

	self.data.highlit = 0
end

function listbox:draw()
	love.graphics.setColor(self.data.color)
	love.graphics.rectangle("line", self.data.x, self.data.y, self.data.width, self.data.height)

	--Items
	love.graphics.setFont(self.data.font)

	love.graphics.setScissor(self.data.x, self.data.y, self.data.width, self.data.height)
	for i,v in ipairs(self.data.items) do
		love.graphics.setColor(self.data.color)
		if v.highlight then
			love.graphics.setColor(COLOR.white)
		end
		if i == self.data.selected then
			love.graphics.setColor(COLOR.green)
		end
		love.graphics.print(v.name, v.x, v.y + self.data.rscroll)	
	end
	love.graphics.setScissor()
end

function listbox:update(dt)
	self.data.rscroll = self.data.rscroll + (self.data.scroll - self.data.rscroll) * 10 * dt
	local x, y = love.mouse.getPosition()
	if pointInRect(x, y, self.data.x, self.data.y, self.data.width, self.data.height) then
		for i,v in ipairs(self.data.items) do
			if pointInRect(x, y, v.x, v.y + self.data.scroll, self.data.width, v.height) then
				v.highlight = true
				self.data.highlit = i
			else
				v.highlight = false
			end
		end
	else
		for i,v in ipairs(self.data.items) do v.highlight = false end
		self.data.highlit = 0
	end
end

function listbox:mousereleased(x, y, key)
	if pointInRect(x, y, self.data.x, self.data.y, self.data.width, self.data.height) then
		self.data.selected = self.data.highlit
	end
end

function listbox:wheelmoved(x, y)
	if self.data.totalHeight > self.data.height then
		self.data.scroll = self.data.scroll + (y * self.scrollSpeed)
		if self.data.scroll > 0 then self.data.scroll = 0 end
		if self.data.scroll < -(self.data.totalHeight - self.data.height) then 
			self.data.scroll = -(self.data.totalHeight - self.data.height)
		end
	end
end

return listbox