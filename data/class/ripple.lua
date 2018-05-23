--Creates a little ripple effect used when teleporting, picking up coins etc.
--Should be intergrated into "screenEffect.lua" at some point.
local ripple = {
	spawned = {}
}

function ripple:new(x, y, time, radius, color, flash)
	time = time or 5
	radius = radius or TILE_SIZE * 2
	color = color or {1, 1, 1}
	local sx, sy = camera:getScreen(x, y)
	flash = flash or false
	local r = {
		x = x,
		y = y,
		time = time,
		radius = radius,
		cRadius = 0,
		alpha = 1,
		color = color,
		light = false
	}
	if flash then
		r.light = light:new(sx, sy, TILE_SIZE * 16, color)
	end

	self.spawned[#self.spawned + 1] = r
end

function ripple:update(dt)
	for i,v in ipairs(self.spawned) do
		v.cRadius = v.cRadius + (v.radius - v.cRadius) * v.time * dt
		v.alpha = v.alpha + (0 - v.alpha) * v.time * dt
		if v.light then v.light.brightness = v.alpha end

		if v.alpha < 0.01 then
			if v.light then v.light.remove = true end
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