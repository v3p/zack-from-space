local menu = {}

function menu:load(data)
	data = data or {}
	self:generateBackground()
	if data.screen == "start" then
		self:loadStart()
	else
		self:loadMain()
	end
end

function menu:generateBackground()
	self.background = love.graphics.newCanvas()
	local w = math.floor(settings.screen.width / TILE_SIZE) + 1
	local h = math.floor(settings.screen.height / TILE_SIZE) + 1

	local oc = love.graphics.getCanvas()
	love.graphics.setCanvas(self.background)
	love.graphics.setColor(1, 1, 1, 1)
	for y=1, h do
		for x=1, w do
			love.graphics.draw(ATLAS, QUADS[37], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, 0, TILE_SIZE / ASSET_SIZE, TILE_SIZE / ASSET_SIZE)
		end
	end

	love.graphics.setCanvas(oc)
end

function menu:loadMain()
	gui:clear()
	--Title
	local data = {color = COLOR.green, font = FONT.huge, text = GAME_NAME, x = 0, y = math.floor(settings.screen.height * 0.2), alignment = "center"}
	local d = mergeTable(data, labelData)
	gui:new("data/class/gui/label.lua", d)

	--START
	local data = {click = menu.buttonPress, x = (settings.screen.width / 2) - (buttonData.width / 2), y = math.floor(settings.screen.height * 0.5), text = "START"}
	local d = mergeTable(data, buttonData)
	gui:new("data/class/gui/button.lua", d)

	--Options
	local data = {click = menu.buttonPress, x = (settings.screen.width / 2) - (buttonData.width / 2), y = math.floor(settings.screen.height * 0.61), text = "OPTIONS"}
	local d = mergeTable(data, buttonData)
	gui:new("data/class/gui/button.lua", d)

	--Credits
	local data = {click = menu.buttonPress, x = (settings.screen.width / 2) - (buttonData.width / 2), y = math.floor(settings.screen.height * 0.72), text = "CREDITS"}
	local d = mergeTable(data, buttonData)
	gui:new("data/class/gui/button.lua", d)

	--EXIT
	local data = {click = menu.buttonPress, x = (settings.screen.width / 2) - (buttonData.width / 2), y = math.floor(settings.screen.height * 0.83), text = "EXIT"}
	local d = mergeTable(data, buttonData)
	gui:new("data/class/gui/button.lua", d)
end

function menu:loadOptions()
	gui:clear()
	--Title
	local data = {text = "Options", x = 0, y = math.floor(settings.screen.height * 0.05), alignment = "center"}
	local d = mergeTable(data, labelData)
	gui:new("data/class/gui/label.lua", d)


	--resolution Title
	local data = {font = FONT.small, text = "SCREEN RESOLUTION", x = math.floor(settings.screen.width * 0.5), y = math.floor(settings.screen.height * 0.16), alignment = "left"}
	local d = mergeTable(data, labelData)
	gui:new("data/class/gui/label.lua", d)

	--Resolutions
	local items = {}
	for i,v in ipairs(RESOLUTIONS) do
		items[i] = {name = v.width.." x "..v.height, value = i}
	end
	local data = {selected = settings.screen.resolution, items = items, x = math.floor(settings.screen.width * 0.5), y = math.floor(settings.screen.height * 0.2)}
	local d = mergeTable(data, listboxData)
	self.resolution = gui:new("data/class/gui/listbox.lua", d)	

	--Fullscreen
	local data = {text = "FULLSCREEN", checked = settings.screen.fullscreen, x = math.floor(settings.screen.width * 0.5), y = math.floor(settings.screen.height * 0.51)}
	local d = mergeTable(data, checkBoxData)
	d.width = d.height + d.font:getWidth(d.text)
	self.fullscreen = gui:new("data/class/gui/checkBox.lua", d)

	--light
	local data = {text = "LIGHTS", checked = settings.light.enabled, x = math.floor(settings.screen.width * 0.5), y = math.floor(settings.screen.height * 0.6)}
	local d = mergeTable(data, checkBoxData)
	d.width = d.height + d.font:getWidth(d.text)
	self.light = gui:new("data/class/gui/checkBox.lua", d)

	--Controllers Title
	local data = {font = FONT.small, text = "CONTROLS", x = math.floor(settings.screen.width * 0.01), y = math.floor(settings.screen.height * 0.16), alignment = "left"}
	local d = mergeTable(data, labelData)
	gui:new("data/class/gui/label.lua", d)

	--CONTROLLERS
	local items = {}
	for i,v in ipairs(CONTROLLERS) do
		items[i] = {name = v, value = v}
	end
	local data = {selected = 0, items = items, x = math.floor(settings.screen.width * 0.01), y = math.floor(settings.screen.height * 0.2)}
	local d = mergeTable(data, listboxData)
	self.controllers = gui:new("data/class/gui/listbox.lua", d)	

	--APPLY
	local data = {click = menu.buttonPress, x = (buttonData.width * 0.1), y = math.floor(settings.screen.height * 0.89), text = "APPLY"}
	local d = mergeTable(data, buttonData)
	gui:new("data/class/gui/button.lua", d)

	--BACK
	local data = {click = menu.buttonPress, x = settings.screen.width - (buttonData.width * 1.1), y = math.floor(settings.screen.height * 0.89), text = "BACK"}
	local d = mergeTable(data, buttonData)
	gui:new("data/class/gui/button.lua", d)
