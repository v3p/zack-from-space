--All the gameplay happens in here.

local game = {}

function game:load(data)
	love.graphics.setBackgroundColor(COLOR.sky)
	--love.mouse.setVisible(false)

	self.lives = 3
	self.level = data.level
	self.special = data.special

	if not self.special then
		CURRENT_LEVEL = self.level
	end

	if not data.gameOverLevel then
		self.levelTime = 0
		self.levelCoins = 0
		self.levelScore = 0
	end

	self.gameTime = 0
	self.gameCoins = 0

	--Blocks input after reset.
	self.inputBlock = 0.2
	self.inputTick = 0

	self.gameOverLevel = data.gameOverLevel

	--HUD Animation
	self.coinQuads = {QUADS[28], QUADS[29], QUADS[30], QUADS[31]}
	self.coinAnimation = animation.new(self.coinQuads, 12)

	--LEvels
	self.currentLevel = 0

	self.title = "Level "..CURRENT_LEVEL
	self.titleAlpha = 1
	self._titleAlpha = 1
	self.titleTime = 2

	self:reset()
end	

function game:reset()
	--physics:load()
	gui:clear()

	self.input = false
	self.inputTick = self.inputBlock

	--physics:clearWorld() * Not sure if needed
	entity:clear()
	physics:load()

	--Creating map
	if self.special then
		self.map = tiled.loadMap(self.level)
	else
		self.map = tiled.loadMap("data/map/"..LEVELS[self.level]..".lua")
	end
	self.world = physics:createWorld(self.map)
	entity:spawnMapEntities(self.map)


	--Creating player
	self.player = entity:spawn("player", {x = self.map.startX , y = self.map.startY})

	--Changes the player into a ghost.
	if self.map.properties.deadPlayer then
		self.player.dead = true
	end

	camera:load(self.player.x + (self.player.width / 2), self.player.y + (TILE_SIZE / 2) )

	--light system
	light:load()
	--Entities
	for i,v in ipairs(entity.spawned) do
		if v.type == "coin" then
			v.light = light:new(v.x, v.y, TILE_SIZE * 8, COLOR.gold, v, TILE_SIZE / 1.5, TILE_SIZE / 2)
		elseif v.type == "teleportPortal" then
			local color = COLOR.blue
			if v.endLevel then
				color = COLOR.green
			end
			v.light = light:new(v.x, v.y, TILE_SIZE * 8, color, v, TILE_SIZE / 2, TILE_SIZE / 2)
		end
	end

	--Tiles
	for y=1, self.map.height do
		for x=1, self.map.width do
			local t = self.map.layer["tile"][y][x]
			if t then
				if t.tile == 35 then
					--Ceiling light
					light:new(t.x, t.y, TILE_SIZE * 16, COLOR.white, t, TILE_SIZE / 2, TILE_SIZE / 2)
				elseif t.tile == 12 or t.tile == 13 or t.tile == 14 or t.tile == 15 then
					--Arrows
					light:new(t.x, t.y, TILE_SIZE * 8, COLOR.green, t, TILE_SIZE / 2, TILE_SIZE / 2)
				end
			end
		end
	end

	--Gameover level stuff.
	if self.gameOverLevel then
		self.levelScore = (self.levelCoins * 8) - (self.levelTime * 0.5)

		for i,v in ipairs(self.map.object) do
			if v.name == "score" then
				v.text = "Score: "..math.floor(self.levelScore * 100) / 100
			elseif v.name == "time" then
				v.text = "Time: "..math.floor(self.levelTime * 10) / 10
			elseif v.name == "coins" then
				v.text = "Coins: "..self.levelCoins
			end
		end
	end

	--Game vars
	self.gameStarted = false
	self.gamePaused = false
	self.gameOver = false
	self.gameTime = 0
	self.gameCoins = 0

	screenEffect:flash()
end

function game:nextLevel()
	CURRENT_LEVEL = CURRENT_LEVEL + 1
	if CURRENT_LEVEL > #LEVELS then
		CURRENT_LEVEL = 1
	end
	self:load({level = CURRENT_LEVEL})
end

function game:repeatLevel()
	self:load({level = CURRENT_LEVEL} )
end

function game:start()
	self.gameStarted = true
end

function game:pause()
	self.gamePaused = not self.gamePaused
end

function game:die()
	self.lives = self.lives - 1
	if self.lives > 0 then
		self:reset()
		self.levelCoins = 0
	else
		self.gameOver = true
		self:loadGameOver()
	end
end

function game:endLevel()
	if state:getState().special then
		--TUTORIAL
		state:setState("menu")
		state:load({screen = "levelSelect"})
	else
		--Normal level
		self:load({special = true, gameOverLevel = true, level = "data/map/special/gamewin.lua"})
		screenEffect:flash()
	end
end

function game:collect(item)
	if item == "coin" then
		self.gameCoins = self.gameCoins + 1
		self.levelCoins = self.levelCoins + 1
	end
end

