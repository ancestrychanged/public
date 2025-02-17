local Types = {}

Types.FIRST_BYTE = 0x00000000000000FF
Types.NUM_REGISTERS = 16  -- 8 integer and 8 float registers

-- register enums (R0 - R7, F0 - F7)
Types.registers = {
	R0 = 0, R1 = 1, R2 = 2, R3 = 3, R4 = 4, R5 = 5, R6 = 6, R7 = 7,
	F0 = 8, F1 = 9, F2 = 10, F3 = 11, F4 = 12, F5 = 13, F6 = 14, F7 = 15
}

-- CPU structure
Types.cpu = {
	mem = {},
	max_mem = 0,
	pc = -1,
	sp = 0,
	r = {},
	fr = {},
	inst = 0,
	dest = 0,
	src = 0,
	zero = 0,
	ltz = 0,
	gtz = 0
}

function Types.new_cpu(memory, mem_size)
	local c = {}
	setmetatable(c, { __index = Types.cpu })
	c.mem = memory
	c.sp = mem_size - 1
	c.max_mem = mem_size
	c.pc = 0
	c.inst = 0
	for i = 0, 7 do
		c.r[i] = 0
		c.fr[i] = 0.0
	end
	return c
end

return Types
