--A layer for ser.lua for no particular reason.

local data = {}

function data:save(path, table)
	love.filesystem.write(path, ser(table))
end

function data:load(path)
	return love.filesystem.load(path)()
end

return data