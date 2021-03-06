function love.load()
	--Used for debug
	str = ""

	--Couple globals
	GAME_VERSION = 0.1
	GAME_STAGE = "alpha"
	GAME_NAME = "Zack from space"
	ASSET_SIZE = 16
	CURRENT_LEVEL = 1
	COLOR = {
		sky = {0, 0, 0},--{0.223, 0.313, 0.45},
		dark = {0.129, 0.141, 0.164},
		white = {0.9, 0.9, 0.9},
		grey = {0.6, 0.6, 0.6},
		red = {0.9, 0.1, 0.1},
		green = normalColor(91, 214, 166, 255),
		blue = normalColor(53, 176, 242, 255),
		lightBlue = {0.9, 0.9, 1, 255},
		gold = normalColor(243, 221, 122, 255)
	}

	--Löve setup
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.filesystem.setIdentity(GAME_NAME)
	love.graphics.setBackgroundColor(COLOR.sky)
	love.graphics.setLineStyle("rough")

	--Loading files (Some files are loaded after the window is created.)
	require("data/class/util")--Needs to be loaded seperatly as it contains the "requireFolder" function.
	requireFolder("data/class")
	state:loadStates("data/state")
	entity:loadEntities("data/entity")

	--Creating a list of levels
	LEVELS = {}
	for i,v in ipairs(love.filesystem.getDirectoryItems("data/map")) do
		if isFileType(v, "lua") then
			LEVELS[#LEVELS + 1] = string.gsub(v, ".lua", "")
		end
	end

	--Creating a list of controllers
	CONTROLLERS = {
		"Keyboard"
	}

	JOYSTICKS = love.joystick.getJoysticks()
	for i,v in ipairs(JOYSTICKS) do
		CONTROLLERS[#CONTROLLERS + 1] = v:getName()
	end

	--Finding default resolution.
	RESOLUTIONS = love.window.getFullscreenModes()
	table.sort(RESOLUTIONS, function(a, b) return a.width * a.height < b.width * b.height end)
	local defaultWidth = RESOLUTIONS[2].width
	local defaultHeight = RESOLUTIONS[2].height

	--Default settings
	settings = {
		screen = {
			width = defaultWidth,
			height = defaultHeight,
			resolution = 2,
			title = GAME_NAME.." ["..GAME_VERSION.." "..GAME_STAGE.."]",
			vsync = true,
			fullscreen = false,
			resizable = false,
			hudX = 12,
			hudY = 12
		},
		light = {
			enabled = true,
			ambientColor = {0.4, 0.4, 0.4, 1},
			lightSizeMultiplier = 1
		},
		sound = {
			master = 1,
			soundFX = 1,
			music = 0.7
		},
		dev = {
			debugMode = true,
			simpleDebug = true
		}
	}

	--Checks if "settings.lua" exists, and loads it if it does.
	if love.filesystem.getInfo("settings.lua") then
		settings = data:load("settings.lua")
	end

	applySettings()
	resize()

	--Loading assets
	ATLAS, QUADS = tile.loadAtlas("data/img/atlas.png", 16, 16, 2)
	TITLE = love.graphics.newImage("data/img/title.png")
	

	--Settings and loading state.
	state:setState("menu")
	state:load({special = true, level = "data/map/level7.lua"})
end

function applySettings()
	--Adjusting for fullscreen mode.
	if settings.screen.fullscreen then
		local _, _, flags = love.window.getMode()
		local width, height = love.window.getDesktopDimensions(flags.display)
		settings.screen.width = width
		settings.screen.height = height
	end

	love.window.setMode(settings.screen.width, settings.screen.height, {fullscreen = settings.screen.fullscreen, vsync = settings.screen.vsync})
	love.window.setTitle(settings.screen.title)
end

function resize()
	TILE_SIZE = math.floor( settings.screen.height * 0.07)
	light:load()

	FONT = {
		DEBUG = love.graphics.newFont("data/font/cubecavern.ttf", math.floor((settings.screen.width) * 0.02)),
		small = love.graphics.newFont("data/font/cubecavern.ttf", math.floor((settings.screen.width) * 0.02)),
		medium = love.graphics.newFont("data/font/cubecavern.ttf", math.floor((settings.screen.width) * 0.04)),
		large = love.graphics.newFont("data/font/cubecavern.ttf", math.floor((settings.screen.width) * 0.06)),
		huge = love.graphics.newFont("data/font/cubecavern.ttf", math.floor((settings.screen.width) * 0.09)),
		hud = love.graphics.newFont("data/font/FreePixel.ttf", math.floor((settings.screen.width) * 0.035))
	}

	---GUI Defaults
	buttonData = {
		width = math.floor(settings.screen.width * 0.3),
		height = math.floor(settings.screen.height * 0.1),
		font = FONT.large,
		interactive = true,
		color = COLOR.grey
	}

	labelData = {
		font = FONT.large,
		color = COLOR.white,
		maxWidth = settings.screen.width,
		interactive = false
	}

	checkBoxData = {
		font = FONT.medium,
		color = COLOR.white,
		height = math.floor(settings.screen.height * 0.07),
		interactive = true,
		checked = false
	}

	listboxData = {
		font = FONT.medium,
		color = COLOR.dark,
		width = math.floor(settings.screen.width * 0.4),
		height = math.floor(settings.screen.height * 0.3),
		items = {},
		itemHeight = FONT.medium:getAscent() - FONT.medium:getDescent(),
		highlight = 0,
		scroll = 0
	}

	sliderData = {
		color = COLOR.white,
		width = math.floor(settings.screen.width * 0.4),
		height = math.floor(settings.screen.height * 0.1)
	}
end

function sprint(t)
	str = str..tostring(t).."\n"
end

function love.update(dt)
	--dt = dt * 0.5
	camera:update(dt)
	timer:update(dt)
	state:update(dt)
	screenEffect:update(dt)
end

function love.draw()
	state:draw()
	screenEffect:draw()

	love.graphics.setFont(FONT.small)
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.print(str, 12, 12)

	if settings.dev.debugMode then 
		if settings.dev.simpleDebug then
			drawSimpleDebug()
		else
			drawDebug() 
		end
	end
end

function love.keypressed(key)
	state:keypressed(key)
	if key == "escape" then 
		if love.keyboard.isDown("lshift") then love.event.push("quit") end
	end
	if key == "f1" then 
		if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
			if settings.dev.debugMode then
				settings.dev.simpleDebug = not settings.dev.simpleDebug
			end
		else
			settings.dev.debugMode = not settings.dev.debugMode
		end
	end
	if key == "f2" then
		openSaveDirectory()
	end
end

function love.keyreleased(key)
	state:keyreleased(key)
end

function love.mousepressed(x, y, k)
	state:mousepressed(x, y, k)
end

function love.mousereleased(x, y, k)
	state:mousereleased(x, y, k)
end

function love.wheelmoved(x, y)
	state:wheelmoved(x, y)
end

function love.quit()
	data:save("settings.lua", settings)
end

function drawDebug()
	love.graphics.setColor(0, 0, 0, 0.5)
	love.graphics.rectangle("fill", settings.screen.width * 0.7, 0, settings.screen.width, settings.screen.height * 0.35)

	love.graphics.setColor(1, 0, 0, 1)

	local s = love.graphics.getStats()
	local stats = {
		{name = "GAME VERSION", val = GAME_VERSION},
		{name = "FPS", val = love.timer.getFPS()},
		{name = "DRAW CALLS", val = s.drawcalls},
		{name = "CANVAS SWITCHES", val = s.canvasswitches},
		{name = "TEXTURE MEMORY", val = math.floor(s.texturememory / 1024 / 1024 * 100) / 100 .." mb"},
		{name = "CANVASES", val = s.canvases},
		{name = "LOADED FONTS", val = s.fonts},
		{name = "BATCHED DRAW CALLS", val = s.drawcallsbatched},
		{name = "SPAWNED ENTITIES", val = entity:count()},
		--{name = "LEVEL", val = state:getState().map.name},
		{name = "SCREEN RESOLUTION", val = settings.screen.width.."x"..settings.screen.height}
	}
	local str = ""
	for i,v in ipairs(stats) do
		str = str..v.name..": "..tostring(v.val).."\n"
	end
	love.graphics.setFont(FONT.DEBUG)
	love.graphics.printf(str, -6, 6, settings.screen.width, "right")

	--local rx, ry = camera:getMouse()
	--love.graphics.print(rx.." x "..ry, love.mouse.getX(), love.mouse.getY() - 12)
end

function drawSimpleDebug()
	love.graphics.setColor(1, 0, 0, 1)

	love.graphics.setFont(FONT.DEBUG)
	love.graphics.printf(love.timer.getFPS(), -6, 6, settings.screen.width, "right")
end

function normalColor(r, g, b, a)
	a = a or 1
	return {r / 255, g / 255, b / 255, a / 255}
end