function game:update(dt)
	--LIGHTS
	light:update(dt)

	self.titleTime = self.titleTime - dt

	if self.titleTime < 0 then
		self.titleAlpha = self.titleAlpha + (0 - self.titleAlpha) * 5 * dt
	end

	--Animations
	self.coinAnimation:update(dt)

	--Time
	if self.gameStarted and not self.gameOver then
		self.gameTime = self.gameTime + dt
		self.levelTime = self.levelTime + dt
	end

	--Input delay 
	if not self.input then
		self.inputTick = self.inputTick - dt
		if self.inputTick < 0 then
			self.input = true
		end
	end

	--System updates.
	physics:update(dt)
	entity:update(dt)
	ripple:update(dt)
	gui:update(dt)

	--Camera update
	camera:moveTo(self.player.x + (self.player.width / 2), self.player.y + (TILE_SIZE / 2), self.map)
	--camera:restrictToMap(self.map)

	--HOLD Input.
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
	if not self.gameOver then
		camera:push()

		self:drawMap()
		entity:draw()
		ripple:draw()

		--Drawing physics world
		if settings.dev.debugMode then 
			if not settings.dev.simpleDebug then
				physics:renderWorld() 
			end
		end
		camera:pop()

		light:draw()


		camera:push()
		self:drawObject()
		camera:pop()

		self:drawHud()

		if not self.special then
			love.graphics.setColor(COLOR.green[1], COLOR.green[2], COLOR.green[3], self.titleAlpha)
			love.graphics.setFont(FONT.large)
			love.graphics.printf(self.title, 0, settings.screen.height * 0.2, settings.screen.width, "center")
		end
	else
		gui:draw()
	end

	--love.graphics.setColor(COLOR.white)
--	love.graphics.print("Level Coins: "..self.levelCoins.."\nLevel Time: "..self.levelTime, 300, 12)
	
end

function game:mousepressed(x, y, k)
	gui:mousepressed(x, y, k)

end

function game:mousereleased(x, y, k)
	gui:mousereleased(x, y, k)
end

function game:keypressed(key)
	if key == "space" then
		self.player:jump()
	elseif key == "escape" then
		state:setState("menu")
		state:load()
	end
end

function game:drawHud()
	if not self.map.properties.hideHud then
		--BG
		--love.graphics.setColor(0, 0, 0, 0.4)
		--love.graphics.rectangle("fill", 0, 0, settings.screen.width * 0.2, settings.screen.height * 0.25)

		--Health
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setFont(FONT.medium)
		local spacing = TILE_SIZE * 0.9
		--Lives
		for i=1, self.lives do
			love.graphics.draw(ATLAS, QUADS[32], settings.screen.hudX + (spacing * (i - 1)), settings.screen.hudY, 0, TILE_SIZE / ASSET_SIZE, TILE_SIZE / ASSET_SIZE)
		end

		--Cash
		--love.graphics.draw(ATLAS, QUADS[28], settings.screen.hudX, settings.screen.hudY + spacing, 0, TILE_SIZE / ASSET_SIZE, TILE_SIZE / ASSET_SIZE)
		self.coinAnimation:draw(settings.screen.hudX, settings.screen.hudY + spacing, TILE_SIZE / ASSET_SIZE, TILE_SIZE / ASSET_SIZE)

		love.graphics.setColor(COLOR.gold)
		love.graphics.print(self.gameCoins, settings.screen.hudX + (spacing * 1.5), settings.screen.hudY + spacing)

			--Time
		love.graphics.setColor(COLOR.white)
		local str = tostring(math.floor(self.gameTime * 10) / 10)
		if not str:match("%.") then
			str = str..".0"
		end
		love.graphics.print(str, 12, settings.screen.hudY + (spacing * 2) )
	end
end

function game:drawMap()
	love.graphics.setColor(1, 1, 1, 1)
	local x, y, w, h = camera:getView(self.map)
	local layers = {"background", "tile"} --Layers drawn in this order.
	for i,v in ipairs(layers) do
		for y=y, h do
			for x=x, w do
				local t = self.map.layer[v][y][x]
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
end

function game:drawObject()
	for i,v in ipairs(self.map.object) do
		if v.shape == "text" then
			local width = FONT[v.properties.font]:getWidth(v.text)
			local height = FONT[v.properties.font]:getAscent() - FONT[v.properties.font]:getDescent()
			if camera:inView(v.x, v.y, width, height) then
				local color = v.properties.color or "white"
				love.graphics.setFont(FONT[v.properties.font])
				love.graphics.setColor(COLOR[color])
				love.graphics.print(v.text, v.x, v.y)
			end
		end
	end
end

function game:loadGameOver()
	--[[ *OLD GAME OVER SCREEN.
	gui:clear()
	--Title
	local data = {color = COLOR.red, text = "GAME OVER", x = 0, y = math.floor(settings.screen.height * 0.2), alignment = "center"}
	local d = mergeTable(data, labelData)
	gui:new("data/class/gui/label.lua", d)

	--Resaults
	local data = {text = "Time: "..(math.floor(self.gameTime * 100) / 100).."\nCoins: "..self.gameCoins, font = FONT.medium, x = 0, y = math.floor(settings.screen.height * 0.3), alignment = "center"}
	local d = mergeTable(data, labelData)
	gui:new("data/class/gui/label.lua", d)

	--RESET
	local data = {click = self.buttonPress, x = (buttonData.width * 0.1), y = math.floor(settings.screen.height * 0.89), text = "RESET"}
	local d = mergeTable(data, buttonData)
	gui:new("data/class/gui/button.lua", d)

	--MENU
	local data = {click = self.buttonPress, x = settings.screen.width - (buttonData.width * 1.1), y = math.floor(settings.screen.height * 0.89), text = "MENU"}
	local d = mergeTable(data, buttonData)
	gui:new("data/class/gui/button.lua", d)
	]]
	self:load({special = true, gameOverLevel = true, level = "data/map/special/gameover.lua"})
end

function game.buttonPress(button)
	if button.data.text == "RESET" then
		local level = game.level
		game:load({level = level})
	elseif button.data.text == "MENU" then
		state:setState("menu")
		state:load()
	end
end

return game