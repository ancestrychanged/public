local Flags = {}

-- clear flags
function Flags.clear_flags(c)
	c.zero = 0
	c.ltz = 0
	c.gtz = 0
end

-- set flags based on integer comparison
function Flags.set_flags(c, a, b)
	if a == nil or b == nil then
		warn(`err: invalid register values (a: {tostring(a)}, b: {tostring(b)}`)
		return
	end
	local res = a - b
	c.zero = (res == 0) and 1 or 0
	c.ltz = (res < 0) and 1 or 0
	c.gtz = (res > 0) and 1 or 0
end

-- set flags based on float comparison
function Flags.fset_flags(c, a, b)
	local res = a - b
	c.zero = (res == 0) and 1 or 0
	c.ltz = (res < 0) and 1 or 0
	c.gtz = (res > 0) and 1 or 0
end

return Flags
