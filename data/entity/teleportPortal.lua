local teleportPortal = {}
	
function teleportPortal:load(data)
	self.type = "teleportPortal"
	self.id = data.id
	self.endLevel = data.endLevel
	self.action = data.action

	self.x = data.x
	self.y = data.y
	self.width = TILE_SIZE
	self.height = math.floor(TILE_SIZE / 2)

	self.destinationX = data.destinationX
	self.destinationY = data.destinationY

	self.teleported = false
	self.cooldown = 1
	self.cooldownTick = 0

	self.hue = 126
	self.baseHue = 126
	self.hueRange = 64
	self.t = 0

	self.flags = {
		physics = true
	}
end

function teleportPortal:update(dt)
	self.t = self.t + 5 * dt
	if self.t > (math.pi * 2) then
		self.t = 0
	end
	self.hue = self.baseHue + (self.hueRange * math.sin(self.t))

	if self.teleported then
		self.cooldownTick = self.cooldownTick - dt
		if self.cooldownTick < 0 then
			self.teleported = false
		end
	end

	if self.light then self.light.brightness = 1 + (math.sin(self.t)) end

end

function teleportPortal:draw()
	--love.graphics.setColor(hsl(self.hue, 255, 126, 255))
	love.graphics.setColor(COLOR.blue)
	if self.endLevel then
		love.graphics.setColor(COLOR.green)
	end
	love.graphics.draw(ATLAS, QUADS[33], self.x, self.y - (ASSET_SIZE * (math.sin(self.t))) - math.floor(TILE_SIZE / 2), 0, TILE_SIZE / ASSET_SIZE, (TILE_SIZE / ASSET_SIZE) + (math.sin(self.t)))
end

function teleportPortal:handleCollision(collision)
	if collision then
		--sprint(collision.other.type
	end
end

function teleportPortal.filter(item, other)
	if other.type == "coin" then return "slide" end
end

return teleportPortal