end

function menu:loadStart()
	gui:clear()
	--Title
	local data = {text = "Select level", x = 0, y = math.floor(settings.screen.height * 0.05), alignment = "center"}
	local d = mergeTable(data, labelData)
	gui:new("data/class/gui/label.lua", d)

	--Level list
	local items = {}
	for i,v in ipairs(LEVELS) do
		items[i] = {name = v, value = "data/map/"..v..".lua"}
	end
	local data = {selected = 0, items = items, x = math.floor(settings.screen.width * 0.1), y = math.floor(settings.screen.height * 0.15), width = math.floor(settings.screen.width * 0.8), height = math.floor(settings.screen.height * 0.6) }
	local d = mergeTable(data, listboxData)
	self.level = gui:new("data/class/gui/listbox.lua", d)


	--Play
	local data = {click = menu.buttonPress, x = (buttonData.width * 0.1), y = math.floor(settings.screen.height * 0.89), text = "PLAY"}
	local d = mergeTable(data, buttonData)
	gui:new("data/class/gui/button.lua", d)

	--BACK
	local data = {click = menu.buttonPress, x = settings.screen.width - (buttonData.width * 1.1), y = math.floor(settings.screen.height * 0.89), text = "BACK"}
	local d = mergeTable(data, buttonData)
	gui:new("data/class/gui/button.lua", d)	
end

function menu:loadCredits()
	gui:clear()
	--Title
	local data = {text = "CREDITS", x = 0, y = math.floor(settings.screen.height * 0.05), alignment = "center"}
	local d = mergeTable(data, labelData)
	gui:new("data/class/gui/label.lua", d)

	local creditsText = [[Libraries:
	'bump.lua' by 'Enrique García Cota'
	'ser.lua' by 'Robin Wellner'

Fonts:
	'cubecavern.ttf' by 'memesbruh03'

Other software used:
	Tiled, Sublime text, Pyxel edit.

	Made in löve]]

	local data = {font = FONT.medium, text = creditsText, x = 12, y = math.floor(settings.screen.height * 0.2), alignment = "left"}
	local d = mergeTable(data, labelData)
	gui:new("data/class/gui/label.lua", d)

	--BACK
	local data = {click = menu.buttonPress, x = settings.screen.width - (buttonData.width * 1.1), y = math.floor(settings.screen.height * 0.89), text = "BACK"}
	local d = mergeTable(data, buttonData)
	gui:new("data/class/gui/button.lua", d)
end

function menu:update(dt)
	gui:update(dt)
end

function menu:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.background)
	gui:draw()
end

function menu:mousepressed(x, y, key)
	gui:mousepressed(x, y, key)
end

function menu:mousereleased(x, y, key)
	gui:mousereleased(x, y, key)
end

function menu:wheelmoved(x, y)
	gui:wheelmoved(x, y)
end

function menu.buttonPress(button)
	--sprint(button.data.text)
	if button.data.text == "START" then
		menu:loadStart()
	elseif button.data.text == "OPTIONS" then
		menu:loadOptions()
	elseif button.data.text == "CREDITS" then
		menu:loadCredits()
	elseif button.data.text == "EXIT" then
		love.event.push("quit")
	elseif button.data.text == "BACK" then
		menu:loadMain()
	elseif button.data.text == "APPLY" then
		--settings.screen.width = menu.resolution.data.items[menu.resolution.data.selected].width
		--settings.screen.height = menu.resolution.data.items[menu.resolution.data.selected].height
		settings.screen.resolution = menu.resolution.data.items[menu.resolution.data.selected].value
		settings.screen.width = RESOLUTIONS[settings.screen.resolution].width
		settings.screen.height = RESOLUTIONS[settings.screen.resolution].height
		settings.screen.fullscreen = menu.fullscreen.data.checked
		settings.light.enabled = menu.light.data.checked

		--Fixing for fullscreen
		if settings.screen.fullscreen then
			settings.screen.resolution = #RESOLUTIONS
		end


		applySettings()

		resize()
		menu:generateBackground()

		--menu:load()
		menu:loadOptions()
	elseif button.data.text == "PLAY" then
		if menu.level.data.selected > 0 then
			local level = menu.level.data.items[menu.level.data.selected].value
			state:setState("game")
			state:load({level = level})
		end
	end
end

return menu















