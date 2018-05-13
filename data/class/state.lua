local state = {
	state = {},
	currentState = false
}

function state:loadStates(path)
	if not love.filesystem.getInfo(path) then
		error("'"..path.."' doesn't exist.")
	else
		for i,v in ipairs(love.filesystem.getDirectoryItems(path)) do
			if isLuaFile(v) then
				local n = string.gsub(v, ".lua", "")
				self.state[n] = require(path.."/"..n)
			end
		end
	end
end

function state:setState(name)
	self.currentState = self.state[name]
end

function state:getState()
	return self.currentState
end

function state:load(data)
	if type(self.currentState.load) == "function" then
		self.currentState:load(data)
	end
end

function state:update(dt)
	if type(self.currentState.update) == "function" then
		self.currentState:update(dt)
	end
end

function state:draw()
	if type(self.currentState.draw) == "function" then
		self.currentState:draw()
	end
end

function state:keypressed(key)
	if type(self.currentState.keypressed) == "function" then
		self.currentState:keypressed(key)
	end
end

function state:keyreleased(key)
	if type(self.currentState.keyreleased) == "function" then
		self.currentState:keyreleased(key)
	end
end

function state:mousepressed(x, y, key)
	if type(self.currentState.mousepressed) == "function" then
		self.currentState:mousepressed(x, y, key)
	end
end

function state:mousereleased(x, y, key)
	if type(self.currentState.mousereleased) == "function" then
		self.currentState:mousereleased(x, y, key)
	end
end

function state:textinput(t)
	if type(self.currentState.textinput) == "function" then
		self.currentState:textinput(t)
	end
end

function state:wheelmoved(x ,y)
	if type(self.currentState.wheelmoved) == "function" then
		self.currentState:wheelmoved(x, y)
	end
end

function state:quit()
	if type(self.currentState.quit) == "function" then
		self.currentState:quit()
	end
end

return state