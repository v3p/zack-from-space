--The player entity
--Currently has a "dead" boolean that tells it if he's a ghost or not.
--The ghost should become it's own entity at some point.

local player = {}

function player:load(data)
	self.type = "player"


	self.god = false

	self.x = data.x
	self.y = data.y
	self.width = math.floor(TILE_SIZE / 2.5)
	self.height = TILE_SIZE
	self.xVel = 0
	self.yVel = 0

	--MOVEMENT VARIABLES
	self.jumpHeight = (settings.screen.height) * 1.3
	self.moveSpeed = (settings.screen.height ) * 0.6
	--Acceleration
	self.groundAcceleration = (settings.screen.width + settings.screen.height) * 2
	self.airAcceleration = (settings.screen.width + settings.screen.height) * 0.9
	self.acceleration = (settings.screen.width + settings.screen.height) * 2
	--Friction
	self.groundFriction = (settings.screen.width + settings.screen.height) * 1
	self.airFriction = (settings.screen.width + settings.screen.height) * 0.1
	self.friction = self.groundFriction

	--Player state
	self.state = "runRight" --runLeft, runRight, idle, falling
	self.runDirection = "right"

	--Jumping stuff
	self.canJump = true
	self.jumpTimeout = 0.1
	self.jumpTick = 0
	self.touched = false

	self.isWallJump = false
	self.wallJumpDirection = "right"

	self.ability = {
		--Wall jump
		wallJumpLimit = 2,
		wallJumpCount = 0
	}

	self.canMove = true

	self.quads = {
		runRight = {QUADS[16], QUADS[17], QUADS[18], QUADS[19]},
		runLeft = {QUADS[20], QUADS[21], QUADS[22], QUADS[23]},
		standRight = {QUADS[24], QUADS[25]},
		standLeft = {QUADS[26], QUADS[27]},
		fallRight = {QUADS[17]},
		fallLeft = {QUADS[21]},
		ghostRight = QUADS[38],
		ghostLeft = QUADS[39]
	}

	self.flags = {
		physics = true,
		gravity = true,
		friction = true
	}

	--Controls the opacity for the player. Used when teleporting.
	self.alpha = 1
	self.targetAlpha = 1

	self.animation = {
		runRight = animation.new(self.quads.runRight, 12),
		runLeft = animation.new(self.quads.runLeft, 12),
		standRight = animation.new(self.quads.standRight, 3),
		standLeft = animation.new(self.quads.standLeft, 3),
		fallRight = animation.new(self.quads.fallRight, 1),
		fallLeft = animation.new(self.quads.fallLeft, 1)
	}

	--Ghost stuff
	self.t = 0
	self.dead = false
	self.deadShader = love.graphics.newShader([[
		vec4 effect( vec4 color, Image tex, vec2 tc, vec2 sc )
		{	
			vec4 c = Texel(tex, tc);
			c.rgb = color.rgb + 1;
			c.a = c.a - 0.6;
			return Texel(tex, tc) * c;
		}
		]])
end

function player:update(dt)
	self.t = self.t + dt
	if self.t > math.pi * 2 then self.t = 0 end

	--Allows the player to jump mid air if he touched a wall recently
	if self.jumpTick > 0 then
		self.jumpTick = self.jumpTick - dt
		if self.jumpTick <= 0 then
			self.canJump = false
		end
	end

	self.alpha = self.alpha + (self.targetAlpha - self.alpha) * 16 * dt

	--Animations
	if self.state == "idle" then
		if self.runDirection == "right" then
			self.animation.standRight:start()
		elseif self.runDirection == "left" then
			self.animation.standLeft:start()
		end
	elseif self.state == "falling" then
		if self.runDirection == "right" then
			self.animation.fallRight:start()
		elseif self.runDirection == "left" then
			self.animation.fallLeft:start()
		end
	else
		if self.runDirection == "right" then
			self.animation.runRight:start()
		elseif self.runDirection == "left" then
			self.animation.runLeft:start()
		end
	end

	--Friction and acceleration
	if self.state == "falling" then
		self.friction = self.airFriction
		self.acceleration = self.airAcceleration
	else
		self.friction = self.groundFriction
		self.acceleration = self.groundAcceleration
	end

	--Animations
	for k,v in pairs(self.animation) do
		v:update(dt)
	end
end

function player:draw()
	love.graphics.setColor(1, 1, 1, self.alpha)
	local anim = ""
	if self.state == "runLeft" then
		anim = "runLeft"
	elseif self.state == "runRight" then
		anim = "runRight"
	elseif self.state == "idle" then
		if self.runDirection == "left" then
			anim = "standLeft"
		else
			anim = "standRight"
		end
	elseif self.state == "falling" then
		if self.runDirection == "left" then
			anim = "fallLeft"
		else
			anim = "fallRight"
		end
	end

	if self.dead then
		local q = self.quads.ghostRight
		if self.runDirection == "left" then
			q = self.quads.ghostLeft
		end
		local bm = love.graphics.getBlendMode()
		love.graphics.setBlendMode("add")
		love.graphics.setColor(0.5, 0.8, 1, 1)
		love.graphics.draw(ATLAS, q, self.x + (TILE_SIZE / 4.4), self.y - (TILE_SIZE / 6) * (1 + math.sin(self.t * 2)), 0, TILE_SIZE / ASSET_SIZE, TILE_SIZE / ASSET_SIZE, ASSET_SIZE / 2, 0)
		love.graphics.setBlendMode(bm)
	else
		self.animation[anim]:draw(self.x + (TILE_SIZE / 4.4), self.y, TILE_SIZE / ASSET_SIZE, TILE_SIZE / ASSET_SIZE, ASSET_SIZE / 2, 0)
	end
