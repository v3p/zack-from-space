--A minimal entity system that handles loading, spawning, updating and drawing entities.

local entity = {
	type = {},
	spawned = {}
}

--I ganked this function from: http://lua-users.org/wiki/CopyTable
local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function entity:loadEntities(path)
	if not love.filesystem.getInfo(path) then
		error("'"..path.."' doesn't exist.")
	else
		for i,v in ipairs(love.filesystem.getDirectoryItems(path)) do
			if isLuaFile(v) then
				local n = string.gsub(v, ".lua", "")
				self.type[n] = require(path.."/"..n)
			end
		end
	end
end

function entity:clear()
	self.spawned = {}
end

function entity:spawn(entityType, data)
	data = data or {}
	data.id = #self.spawned + 1

	self.spawned[data.id] = deepcopy(self.type[entityType])
	if type(self.spawned[data.id].load) == "function" then
		self.spawned[data.id]:load(data)
	end

	--Physics
	if self.spawned[data.id].flags.physics then
		physics:addObject(self.spawned[data.id], self.spawned[data.id].offsetX, self.spawned[data.id].offsetY)
	end

	return self.spawned[data.id]
end

function entity:remove(id)
	self.spawned[id] = nil
end

function entity:spawnMapEntities(map)
	--ENTITY LAYER
	for y=1, map.height do
		for x=1, map.width do
			e = map.layer["entity"][y][x]
			if e then
				if e.tile == 28 then
					entity:spawn("coin", {x = (x - 1) * TILE_SIZE - (TILE_SIZE / 4), y = (y - 1) * TILE_SIZE - (TILE_SIZE / 4)})
				end
			end
		end
	end
	--Object layer
	for i,v in ipairs(map.object) do
		if v.type == "teleportPortal" then
			local d = false
			local endLevel = false
			local action = false
			for o,b in ipairs(map.object) do
				if b.type == "teleportPoint" then
					if v.properties.teleportPointID == b.id then
						d = {x = b.x, y = b.y}
					end
					if b.properties.endLevel then
						endLevel = true
					end
				end
			end

			if v.properties.action then
				action = v.properties.action
			end

			if d then
				entity:spawn("teleportPortal", {x = v.x, y = v.y + (TILE_SIZE / 2), destinationX = d.x, destinationY = d.y})
			else
				entity:spawn("teleportPortal", {x = v.x, y = v.y + (TILE_SIZE / 2), endLevel = true, action = action})
			end

		end
	end
end

--CALLBACK FUNCTUINS
function entity:update(dt)
	for i,v in ipairs(self.spawned) do
		if type(v.update) == "function" then
			v:update(dt)
		end

		if v.remove then
			if physics.world:hasItem(v) then
				physics.world:remove(v)
			end
			table.remove(self.spawned, i)
		end
	end
end

function entity:draw()
	for i,v in ipairs(self.spawned) do
		if type(v.draw) == "function" then
			v:draw()
		end
	end
end

function entity:getSpawned()
	return self.spawned
end

function entity:count()
	local n = 0
	for k,v in pairs(self.spawned) do
		n = n + 1
	end
	return n
end



return entity