local animation = {}
local am = {__index = animation}

function animation.new(quads, fps)
	local a = {
		quads = quads,
		fps = fps,
		tick = 0,
		current = 1,
		playing = true
	}

	return setmetatable(a, am)
end

function animation:start()
	self.playing = true
end

function animation:stop()
	self.playing = false
end

function animation:setFrame(frame)
	self.current = frame
end

function animation:update(dt)
	if self.playing then
		self.tick = self.tick + dt
		if self.tick > (1 / self.fps) then
			self.current = self.current + 1
			if self.current > #self.quads then
				self.current = 1
			end
			self.tick = 0
		end
	end
end

function animation:draw(x, y, sx, sy, ox, oy)
	love.graphics.draw(ATLAS, self.quads[self.current], x, y, 0, sx, sy, ox, oy)
end

return animation