end

function player:teleport(x, y, portal)
	local c = "local x = "..x.." local y = "..y
	local code = c..[[
	local self = state:getState().player
	local d = fmath.distance(x, y, self.x, self.y)
	ripple:new(x + (self.width / 2), y + (self.height / 2), 5, TILE_SIZE * 1.5, COLOR.blue, true)
	portal = portal or false
	self.x = x
	self.y = y
	self.targetAlpha = 1
	self.canMove = true
	self.xVel = 0
	self.yVel = 0
	physics:updateObject(self, self.x, self.y)
	if d > math.min(settings.screen.width, settings.screen.height) then
		camera:load(self.x + (self.width / 2), self.y + (TILE_SIZE / 2) )
	end
	]]
	ripple:new(self.x + self.width / 2, self.y + self.height / 2, 5, TILE_SIZE * 1.5, COLOR.blue, true)
	self.targetAlpha = 0
	self.canMove = false
	timer:call(code, 0.2)
end

function player:jump(height)
	if self.canJump then
		self.canJump = false
		height = height or self.jumpHeight
		self.yVel = -self.jumpHeight
		if self.isWallJump then

			local x = self.jumpHeight * 0.3
			if self.wallJumpDirection == "right" then
				x = -(self.jumpHeight * 0.3)
			end

			--Wall jump limit
			self.ability.wallJumpCount = self.ability.wallJumpCount + 1
			if self.ability.wallJumpCount > self.ability.wallJumpLimit then
				self.canJump = false
			end
			self.xVel = x
		end
	end
end

function player:move(direction, dt)
	if self.canMove then
		if direction < 0 then
			self.runDirection = "left"

			local acceleration = self.acceleration
			if self.xVel > 0 then
				acceleration = self.acceleration * 2
			end

			self.xVel = self.xVel - self.acceleration * dt
			if self.xVel < -self.moveSpeed then
				self.xVel = -self.moveSpeed
			end
		else
			self.runDirection = "right"

			local acceleration = self.acceleration
			if self.xVel < 0 then
				acceleration = self.acceleration * 2
			end

			self.xVel = self.xVel + self.acceleration * dt
			if self.xVel > self.moveSpeed then
				self.xVel = self.moveSpeed
			end

			end
		end
end

--Collision
function player:handleCollision(collision)
	local touch = false
	if collision then
		if collision.type == "slide" then
			if self.ability.wallJumpCount < self.ability.wallJumpLimit then self.canJump = true end

			--Ground collision
			if collision.normal.y == -1 then
				self.canJump = true
				self.touched = false
				self.ability.wallJumpCount = 0
				if self.xVel == 0 then
					self.state = "idle"
				elseif self.xVel < 0 then
					self.state = "runLeft"
				elseif self.xVel > 0 then
					self.state = "runRight"
				end
			elseif collision.normal.y == 1 then
				self.canJump = false
			end

			--Wall Collision
			if collision.normal.x ~= 0 then
				self.isWallJump = true
				self.touched = false
				self.xVel = 0
				if collision.normal.x == -1 then
					self.wallJumpDirection = "right"
				else
					self.wallJumpDirection = "left"
				end
			else
				self.isWallJump = false
			end

			--Death spikes
			if collision.other.tile == 11 then
				if not self.god then
					state:getState():die()
				end
			end
		elseif collision.type == "cross" then
			--PORTALS
			if collision.other.type == "teleportPortal" then
				if not collision.other.teleported then
					--END LEVEL
					if collision.other.endLevel then
						if collision.other.action then
							if collision.other.action == "repeatLevel" then
								state:getState():repeatLevel()
							elseif collision.other.action == "nextLevel" then
								state:getState():nextLevel()
							elseif collision.other.action == "menu" then
								state:setState("menu")
								state:load()
								screenEffect:flash()
							end
						else
							--GAME WIN
							state:setState("game")
							state:load({special = true, gameOverLevel = true, level = "data/map/special/gamewin.lua"})
							screenEffect:flash()
						end
					else
						--TELEPORT
						self:teleport(collision.other.destinationX, collision.other.destinationY, collision.other)
						collision.other.teleported = true
						collision.other.cooldownTick = collision.other.cooldown
					end
				end
			--COINS
			elseif collision.other.type == "coin" then
				if not collision.other.collected then
					collision.other.collected = true
					collision.other.targetAlpha = 0

					ripple:new(collision.other.x + (TILE_SIZE / 1.4), collision.other.y + (TILE_SIZE / 1.8), 5, TILE_SIZE * 1.5, COLOR.gold)
					state:getState():collect(collision.other.type)
				end
			end
		end
	else
		self.state = "falling"
		if not self.touched then
			self.jumpTick = self.jumpTimeout
			self.touched = true
		end
	end
end

function player.filter(item, other)
	if other.type == "tile" then 
		return "slide"
	elseif other.type == "coin" or other.type == "teleportPortal" then
		return "cross"
	end
end

return player