local coin = {}

function coin:load(data)
	self.type = "coin"
	self.id = data.id

	self.x = data.x
	self.y = data.y
	self.width = math.floor(TILE_SIZE / 2)
	self.height = math.floor(TILE_SIZE / 2)
	self.xVel = 0
	self.yVel = 0

	self.collected = false

	self.offsetX = self.width
	self.offsetY = self.height

	self.xVel = 0
	self.yVel = 0
	self.flags = {
		physics = true
	}

	self.alpha = 1
	self.targetAlpha = 1

	self.t = (math.pi * 2) * math.random()
	self.yOffset = TILE_SIZE * 0.1
	self.wobbleSpeed = 5
end

function coin:update(dt)
	self.alpha = self.alpha + (self.targetAlpha - self.alpha) * 6 * dt
	if self.alpha < 0.001 then
		self.remove = true
	end

	self.t = self.t + self.wobbleSpeed * dt
	if self.t > math.pi * 2 then
		self.t = 0
	end
end

function coin:draw()
	love.graphics.setColor(1, 1, 1, self.alpha)
	love.graphics.draw(ATLAS, QUADS[16], self.x + (TILE_SIZE / 4), self.y + (self.yOffset * math.sin(self.t)) + (TILE_SIZE / 4), 0, TILE_SIZE / ASSET_SIZE, TILE_SIZE / ASSET_SIZE)
end


function coin:handleCollision(collision)
	if not self.collected then

		self.flags.gravity = true
		self.yVel = -((settings.screen.height * TILE_SIZE) * 0.025)
		self.targetAlpha = 0

		self.collected = true
	end
end

function coin.filter(item, other)
	return "cross"
end

return coin