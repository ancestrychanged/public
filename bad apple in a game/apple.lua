assert(readfile, "your executor doesn't support readfile")
assert(listfiles, "your executor doesn't support listfiles")
assert(lz4decompress, "your executor doesn't support lz4decompress")
assert(getrawmetatable, "your executor doesn't support getrawmetatable")
assert(setreadonly, "your executor doesn't support setreadonly")
assert(newcclosure, "your executor doesn't support newcclosure")
assert(getnamecallmethod,"your executor doesn't support getnamecallmethod")
assert(checkcaller, "your executor doesn't support checkcaller")

local updatefps = game.ReplicatedStorage.FPSUpdateEventIKnowYouReCheater

local getid = getidentity or getthreadidentity
local setid = setidentity or setthreadidentity

local prev
if getid and setid then
	prev = getid()
	setid(3)
end

local mt = getrawmetatable(game)
setreadonly(mt,false)
local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
	if self == updatefps then
		local method = getnamecallmethod()
		if (method == 'FireServer' or method == 'fireServer') and not checkcaller() then
			return
		end
	end
	return old(self, ...)
end)

setreadonly(mt,true)
if setid and prev then
	setid(prev)
end

local folderpath = 'bad_apple'

local chunkFiles = {}
local d = 1 / 30

local function sort(list)
	table.sort(list, function(a, b)
		return tonumber(a:match('chunk_(%d+).txt')) < tonumber(b:match('chunk_(%d+).txt'))
	end)

	for i, name in ipairs(list) do
		list[i] = folderpath .. '/' .. name
	end
	
	return list
end


for _, p in ipairs(listfiles(folderpath)) do
	local filename = string.match(p, '[^/\\]+$')
	if filename and string.sub(filename, -4) == '.txt' and string.find(filename, 'chunk_') then
		table.insert(chunkFiles, filename)
	end
end

local sorted = sort(chunkFiles)
local fidx = 0
local startTime = os.clock()

for i, path in ipairs(sorted) do
	local content = readfile(path)
	local newlinePos = string.find(content, '\n', 1, true)
	local headerLine = string.sub(content, 1, newlinePos - 1)
	local bin = string.sub(content, newlinePos + 1)

	local strtable = headerLine:split(',')
	local frames = {}
	
	for _, pair in ipairs(strtable) do
		local compStr, origStr = string.match(pair, '^(%d+):(%d+)$')
		local compNum = tonumber(compStr)
		local origNum = tonumber(origStr)
		table.insert(frames, {comp = compNum, orig = origNum})
	end
	
	local cOffset = 1

	for _, pair in ipairs(frames) do
		local complen = pair.comp
		local originalLength = pair.orig
		
		if cOffset + complen - 1 > #bin then break end

		local compressed = string.sub(bin, cOffset, cOffset + complen - 1)
		local ok, frame = pcall(function()
			return lz4decompress(compressed, originalLength)
		end)
		
		if ok and frame then
			updatefps:FireServer(frame .. '\0')
		else
			warn(`failed to decompress frame {fidx + 1} (chunk {i})`)
		end

		fidx += 1
		cOffset += complen

		local ct = os.clock()
		local target = startTime + (fidx * d)
		local t = target - ct
		
		task.wait(math.max(0, t))
	end
end

--mt.__namecall = old
