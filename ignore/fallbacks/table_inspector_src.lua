
--[[
    Table Inspector
    
    -- Save to file:
    local path = inspector.save(tbl)

    -- Copy to clipboard:
    local _, str = inspector.copy(tbl)

    By yours truly,
        Dave

    ancestrychanged.com/socials
]]

local inspector = {}

local confdig = {
    depth = 50,
    sortkeys = true,
    showmt = true,
    maxstringlen = 1000,
}

local function isidentifier(str)
    return type(str) == 'string' and str:match('^[_%a][_%w]*$') ~= nil
end

local function escapestring(s, maxlen)
    if maxlen and #s > maxlen then
        s = s:sub(1, maxlen) .. '...<truncated ' .. (#s - maxlen) .. ' chars>'
    end

    return string.format('%q', s)
end

local function getinstancepath(inst)
    local parts = {}
    local current = inst
    
    while current and current ~= game do
        local name = current.Name
        local parent = current.Parent
        
        if isidentifier(name) then
            table.insert(parts, 1, name)
        else
            --thx claude for helping with... whatever the fuck this next line is
            table.insert(parts, 1, `["{name:gsub('"', '\\"')}"]`)
        end
        
        current = parent
    end
    
    if #parts == 0 then
        return tostring(inst)
    end
    
    local path = 'game'
    for i, part in ipairs(parts) do
        if part:sub(1, 1) == '[' then
            path ..= part
        else
            path ..= `.{part}`
        end
    end
    
    return path
end

local function sortkeys(keys)
    table.sort(keys, function(a, b)
        local ta, tb = typeof(a), typeof(b)
        if ta == tb then
            if ta == 'string' or ta == 'number' then
                return a < b
            end

            return tostring(a) < tostring(b)
        end
        
        local rank = {
            string = 1, number = 2, boolean = 3,
            ['nil'] = 4, table = 5, ['function'] = 6,
            userdata = 7, thread = 8, Instance = 9
        }
        return (rank[ta] or 99) < (rank[tb] or 99)
    end)
end

local function serializerobloxtype(v, t, options)
    local handlers = {
        Instance = function() return `<{v.ClassName}> {getinstancepath(v)}` end,
        -- vec3/2 __tostring is already 'x, y, z' so jkust wrap it
        Vector3 = function() return `Vector3.new({v})` end,
        Vector2 = function() return `Vector2.new({v})` end,
        BrickColor = function() return `BrickColor.new('{v.Name}')` end,
        Color3 = function() return `Color3.new({v.R}, {v.G}, {v.B})` end,
        UDim = function() return `UDim.new({v.Scale}, {v.Offset})` end,
        UDim2 = function()
            return `UDim2.new({v.X.Scale}, {v.X.Offset}, {v.Y.Scale}, {v.Y.Offset})`
        end,
        CFrame = function() -- i hate cframe math
            local rx, ry, rz = v:ToOrientation()
            return `CFrame.new({v.Position}) * CFrame.Angles({rx}, {ry}, {rz})`
        end
        -- TODO: add more datatypes (as if im gonna do it lmfao)
    }

    if handlers[t] then
        return handlers[t]()
    end
    
    return nil 
end

local function serializevalue(v, options)
    local t = typeof(v)
    
    if t == 'string' then
        return escapestring(v, options.maxstringlen)
    elseif t == 'number' then
        if v == math.huge then return 'math.huge'
        elseif v == -math.huge then return '-math.huge'
        else return tostring(v)
        end
    elseif t == 'boolean' then
        return tostring(v)
    elseif t == 'nil' then
        return 'nil'
    elseif t == 'function' then 
        -- thx @XNORAshley so i can copy and paste this without your consent muahahha
        local info = ""
        local dinfo = debug.getinfo(v)
        
        if dinfo.what == "C" then
            local name = dinfo.name
            if name and name ~= "" then
                info = ` "{name}" [C]`
            else
                info = " [C]"
            end
        else
            local name = dinfo.name
            local short_src = dinfo.short_src or dinfo.source
            local line = dinfo.currentline
            local nups = dinfo.nups
            local numparams = dinfo.numparams or 0
            local is_vararg = dinfo.is_vararg == true or dinfo.is_vararg == 1
            
            local funcName = (name and name ~= "") and `"{name}"` or "<anonymous>"
            info = ` {funcName}`
            
            if short_src ~= "" then
                info ..= ` {short_src}`
                if line > 0 then
                    info ..= `:{line}`
                end
            end
            
            if is_vararg then
                info ..= ` ({numparams}+)`
            else
                info ..= ` ({numparams})`
            end
            
            if nups > 0 then
                info ..= ` [^{nups}]`
            end
        end
        
        return `<function{info} {v}>`
    
    elseif t == 'thread' then
        return '<thread ' .. tostring(v) .. '>'
        
    elseif t == 'userdata' then
        return '<userdata ' .. tostring(v) .. '>'
    end
    
    local roblox = serializerobloxtype(v, t, options)
    if roblox then
        return roblox
    end
    
    return '<' .. t .. ' ' .. tostring(v) .. '>'
end

local function inspect(v, options, seen, path, depth, indentlevel)
    local t = typeof(v)
    
    if t ~= 'table' then
        return serializevalue(v, options)
    end
    
    
    if seen[v] then
        return '<cycle -> ' .. seen[v] .. '>'
    end
    
    
    if depth >= options.depth then
        return '<depth table ' .. tostring(v) .. '>'
    end
    
    seen[v] = path
    
    
    local keys = {}
    local count = 0
    for k in pairs(v) do
        count = count + 1
        keys[#keys + 1] = k
    end
    
    if options.sortkeys then
        sortkeys(keys)
    end
    
    local pieces = {}
    local nextindent = indentlevel + 4 --yk... like 4? 4 spaces? thats default in vscode
    local prefix = string.rep(' ', nextindent)
    local shown = 0
    
    for _, k in ipairs(keys) do
        shown +=1
        
        local keyrepr
        if type(k) == 'number' then
            keyrepr = '[' .. k .. ']'
        elseif isidentifier(k) then
            keyrepr = k
        else
            keyrepr = '[' .. inspect(k, options, seen, path .. '[key]', depth + 1, nextindent) .. ']'
        end

        local ok, val = pcall(function() return v[k] end) -- I'VE SKIDDED THESE SCRIPTS BEFORE!!! 
        local valrepr
        if ok then
            valrepr = inspect(val, options, seen, path .. '.' .. tostring(k), depth + 1, nextindent)
        else
            valrepr = '<error reading value>'
        end
        
        pieces[#pieces + 1] = prefix .. keyrepr .. ' = ' .. valrepr
    end
    
    if options.showmt then
        local mt = getmetatable(v)
        if mt ~= nil then
            if type(mt) == 'string' then -- 'This metatable is locked' or smth i forgo
                local rawmt = getrawmetatable(v)
                local rostatus = isreadonly(rawmt) or '?' -- ur executor sucks if u dont got isreadonly

                pieces[#pieces + 1] = prefix .. '__metatable = <locked: ' .. tostring(mt) .. '> (readonly: ' .. rostatus .. ') raw: ' .. inspect(rawmt, options, seen, path .. '.__metatable', depth + 1, nextindent)
            else
                pieces[#pieces + 1] = prefix .. '__metatable = ' .. inspect(mt, options, seen, path .. '.__metatable', depth + 1, nextindent)
            end
        end
    end
    
    seen[v] = nil
    
    if #pieces == 0 then
        return '{}'
    end
    
    return '{\n' .. table.concat(pieces, ',\n') .. '\n' .. string.rep(' ', indentlevel) .. '}'
end

local function ensuredir(path)
    if not isfolder(path) then
        makefolder(path)
    end
end

local function generatefilename(basename)
    local timestamp = os.date('%Y%m%d_%H%M%S')
    local name = basename or 'dump'
    name = name:gsub('[^%w_%-]', '_')
    return name .. '_' .. timestamp .. '.lua'
end

function inspector.dump(value, options)
    options = options or {}
    
    for k, v in pairs(confdig) do
        if options[k] == nil then
            options[k] = v
        end
    end
    
    local exec = identifyexecutor or getexecutorname
    local executor = 'Unknown'
    if exec then
        local name = exec()
        if name then
            executor = name
        end
    end
    
    local header = `-- [[ Dump: {os.date('%Y-%m-%d %H:%M:%S')} | Type: {typeof(value)} | Executor: {executor} ]] --\n\n`
    
    return header .. inspect(value, options, {}, 'root', 0, 0)
end

function inspector.save(value, name, options)
    local content = inspector.dump(value, options)
    local filename = generatefilename(name)
    
    ensuredir('inspector_dumps')
    
    local filepath = 'inspector_dumps/' .. filename
    
    writefile(filepath, content)
    return filepath, content
end

function inspector.copy(value, options)
    local content = inspector.dump(value, options)
    print('copied!')
    setclipboard(content)
    return true, content
end

function inspector.append(filepath, value, options)
    options = options or {}
    for k, v in pairs(confdig) do
        if options[k] == nil then options[k] = v end
    end
    
    local entry = `\n\n-- [[ Append: {os.date('%Y-%m-%d %H:%M:%S')} | Type: {typeof(value)} ]] --\n` .. inspect(value, options, {}, 'root', 0, 0)
    
    appendfile(filepath, entry)
    return true
end

return inspector
