local game = {}

function game:load(data)
	self.first = true
	self.lives = 3
	self.level = data.level

	--Blocks input after reset.
	self.inputBlock = 0.2
	self.inputTick = 0

	self:reset()
end	

function game:reset()
	--physics:load()
	self.input = false
	self.inputTick = self.inputBlock
	physics:clearWorld()
	entity:clear()
	physics:load()
	--Creating map
	self.map = tiled.loadMap(self.level)
	self.world = physics:createWorld(self.map)
	entity:spawnMapEntities(self.map)

	--Creating player
	self.player = entity:spawn("player", {x = self.map.startX , y = self.map.startY})

	camera:load(self.player.x + (self.player.width / 2), self.player.y + (TILE_SIZE / 2) )

	--Game vars
	self.gameStarted = false
	self.gamePaused = false
	self.gameOver = false
	self.gameTime = 0
	self.gameCoins = 0

	screenEffect:flash()
end

function game:start()
	self.gameStarte = true
end

function game:pause()
	self.gamePaused = not self.gamePaused
end

function game:die()
	self:reset()
	self.lives = self.lives - 1
	if self.lives < 0 then
		self.gameOver = true
	end
end

function game:update(dt)
	if not self.input then
		self.inputTick = self.inputTick - dt
		if self.inputTick < 0 then
			self.input = true
		end
	end

	physics:update(dt)
	entity:update(dt)
	ripple:update(dt)

	camera:moveTo(self.player.x + (self.player.width / 2), self.player.y + (TILE_SIZE / 2), self.map)
	camera:restrictToMap(self.map)

	if self.input then
		if love.keyboard.isDown("a") then
			self.player:move(-1, dt)
			self:start()
		elseif love.keyboard.isDown("d") then
			self.player:move(1, dt)
			self:start()
		end
	end

	--Out of bounds check
	if self.player.y > self.map.height * TILE_SIZE then
		self:die()
	end
end

function game:draw()
	camera:push()

	self:drawMap()
	self:drawObject()
	entity:draw()
	ripple:draw()

	if settings.dev.debugMode then 
		if not settings.dev.simpleDebug then
			physics:renderWorld() 
		end
	end
	camera:pop()

end

function game:mousepressed(x, y, k)
	local cx, cy = camera:getMouse()
	timer:call("ripple:new("..cx..", "..cy..")", 1)
	--ripple:new(cx, cy)
end

function game:keypressed(key)
	if key == "space" then
		self.player:jump()
	elseif key == "escape" then
		state:setState("menu")
		state:load()
	end
end

function game:drawMap()
	love.graphics.setColor(1, 1, 1, 1)
	local x, y, w, h = camera:getView(self.map)
	for y=y, h do
		for x=x, w do
			local t = self.map.layer["tile"][y][x]
			if t then
				love.graphics.setColor(1, 1, 1, 1)
				if t.tile == 17 then
					love.graphics.setColor(0, 1, 0.5, 1)
				end
				love.graphics.draw(ATLAS, QUADS[t.tile], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, 0, TILE_SIZE / ASSET_SIZE, TILE_SIZE / ASSET_SIZE)
			end
		end
	end
end

function game:drawObject()
	for i,v in ipairs(self.map.object) do
		if v.shape == "text" then
			local color = v.properties.color or "white"
			love.graphics.setFont(FONT[v.properties.font])
			love.graphics.setColor(COLOR[color])
			love.graphics.print(v.text, v.x, v.y)
		end
	end
end

return game