--Contains various utiltiy functions. Loaded into the global scope because fuck it 

function loadAtlas(path, tileWidth, tileHeight, padding)
	if not love.filesystem.getInfo(path) then
		error("'"..path.."' doesn't exist.")
	end

	local a = {}
	local img = love.graphics.newImage(path)
	local width = math.floor(img:getWidth() / tileWidth)
	local height = math.floor(img:getHeight() / tileHeight)
		
	local x, y = padding, padding
	for i=1, width * height do
		a[i] = love.graphics.newQuad(x, y, tileWidth, tileHeight, img:getWidth(), img:getHeight())
		x = x + tileWidth + padding
		if x > (width * tileWidth) then
			x = padding
			y = y + tileHeight + padding
		end
	end

	return img, a
end

function loadImages(path)
	if not love.filesystem.getInfo(path) then
		error("'"..path.."' doesn't exist.")
	else
		local t = {}
		for i,v in ipairs(love.filesystem.getDirectoryItems(path)) do
			if isFileType(v, "png") then
				local n = string.gsub(v, ".png", "")
				local _atlas, _quads = tile.loadAtlas(path.."/"..v, ASSET_SIZE, ASSET_SIZE, 2)
				t[n] = {atlas = _atlas, quads = _quads}
			end
		end
		return t
	end
end

function requireFolder(path)
	if not love.filesystem.getInfo(path) then
		error("'"..path.."' doesn't exist.")
	else
		for i,v in ipairs(love.filesystem.getDirectoryItems(path)) do
			if isFileType(v, "lua") then
				local n = string.gsub(v, ".lua", "")
				_G[n] = require(path.."/"..n)
			end
		end
	end
end

function mergeTable(t1, t2)
	for k,v in pairs(t2) do
		if not t1[k] then
			t1[k] = v
		end
	end
	return t1
end

function isLuaFile(file)
	if string.match(file, "%.lua") then
		return true
	else return false end
end

function isFileType(file, extension)
	if string.match(file, "%."..extension) then
		return true
	else return false end
end

function openSaveDirectory()
	love.system.openURL("file://"..love.filesystem.getSaveDirectory())
end

function hsl(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m),(g+m),(b+m),a
end
