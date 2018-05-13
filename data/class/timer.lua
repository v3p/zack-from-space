local timer = {
	array = {}
}

function timer:call(code, time)
	self.array[#self.array + 1] = {
		code = code,
		time = time
	}
end

function timer:update(dt)
	for i,v in ipairs(self.array) do
		v.time = v.time - dt
		if v.time < 0 then
			loadstring(v.code)()
			table.remove(self.array, i)
		end
	end
end

return timer