--Loads and saves data as .lua files using ser.lua
local data = {}

function data:save(path, table)
	love.filesystem.write(path, ser(table))
end

function data:load(path)
	return love.filesystem.load(path)()
end

return data