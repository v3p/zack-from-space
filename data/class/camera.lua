local camera = {
		x = 0,
		y = 0,
		tx = 0,
		ty = 0,
		smoof = 12,
		moving = false
	}

function camera:load(x, y)
	self.x = x - (settings.screen.width / 2)
	self.tx = x - (settings.screen.width / 2)
	self.y = y - (settings.screen.height / 2)
	self.ty = y - (settings.screen.height / 2)
end

function camera:update(dt)
	self.x = self.x + (self.tx - self.x) * self.smoof * dt
	self.y = self.y + (self.ty - self.y) * self.smoof * dt
	local xm, ym = true, true
	if math.abs(self.x - self.tx) < 0.01 then
		self.x = self.tx
		xm = false
	end
	if math.abs(self.y - self.ty) < 0.01 then
		self.y = self.ty
		ym = false
	end

	if not xm and not ym then
		self.moving = false
	else
		self.moving = true
	end
end

function camera:restrictToMap(map)
	local mapWidth = map.width * TILE_SIZE
	local mapHeight = map.height * TILE_SIZE

	if mapWidth > settings.screen.width then
		if self.x < 0 then
			self.x = 0
		elseif self.x + settings.screen.width > mapWidth then
			self.x = mapWidth - settings.screen.width
		end
	else
		self.y = (mapWidth / 2) - (settings.screen.width / 2)
	end

	if mapHeight > settings.screen.height then
		if self.y < 0 then
			self.y = 0
		elseif self.y + settings.screen.height > mapHeight then
			self.y = mapHeight - settings.screen.height
		end
	else
		self.y = (mapHeight / 2) - (settings.screen.height / 2)
	end
end

function camera:push()
	love.graphics.push()
	love.graphics.translate(-math.floor(self.x), -math.floor(self.y))
end

function camera:pop()
	love.graphics.pop()
end

function camera:moveTo(x, y)
	self.tx = x - (settings.screen.width / 2)
	self.ty = y - (settings.screen.height / 2)
	
end

function camera:isMoving()
	return self.moving
end

function camera:getMouse()
	return love.mouse.getX() + self.x, love.mouse.getY() + self.y
end

function camera:getScreen(x, y)
	return x - self.x, y - self.y
end

function camera:getView(map)
	local x = math.floor(self.x / TILE_SIZE)
	local y = math.floor(self.y / TILE_SIZE)
	local w = x + math.floor(settings.screen.width / TILE_SIZE) + 2
	local h = y + math.floor(settings.screen.height / TILE_SIZE) + 2

	if x < 1 then x = 1 elseif x > map.width then x = map.width end
	if y < 1 then y = 1 elseif y > map.height then y = map.height end
	if w < 1 then w = 1 elseif w > map.width then w = map.width end
	if h < 1 then h = 1 elseif h > map.height then h = map.height end
	return x, y, w, h
end

return camera