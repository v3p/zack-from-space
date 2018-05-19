--Handles all physics as well as interacting with bump.lua

local physics = {}

function physics:load()
	self.gravity = (settings.screen.height) * 4.3
	self.friction = 10
	self.maxVelocity = (settings.screen.height) * 10

	self.str = ""
end

function physics:clearWorld()
	self.world = nil
end

function physics:updateObject(item, x, y)
	self.world:update(item, x, y)
end

function physics:createWorld(map)
	self.world = bump.newWorld()

	for y=1, map.height do
		for x=1, map.width do
			local t = map.layer["tile"][y][x]
			if t then
				t.type = "tile"
				if t.tile <= 10 then
					self.world:add(t, t.x, t.y, TILE_SIZE, TILE_SIZE)
				elseif t.tile == 11 then -- Death spikes
					local height = math.floor(TILE_SIZE / 2)
					local y = (y - 1) * TILE_SIZE + height
					self.world:add(t, t.x, y, TILE_SIZE, height)
				end
			end
		end
	end


	return self.world
end

function physics:renderWorld()
	if self.world then
		local items, len = self.world:getItems()
		for i,v in ipairs(items) do
			love.graphics.setColor(1, 0, 1, 1)
			local x, y, w, h = self.world:getRect(v)
			love.graphics.rectangle("line", x, y, w, h)
		end
	end
	--love.graphics.print(self.str, state:getState().player.x, state:getState().player.y - 15)
end

--[[
	for y=1, self.map.height do
		for x=1, self.map.width do
			local t = self.map.layer["tile"][y][x]
			if t then
				love.graphics.draw(ATLAS, QUADS[t.tile], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, 0, TILE_SIZE / ASSET_SIZE, TILE_SIZE / ASSET_SIZE)
			end
		end
	end
]]

function physics:addObject(object, offsetX, offsetY)
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	self.world:add(object, object.x + offsetX, object.y + offsetY, object.width, object.height)
end

function physics:update(dt)
	local ent = entity:getSpawned()
	for i,v in ipairs(ent) do
		--Gravity
		if v.flags.gravity then
			if self.world:hasItem(v) then
				v.yVel = v.yVel + self.gravity * dt
				if v.yVel > self.maxVelocity then
					v.yVel = self.maxVelocity
				end

				local nx, ny = v.x + v.xVel * dt, v.y + v.yVel * dt


				local actualX, actualY, collisions, len = self.world:move(v, nx, ny, v.filter)

				v.x = actualX
				v.y = actualY

				--Collisin occured
				if #collisions > 0 then
					for o,b in ipairs(collisions) do

						if b.normal.y ~= 0 then
							if b.type == "slide" then v.yVel = 0 end
						end

						if type(v.handleCollision) == "function" then
							v:handleCollision(b)
						end

						if type(b.other.handleCollision) == "function" then
							b.other:handleCollision(b)
						end
					end
				else
					if type(v.handleCollision) == "function" then
						v:handleCollision(false)
					end
				end
			end
		end

		--Friction
		if v.flags.friction then
			local friction = v.friction or self.friction
			if math.abs(v.xVel) > 0 then
				if v.xVel > 0 then
					v.xVel = v.xVel - friction * dt
					if v.xVel < 0 then
						v.xVel = 0
					end
				else
					v.xVel = v.xVel + friction * dt
					if v.xVel > 0 then
						v.xVel = 0
					end
				end
			end
		end
	end
end

return physics





