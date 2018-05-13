local tile = {}

function tile.loadAtlas(path, tileWidth, tileHeight, padding)
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

return tile