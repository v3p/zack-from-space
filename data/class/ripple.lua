local ripple = {
	spawned = {}
}

function ripple:new(x, y, time, radius, color)
	time = time or 5
	radius = radius or TILE_SIZE * 2
	color = color or {1, 1, 1}
	self.spawned[#self.spawned + 1] = {
		x = x,
		y = y,
		time = time,
		radius = radius,
		cRadius = 0,
		alpha = 1,
		color = color
	}
end

function ripple:update(dt)
	for i,v in ipairs(self.spawned) do
		v.cRadius = v.cRadius + (v.radius - v.cRadius) * v.time * dt
		v.alpha = v.alpha + (0 - v.alpha) * v.time * dt

		if v.alpha < 0.01 then
			table.remove(self.spawned, i)
		end
	end
end

function ripple:draw()
	local bmode = love.graphics.getBlendMode()
	love.graphics.setBlendMode("add")
	for i,v in ipairs(self.spawned) do
		love.graphics.setColor(v.color[1], v.color[2], v.color[3], v.alpha)
		love.graphics.circle("fill", v.x, v.y, v.cRadius)
	end
	love.graphics.setBlendMode(bmode)
end

return ripple