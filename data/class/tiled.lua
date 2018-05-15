local tiled = {}

function tiled.loadMap(path)
	if not love.filesystem.getInfo(path) then
		error("'"..path.."' doesn't exist.")
	end

	local raw = love.filesystem.load(path)()
	local name = raw.properties.levelName or "untitled"

	local map = {
		name = name,
		width = raw.width,
		height = raw.height,
		layer = {},
		object = {}
	}

	for i,v in ipairs(raw.layers) do
		if v.type == "tilelayer" then
			map.layer[v.name] = {{}}
			local x = 0
			local y = 1
			for o,b in ipairs(v.data) do
				x = x + 1
				local t = false
				if b > 0 then
					t = {
						tile = b,
						x = (x - 1) * TILE_SIZE,
						y = (y - 1) * TILE_SIZE 
					}
				end
				map.layer[v.name][y][x] = t
				if x >= map.width then
					x = 0
					y = y + 1
					map.layer[v.name][y] = {}
				end
			end
		elseif v.type == "objectgroup" then
			map.object = v.objects
			for i,v in ipairs(map.object) do
				v.x = v.x * (TILE_SIZE / ASSET_SIZE)
				v.y = v.y * (TILE_SIZE / ASSET_SIZE)

				if v.type == "spawnPoint" then
					map.startX = v.x
					map.startY = v.y
				end
			end
		end
	end

	return map
end

function tiled.drawLayer(map, layer)
	for y=1, map.width do
		for x=1, map.height do
			local tile = map.layer[layer][y][x]

			if tile then
				love.graphics.print(tile.tile, x * 16, y * 16)
			end
		end
	end
end

return tiled