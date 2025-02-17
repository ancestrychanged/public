local CPU = {}
local Types = require(game.ServerScriptService.types)
local Flags = require(game.ServerScriptService.flags)
local Instructions = require(game.ServerScriptService.instructions)
local debugMode = true

local function printf(...)
	if debugMode then
		print(...)
	end
end

-- fetch instruction
function CPU.fetch(c)
	c.pc = c.pc + 1
	
	if c.pc > #c.mem then
		printf("error: pc is oob")
		return
	end
	
	printf("fetching instruction at pc: " .. c.pc)
	printf("mem at pc: " .. tostring(c.mem[c.pc]))
	
	c.inst = bit32.band(c.mem[c.pc], Types.FIRST_BYTE)
	c.dest = c.mem[c.pc + 1]
	c.src = c.mem[c.pc + 2]
	
	printf("instruction: " .. c.inst)
	printf("destination: " .. c.dest)
	printf("source: " .. c.src)
end

function CPU.execute(c)
	if c.inst == Instructions.CL then
		Flags.clear_flags(c)
	elseif c.inst == Instructions.CMP then
		printf(`executing CMP: dest={c.dest}, src={c.src}`)
		Flags.set_flags(c, c.r[c.dest], c.r[c.src])
		c.pc = c.pc + 3
	elseif c.inst == Instructions.MOV then
		if c.dest < 0 or c.dest > 7 or c.src < 0 or c.src > 7 then
			error("invalid register for MOV")
		end
		c.r[c.dest] = c.r[c.src]
		c.pc = c.pc + 2
	elseif c.inst == Instructions.STI then
		c.mem[c.dest] = c.r[c.src]
		c.pc = c.pc + 2
	elseif c.inst == Instructions.LDI then
		c.r[c.dest] = c.mem[c.src]
		c.pc = c.pc + 2
	elseif c.inst == Instructions.JMP then
		c.pc = c.dest  -- set pc to the address in dest
	elseif c.inst == Instructions.JNZ then
		if c.zero == 0 then
			c.pc = c.dest  -- jmp to address if not zero
		else
			c.pc = c.pc + 1  -- skip address operand
		end
	elseif c.inst == Instructions.ADD then
		c.r[c.dest] = c.r[c.dest] + c.r[c.src]
		c.pc = c.pc + 2
	elseif c.inst == Instructions.SUB then
		c.r[c.dest] = c.r[c.dest] - c.r[c.src]
		c.pc = c.pc + 2
	elseif c.inst == Instructions.MUL then
		c.r[c.dest] = c.r[c.dest] * c.r[c.src]
		c.pc = c.pc + 2
	elseif c.inst == Instructions.DIV then
		if c.r[c.src] ~= 0 then
			c.r[c.dest] = c.r[c.dest] / c.r[c.src]
		else
			error("div by zero")
		end
		c.pc = c.pc + 2
	elseif c.inst == Instructions.PSH then
		c.mem[c.sp] = c.r[c.dest]
		c.sp = c.sp - 1
		c.pc = c.pc + 1  -- PSH has one operand (dest)
	elseif c.inst == Instructions.POP then
		c.sp = c.sp + 1
		c.r[c.dest] = c.mem[c.sp]
		c.pc = c.pc + 1  -- POP has one operand (dest)
	elseif c.inst == Instructions.LII then
		c.r[c.dest] = c.src  -- load immediate value into R[dest]
		c.pc = c.pc + 2      -- advance pc by 2 (opcode + 2 operands)
	elseif c.inst == Instructions.HLT then
		return
	end
end

function CPU.run_cpu(c)
	while c.inst ~= Instructions.HLT do
		CPU.fetch(c)
		CPU.execute(c)
	end
end

return CPU
