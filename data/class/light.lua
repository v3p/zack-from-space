local light = {}

function light:load()
	self.array = {}
	self.canvas = love.graphics.newCanvas()
	self.shadowColor = {0, 0, 0, 1}
	self.radius = TILE_SIZE * 2
	self.texture = self:createTexture(TILE_SIZE * 4, math.floor(TILE_SIZE * 2))
end

function light:new(x, y, radius, color, follow, followOffsetX, followOffsetY, flicker)
	if settings.light.enabled then
		radius = radius or self.radius
		color = color or {1, 1, 1, 1}
		follow = follow or false
		followOffsetX = followOffsetX or 0
		followOffsetY = followOffsetY or 0
		flicker = flicker or false
		self.array[#self.array + 1] = {
			x = x,
			y = y,
			radius = radius * settings.light.lightSizeMultiplier,
			color = color,
			follow = follow,
			followOffsetX = followOffsetX,
			followOffsetY = followOffsetY,
			brightness = 1,
			targetBrightness = 1,
			remove = false,
			flicker = flicker,
			flickerFrequency = 0.001
		}
		self.array.id = #self.array
		return self.array[#self.array]
	end
end

function light:update(dt)
	if settings.light.enabled then
		for i,v in ipairs(self.array) do
			v.brightness = v.brightness + (v.targetBrightness - v.brightness) * 10 * dt
			if v.follow then
				local sx, sy = camera:getScreen(v.follow.x, v.follow.y)
				v.x = sx + v.followOffsetX
				v.y = sy + v.followOffsetY
				v.remove = v.follow.remove
			end
			--Flicker
			if v.flicker then
				if math.random() < v.flickerFrequency then
					v.brightness = math.random()
				end
			end
		end

		for i,v in ipairs(self.array) do
			if v.remove then table.remove(self.array, i) end
		end
	end
end

function light:updateMap()
	--Updating
	local oc = love.graphics.getCanvas()
	local bm = love.graphics.getBlendMode()
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()

	love.graphics.setColor(settings.light.ambientColor)
	love.graphics.rectangle("fill", 0, 0, self.canvas:getWidth(), self.canvas:getHeight())

	love.graphics.setBlendMode("add")

	for i,v in ipairs(self.array) do
		love.graphics.setColor(v.color[1], v.color[2], v.color[3], v.brightness)
		love.graphics.draw(self.texture, v.x, v.y, 0, v.radius / self.texture:getWidth(), v.radius / self.texture:getHeight(), self.texture:getWidth() / 2, self.texture:getHeight() / 2)
	end

	love.graphics.setCanvas(oc)
	love.graphics.setBlendMode(bm)
end

function light:setBrightness(i, b)
	self.array[i].brightness = b
end

function light:draw()
	if settings.light.enabled then
		--if camera:isMoving() then
			light:updateMap()
		--end

		--Drawing
		love.graphics.setColor(1, 1, 1, 1)
		local bm = love.graphics.getBlendMode()
		love.graphics.setBlendMode("multiply", "premultiplied")
		love.graphics.draw(self.canvas)
		love.graphics.setBlendMode(bm)
	end
end

function light:createTexture(radius, segments)
	local texture = love.graphics.newCanvas(radius * 2, radius * 2)
	local oldCanvas = love.graphics.getCanvas()

	love.graphics.setCanvas(texture)
	--love.graphics.setColor(0, 0, 0, 1)
	--love.graphics.circle("fill", 0, 0, radius * 2, radius * 2)
	for i=1, segments do
		love.graphics.setColor(1, 1, 1,  (1 / (segments / 2) ) )
 		love.graphics.circle("fill", radius, radius, (radius / segments) * i )
	end

	love.graphics.setCanvas(oldCanvas)

	return texture
end

return light