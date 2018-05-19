local coin = {}

function coin:load(data)
	self.type = "coin"
	self.id = data.id

	self.x = data.x
	self.y = data.y
	self.width = math.floor(TILE_SIZE / 1.3)
	self.height = math.floor(TILE_SIZE / 1.3)
	self.xVel = 0
	self.yVel = 0

	self.collected = false

	self.offsetX = self.width / 2
	self.offsetY = self.height / 4

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

	self.quads = {QUADS[28], QUADS[29], QUADS[30], QUADS[31]}
	self.animation = animation.new(self.quads, 12)
end

function coin:update(dt)
	self.alpha = self.alpha + (self.targetAlpha - self.alpha) * 6 * dt
	if self.light then
		self.light.brightness = self.alpha
	end
	if self.alpha < 0.001 then
		self.remove = true
		if self.light then self.light.remove = true end
	end

	self.t = self.t + self.wobbleSpeed * dt
	if self.t > math.pi * 2 then
		self.t = 0
	end

	self.animation:update(dt)
end

function coin:draw()
	love.graphics.setColor(1, 1, 1, self.alpha)
	--love.graphics.draw(ATLAS, QUADS[22], self.x + (TILE_SIZE / 4), self.y + (self.yOffset * math.sin(self.t)) + (TILE_SIZE / 4), 0, TILE_SIZE / ASSET_SIZE, TILE_SIZE / ASSET_SIZE)
	self.animation:draw(self.x + (TILE_SIZE / 4), self.y, TILE_SIZE / ASSET_SIZE, TILE_SIZE / ASSET_SIZE)
end


function coin:handleCollision(collision)
	if not self.collected then

		self.flags.gravity = true
		self.yVel = -((settings.screen.height * TILE_SIZE) * 0.025)
		self.targetAlpha = 0

		state:getState():collect(self.type)

		self.collected = true
	end
end

function coin.filter(item, other)
	return "cross"
end

return coin