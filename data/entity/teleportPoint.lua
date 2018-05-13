local teleportPortal = {}
	
function teleportPortal:load(data)
	self.type = "teleportPortal"
	self.id = data.id

	self.x = data.x
	self.y = data.y
	self.width = math.floor(TILE_SIZE / 2)
	self.height = math.floor(TILE_SIZE / 2)
end

return teleportPortal
