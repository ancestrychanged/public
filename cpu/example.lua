local Types = require(game.ServerScriptService.types)
local Flags = require(game.ServerScriptService.flags)
local CPU = require(game.ServerScriptService.cpu)
local Instructions = require(game.ServerScriptService.instructions)

local function print_list(lst)
	for i = 1, #lst - 1 do
		print(lst[i] .. ",")
	end
	print(lst[#lst])
end

local function print_registers(c)
	for i = 0, 7 do
		print(c.r[i])
	end
end

local function run()
	local mem = {
		Instructions.LII, 0, 1,       -- LII R0, 1
		Instructions.LII, 1, 5,       -- LII R1, 5
		Instructions.MOV, 2, 0,       -- MOV R2, R0
		Instructions.MUL, 0, 1,       -- MUL R0, R1
		Instructions.SUB, 1, 2,       -- SUB R1, R2
		Instructions.CMP, 1, 0,       -- CMP R1, R0
		Instructions.JNZ, 21,         -- JNZ to PSH
		Instructions.PSH, 0,          -- PSH R0
		Instructions.POP, 7,          -- POP to R7
		Instructions.LII, 6, 2,       -- LII R6, 2
		Instructions.DIV, 7, 6,       -- DIV R7, R6
		Instructions.STI, 42, 7,      -- STI R7 to mem[42]
		Instructions.LDI, 5, 42,      -- LDI R5 from mem[42]
		Instructions.ADD, 7, 2,       -- ADD R7, R2
		Instructions.HLT              -- HLT
	}

	local c = Types.new_cpu(mem, #mem)
	CPU.run_cpu(c)
	print_registers(c)
end

run()
