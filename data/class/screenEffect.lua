local screenEffect = {
	_flash = {
		time = 16,
		alpha = 0,
		color = COLOR.white
	}
}

function screenEffect:flash(time, color)
	time = time or 16
	color = color or COLOR.white
	self._flash.time = time
	self._flash.color = color
	self._flash.alpha = 1
end	

function screenEffect:update(dt)
	if self._flash.alpha > 0.01 then
		self._flash.alpha = self._flash.alpha + (0 - self._flash.alpha) * self._flash.time * dt
	else
		self._flash.alpha = 0
	end
end

function screenEffect:draw()
	if self._flash.alpha > 0 then
		love.graphics.setColor(self._flash.color[1], self._flash.color[2], self._flash.color[3], self._flash.alpha)
		love.graphics.rectangle("fill", 0, 0, settings.screen.width, settings.screen.height)
	end
end

return screenEffect